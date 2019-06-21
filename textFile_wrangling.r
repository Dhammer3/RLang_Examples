
5+5
library(dplyr)
library(sqldf)

raw_data <- read.delim2("/Users/mydesktop/desktop/r/AA_PROFILE_EXT.txt")
raw_data

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

#rename the first col to metrics
names(trimmed_data)[1] <- "metrics"

trimmed_data
#get a vector of the names of all metrics
names=trimmed_data[,1]
#get a vector of the values of the metrics
values=trimmed_data[,2]

pie(values, labels = names, main="Pie Chart of Countries", co)

#example of a sql accessor
sqldf("select * from raw_data where EMAIL_ADDRESS = 'dhammer4@asu.edu' ")

X =c(1:100)
plot(X)
