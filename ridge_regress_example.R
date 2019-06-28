setwd("D:/R/HUB")

alumni<-read.csv("Alumni-working.csv")

# Create a Shiny app that takes as input a set of id numbers, and provides a list of id numbers
# of alumni who 'look like' those uploaded. 

library(rsample)
library(glmnet)
library(dplyr)
library(ggplot2)
library(Matrix)

# Create training (70%) and test (30%) sets
# Use set.seed for reproducibility

set.seed(42) #set seed for reproducibility

n<-1000 #number of observations
p<-670 #number of predictors included in model
real_p<-15 #Number of true predictors

##Generate the data
x<-matrix(rnorm(n*p), nrow=n, ncol=p)
y<-apply(x[,1:real_p], 1, sum)+ rnorm(n)

##Spilt data into traing/testing datasets. 
##2/3rd for training, 1/3rd for testing
train_rows <- sample(1:n, .66*n)
x.train <- x[train_rows, ]
x.test <- x[-train_rows, ]

y.train <- y[train_rows ]
y.test <- y[-train_rows ]

## Now we will use 10-fold Cross Validation to determine the
## optimal value for lambda for...

alpha0.fit<-cv.glmnet(x.train, y.train, type.measure="mse", alpha=0, family="gaussian")
alpha0.predicted <- predict(alpha0.fit, s=alpha0.fit$lambda.1se, newx=x.test)

mean((y.test-alpha0.predicted)^2)

alpha1.fit <- cv.glmnet(x.train, y.train, type.measure="mse", 
                        alpha=1, family="gaussian")

alpha1.predicted <- 
  predict(alpha1.fit, s=alpha1.fit$lambda.1se, newx=x.test)

mean((y.test - alpha1.predicted)^2)

alpha0.5.fit <- cv.glmnet(x.train, y.train, type.measure="mse", 
                          alpha=0.5, family="gaussian")

alpha0.5.predicted <- 
  predict(alpha0.5.fit, s=alpha0.5.fit$lambda.1se, newx=x.test)

mean((y.test - alpha0.5.predicted)^2)

list.of.fits <- list()
for (i in 0:10) {
  ## Here's what's going on in this loop...
  ## We are testing alpha = i/10. This means we are testing
  ## alpha = 0/10 = 0 on the first iteration, alpha = 1/10 = 0.1 on
  ## the second iteration etc.
  
  ## First, make a variable name that we can use later to refer
  ## to the model optimized for a specific alpha.
  ## For example, when alpha = 0, we will be able to refer to 
  ## that model with the variable name "alpha0".
  fit.name <- paste0("alpha", i/10)
  
  ## Now fit a model (i.e. optimize lambda) and store it in a list that 
  ## uses the variable name we just created as the reference.
  list.of.fits[[fit.name]] <-
    cv.glmnet(x.train, y.train, type.measure="mse", alpha=i/10, 
              family="gaussian")
  ## Now we see which alpha (0, 0.1, ... , 0.9, 1) does the best job
  ## predicting the values in the Testing dataset.
  results <- data.frame()
  for (i in 0:10) {
    fit.name <- paste0("alpha", i/10)
    
    ## Use each model to predict 'y' given the Testing dataset
    predicted <- 
      predict(list.of.fits[[fit.name]], 
              s=list.of.fits[[fit.name]]$lambda.1se, newx=x.test)
    
    ## Calculate the Mean Squared Error...
    mse <- mean((y.test - predicted)^2)
    
    ## Store the results
    temp <- data.frame(alpha=i/10, mse=mse, fit.name=fit.name)
    results <- rbind(results, temp)
  }
  
  ## View the results
