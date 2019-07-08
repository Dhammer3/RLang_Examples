
5+5
library(dplyr)
library(sqldf)
library(ggplot2)
library(usmap)

library(tidyr)
library(tidyverse)

raw_data <- read.delim2("/Users/mydesktop/desktop/r/AA_PROFILE_EXT.txt")

write.csv(raw_data,file="C:/Users/mydesktop/Desktop/R/project1/RLang_Examples/raw_data.csv")

example_csv <- read.csv("C:/Users/mydesktop/Desktop/R/project1/RLang_Examples/Ex_upload.csv")
example_csv

#create vector of random numbers
faux_donation_info <- runif( nrow(example_csv), min=1, max=10000)
#convert it to a dataframe
faux_donation_info <- as.data.frame(faux_donation_info)
#merge it back into the main database
example_csv <- merge(example_csv, faux_donation_info)

write.csv(faux_donation_info,file="C:/Users/mydesktop/Desktop/R/project1/RLang_Examples/faux_donation_info.csv")
#write the file to example_csv
write.csv(example_csv,file="C:/Users/mydesktop/Desktop/R/project1/RLang_Examples/Ex_upload.csv")

#trim the data by creating a subset from the colnames
trimmed <- subset(raw_data, select=c('AFFINITY_RATING'))

#convert the data to a data frame to ease manipulation
trimmed <- as.data.frame(trimmed)

#find the rows with empty vals and set them to NA
trimmed[trimmed==""] <- NA

#exlude the NA vals from the data set
trimmed <- na.omit(trimmed)

#convert the df to a table to count the number of occurances, and then back to a df
trimmed_data <- as.data.frame(table(trimmed))

#clean the data again
trimmed_data[trimmed_data==""] <- NA
trimmed_data <- na.omit(trimmed_data)

#change the data type of the first col
trimmed_data[,1] <- sapply(trimmed_data[,1], as.character)

#using tidy and tidyverse...
#https://r4ds.had.co.nz/tidy-data.html
#show the donationa amounts per state.
data%>%
count(state, wt=Donation_amount)

#rename the first col to metrics
names(trimmed_data)[1] <- "metrics"

trimmed_data

#get a vector of the names of all metrics
names=trimmed_data[,1]

#get a vector of the values of the metrics
values=trimmed_data[,2]

pie(values, labels = names, main="Pie Chart of Countries", co)

#example of a sql accessor
sqldf("select * from raw_data where LAST_NAME = 'dipert' ")

X =c(1:100)
plot(X)
