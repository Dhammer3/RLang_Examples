#this file shows an example of setting colors and gradients in a modular way for R graphs
#install.packages("ggplot2")

#install.packages("extrafont")
install.packages("leaflet")
windowsFonts(A = windowsFont("Arial"))
library("ggplot2")
library("extrafont")
library("leaflet")

#set the colors
color_asu_maroon <- ("#8c1d40")
color_asu_gold <- ("#FFC627")
color_asu_green <- ("#78be20")
color_asu_blue <- ("#00A3E0")
color_asu_orange <- ("#ff7f32")
color_asu_grey <- ("#5c6670")
color_asu_black <-("#000000")
color_asu_white <-("#FFFFFF")


#append them to the standard color pallette
asu_color_pallete<- c(color_asu_maroon, color_asu_orange, color_asu_gold, color_asu_green, color_asu_blue)

pallette <- colorRampPalette(asu_color_pallete)
#warning: this gradient technique should be used with a small data set.
x=(1:10)
length(x)
barplot(x, pch =15, col=pal(length(x)))
w <- #38c1d4o

#used when more than two groups need to be displayed, ASU secondary colors should be used.
#color assignments for each group should be consistent

raw_data <- read.delim2("/Users/mydesktop/desktop/r/AA_PROFILE_EXT.txt")
raw_data

#this function produces a pie plot IAW ASU standards from raw data and a parameter
standard_ASU_pie_plot <- function(raw_data, param, title)
{
    #trim the data by creating a subset from the colnames
    trimmed <- subset(raw_data, select=c(param))

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
    names <- trimmed_data[,1]
    #get a vector of the values of the metrics
    values <- trimmed_data[,2]

    pct <- round(values/sum(values)*100)
    #add percentages to the labels
    names <- paste(names,pct)
    names <- paste(names, "%", sep="")#add % to labels

    #plot the pie chart
    pie(family="A",values, labels = names, main=title, col=asu_color_pallete, edges= 200, clockwise=TRUE)

}

#used when displaying high to low differences, gradient is set from ASU maroon -> ASU blue
standard_ASU_gradient_bar_plot <- function(data, x_label, y_label, title)
{
    pal <- colorRampPalette(asu_color_pallete)
    data <- sort(data)
     barplot(xlab=x_label, ylab=y_label,main=title, family ="A", data,pch =15, col=pal(length(data)))
}

title <- "chart title"
data <- runif( 20, min=1, max=100)
x_label="x lab"
y_label="y lab"

standard_ASU_gradient_bar_plot(data, x_label,y_label, title)

standard_ASU_pie_plot(raw_data, 'AFFINITY_RATING', "example pie pie")
