install a package
install.packages("dslabs")

see all objects saved in the workspace
ls()

objects

 `for` loop to add corresponding elements in each vector
 for (i in seq_along(x)) {
     z[i] <- x[i] + y[i]
     print(z)
 }

data types
dataframe


create a dataframe
library needed:
library(dslabs)

load the data frame
data("murders")
class(murders)

show the structure of an objects
str(murders)

show the class type of an objects
class()

show the first 6 lines of a data dataframe
head(murders)

access data from the dataframe object
use the $ symbol, called the accessor
ex: murders$population ()

get the names of the columns in a data frame object
names(murders)

define a new object to take on the columns in a data set
pop <- murders$population

get the length of the vector pop
length(pop)

get a data element as a character
"a"

factors
factors are useful for storing categorical data

each factor has a particular number of levels

access levels
levels(murders$region)

saving data in this format is more memory efficient
factors are also a source of confusion, can be confused with character data types
try to avoid factors unless you know what you are doing.

class()
 We extract the population like this:
p <- murders$abb

 This is how we do the same with the square brackets:
o <- murders[["abb"]]

 We can confirm these two are the same
identical(o, p)

 Use square brackets to extract `abb` from `murders` and assign it to b
a<-murders$abb
b <- murders[["abb"]]
 Check if `a` and `b` are identical
identical(o, p)

use two functions in a nested way to determine the number of unique categories.
 Determine the number of regions included in this variable
length(levels(((murders$region))))

the function class helps to determine the data type of an objects

the most common way of storing datasets in R is with dataframes


vectors
initialize a vector:
x<-c("1","2")

assign a code to a data value in a vector
codes <- c(italy=300, canada=200, egypt=912)

create a vector from 1-10
seq(1,10)

create a vector of odd values from 1-10
seq(1,10,2)

shorthand representation of the above:
1:10

subsetting
we use [] to access specific elements of a vector
access canada
codes[2]

turn number into character
as.character()

turn character into number
as.numeric
 Access population values from the dataset and store it in pop
pop <- murders$pop
 Sort the object and save it in the same object
pop <- sort(pop)
 Report the smallest population size
pop[1]

 Access population from the dataset and store it in pop
pop <- murders$population

 Use the command order, to order pop and store in object o
o <- order(pop)

 Find the index number of the entry with the smallest population size
o[1]
 Find the smallest value for variable total
which.min(murders$total)

 Find the smallest value for population
 which.min(murders$population)
5+5
