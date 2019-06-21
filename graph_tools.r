#this file shows an example of setting colors and gradients in a modular way for R graphs

#set the colors 
color_asu_maroon <- ("#8c1d40")
color_asu_gold <- ("#FFC627")
color_asu_green <- ("#78be20")
color_asu_blue <- ("#00A3E0")
color_asu_orange <- ("#ff7f32")
color_asu_grey <- ("#5c6670")

#append them to the color pallette
asu_color_pallete<- c(color_asu_maroon, color_asu_orange, color_asu_gold, color_asu_green,color_asu_blue)
pal <- colorRampPalette(asu_color_pallete)
#warning: this gradient technique should be used with a small data set.
x=(1:10)
length(x)
barplot(x,pch =15, col=pal(length(x)))
w <- #38c1d4o
asu_color_gradient=c()
