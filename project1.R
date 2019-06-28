setwd("D:/R/HUB")

alumni<-read.csv("Alumni-working.csv")

alumni.1<-alumni[complete.cases(alumni), ]

# Create a Shiny app that takes as input a set of id numbers, and provides a list of id numbers
# of alumni who 'look like' those uploaded. 

library(rsample)
library(glmnet)
library(dplyr)
library(ggplot2)
library(tidyr)
# Create training (70%) and test (30%) sets
# Use set.seed for reproducibility

set.seed(123)

alumni_split<-initial_split(alumni.1, prop=.7, strata = "PERSON_ID")
alumni_train<-training(alumni_split)
alumni_test<-testing(alumni_split)

#----
# Create training and testing feature model matrices and response vectors.
# we use model.matrix(...)[, -1] to discard the intercept
alumni_train_x <- model.matrix(PERSON_ID ~ ., alumni_train)[, -1]
alumni_test_x <- model.matrix(PERSON_ID ~ ., alumni_test)[, -1]

alumni_train_y <- log(alumni_train$PERSON_ID)
alumni_test_y <- log(alumni_test$PERSON_ID)

# What is the dimension of of your feature matrix?
dim(alumni_train_x)

#----
# Apply Ridge regression to ames data
  alumni_ridge <- glmnet(alumni_train_x, 
                         alumni_train_y, 
                         alpha = 0)

plot(alumni_ridge, xvar = "lambda")
#-----
# lambdas applied to penalty parameter
alumni_ridge$lambda %>% head()

#------
# Apply CV Ridge regression to ames data
  alumni_ridge <- cv.glmnet(
  alumni_train_x,
  alumni_train_y,
  alpha = 0
)

# plot results
plot(alumni_ridge)
#-----
min(alumni_ridge$cvm)       # minimum MSE
alumni_ridge$lambda.min     # lambda for this min MSE

alumni_ridge$cvm[alumni_ridge$lambda == alumni_ridge$lambda.1se]  # 1 st.error of min MSE
alumni_ridge$lambda.1se  # lambda for this MSE
#-----
alumni_ridge_min <- glmnet(
  alumni_train_x,
  alumni_train_y,
  alpha = 0
)

plot(alumni_ridge_min, xvar = "lambda")
abline(v = log(alumni_ridge$lambda.1se), col = "red", lty = "dashed")
#-------
  coef(alumni_ridge, s = "lambda.1se") %>%
  tidy() %>%
  filter(row != "(Intercept)") %>%
  top_n(25, wt = abs(value)) %>%
  ggplot(aes(value, reorder(row, value))) +
  geom_point() +
  ggtitle("Top 25 influential variables") +
  xlab("Coefficient") +
  ylab(NULL)
##got error message: Error in UseMethod("tidy"): 
##no applicable method for 'tidy' applied to an object of class "c(dgCMatrix', 'CsparseMatrix', 'dsparseMatrix', 'generalMatrix', 'dCsparseMatrix', 'dMatrix', 'sparseMatrix', 'compMatrix', 'Matrix', 'xMatrix', 'mMatrix', 'Mnumeric', 'replValueSp')"
#------
  ## Apply lasso regression to alumni.1 data
  alumni_lasso <- glmnet(
    x = alumni_train_x,
    y = alumni_train_y,
    alpha = 1
  )

plot(alumni_lasso, xvar = "lambda")
#----
  # Apply CV Ridge regression to ames data
  alumni_lasso <- cv.glmnet(
    alumni_train_x,
    alumni_train_y,
    alpha = 1
  )
# plot results
plot(alumni_lasso)
#----
  min(alumni_lasso$cvm)       # minimum MSE
alumni_lasso$lambda.min     # lambda for this min MSE

alumni_lasso$cvm[alumni_lasso$lambda == alumni_lasso$lambda.1se]  # 1 st.error of min MSE
alumni_lasso$lambda.1se  # lambda for this MSE
#-----
  alumni_lasso_min <- glmnet(
    alumni_train_x,
    alumni_train_y,
    alpha = 1
  )

