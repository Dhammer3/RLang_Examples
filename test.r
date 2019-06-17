install.packages("zipcode")
install.packages("dplyr")
install.packages("usmap")
install.packages("renderplot")

library(zipcode)
library(dplyr)
library(usmap)
library(ggplot2)
library(magrittr)

statepop
list_of_states <- statepop[2]
list_of_states

#read in a csv file
csv_fileName="/Users/D/Desktop/R_/repo/RLang_Examples/Example Upload File.csv"
data_frame <- read.csv(csv_fileName)
data_frame

error handling:
check if there are missing or null values
check if the id number !=9 digits
check that the data set contains at least 50 students for privacy concerns

#get a df of zipcodes
#data(zipcode)
#nrow(zipcode)

#get the 1st through len(data_frame) rows so the two df can be extended
#ew_zipcode <- zipcode[1:nrow(data_frame),]
#nrow(new_zipcode)

#combine the two dataframes
#data_frame <- cbind(data_frame, zipcode)



#combine the two data frames
data_frame <- cbind(data_frame, new_zipcode)
data_frame

#save the file to a csv
#data_frame <- write.csv(data_frame , csv_fileName)
#data_frame <- read.csv(csv_fileName)


#select specific columns from the data frame using dplyr
#method(1)
#data_frame %>%
#states <-   select(data_frame,state)
#states

#method(2) <- better
#  a <- table(data_frame['state'])
#  a

#find the frequency of each student in each state
  data_frame
  students_in_each_state
  students_in_each_state <- as.data.frame(table(data_frame['state']))


  #change the colnames in the dataset to match the req args for plot_usmap func
  colnames(students_in_each_state) <- c("state", "num_students")
  students_in_each_state

#change the data type of col 1 to character as req by plot_usmap func
students_in_each_state[,1] <-sapply(students_in_each_state[,1], as.character)
#students_in_each_state[,2] <-as.double(students_in_each_state$num_students)
#students_in_each_state




students_in_each_state

#students_in_each_state =as.character(as.character(students_in_each_state["state"]))

  #get the total of a specific occurance
  #a[names(a)=="NH"]

statepop
plot_usmap(data = students_in_each_state, values = "num_students", lines = "red") +
  scale_fill_continuous(
    low = "white", high = "red", name = "Population (2015)", label = scales::comma
  ) + theme(legend.position = "right")