plot(alumni_lasso_min, xvar = "lambda")
abline(v = log(alumni_lasso$lambda.min), col = "red", lty = "dashed")
abline(v = log(alumni_lasso$lambda.1se), col = "red", lty = "dashed")
#------
  coef(alumni_lasso, s = "lambda.1se") %>%
  tidy() %>%
  filter(row != "(Intercept)") %>%
  ggplot(aes(value, reorder(row, value), color = value > 0)) +
  geom_point(show.legend = FALSE) +
  ggtitle("Influential variables") +
  xlab("Coefficient") +
  ylab(NULL)
#-----
  # minimum Ridge MSE
  min(alumni_ridge$cvm)

# minimum Lasso MSE
  min(alumni_lasso$cvm)
#----
  lasso  <- glmnet(alumni_train_x, alumni_train_y, alpha = 1.0) 
elastic1 <- glmnet(alumni_train_x, alumni_train_y, alpha = 0.25) 
elastic2 <- glmnet(alumni_train_x, alumni_train_y, alpha = 0.75) 
ridge    <- glmnet(alumni_train_x, alumni_train_y, alpha = 0.0)

par(mfrow = c(2, 2), mar = c(6, 4, 6, 2) + 0.1)
plot(lasso, xvar = "lambda", main = "Lasso (Alpha = 1)\n\n\n")
plot(elastic1, xvar = "lambda", main = "Elastic Net (Alpha = .25)\n\n\n")
plot(elastic2, xvar = "lambda", main = "Elastic Net (Alpha = .75)\n\n\n")
plot(ridge, xvar = "lambda", main = "Ridge (Alpha = 0)\n\n\n")
#-----
  # maintain the same folds across all models
  fold_id <- sample(1:10, size = length(alumni_train_y), replace=TRUE)

# search across a range of alphas
tuning_grid <- tibble::tibble(
  alpha      = seq(0, 1, by = .1),
  mse_min    = NA,
  mse_1se    = NA,
  lambda_min = NA,
  lambda_1se = NA
)
#-----
  for(i in seq_along(tuning_grid$alpha)) {
    
    # fit CV model for each alpha value
    fit <- cv.glmnet(alumni_train_x, alumni_train_y, alpha = tuning_grid$alpha[i], foldid = fold_id)
    
    # extract MSE and lambda values
    tuning_grid$mse_min[i]    <- fit$cvm[fit$lambda == fit$lambda.min]
    tuning_grid$mse_1se[i]    <- fit$cvm[fit$lambda == fit$lambda.1se]
    tuning_grid$lambda_min[i] <- fit$lambda.min
    tuning_grid$lambda_1se[i] <- fit$lambda.1se
  }

tuning_grid
## # A tibble: 11 x 5
##    alpha mse_min mse_1se lambda_min lambda_1se
##    <dbl>   <dbl>   <dbl>      <dbl>      <dbl>
##  1 0      0.0217  0.0241    0.136       0.548 
##  2 0.100  0.0215  0.0239    0.0352      0.0980
##  3 0.200  0.0217  0.0243    0.0193      0.0538
##  4 0.300  0.0218  0.0243    0.0129      0.0359
##  5 0.400  0.0219  0.0244    0.0106      0.0269
##  6 0.500  0.0220  0.0250    0.00848     0.0236
##  7 0.600  0.0220  0.0250    0.00707     0.0197
##  8 0.700  0.0221  0.0250    0.00606     0.0169
##  9 0.800  0.0221  0.0251    0.00530     0.0148
## 10 0.900  0.0221  0.0251    0.00471     0.0131
## 11 1.00   0.0223  0.0254    0.00424     0.0118
#----
  tuning_grid %>%
  mutate(se = mse_1se - mse_min) %>%
  ggplot(aes(alpha, mse_min)) +
  geom_line(size = 2) +
  geom_ribbon(aes(ymax = mse_min + se, ymin = mse_min - se), alpha = .25) +
  ggtitle("MSE ± one standard error")

#----
  # some best model
  cv_lasso   <- cv.glmnet(alumni_train_x, alumni_train_y, alpha = 1.0)
min(cv_lasso$cvm)

# predict
pred <- predict(cv_lasso, s = cv_lasso$lambda.min, alumni_test_x)
mean((alumni_test_y - pred)^2)

pred
