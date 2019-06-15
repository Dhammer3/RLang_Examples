library(shiny)
#define
file_input_label <-  "This is the file label"
file_types=c(" ",".csv", "some_other_weird_file_type")


 ui <- fluidPage(
      selectInput(inputId ="n","Select the File Type ",choices=file_types),
      fileInput("csvFile", file_input_label),
      tableOutput("rawData"),
      tableOutput("modifiedData")
     #plotOutput(outputId="hist")


 )
 server  <- function(input, output)
 {
     #
     output$hist <-  renderPlot ({
         hist(rnorm(input$n))
     })
     #read in the file
     rawData <- eventReactive(input$csvFile, {
       read.csv(input$csvFile$datapath)
     })
     #construct a table from the file
     output$rawData <- renderTable({
       rawData() %>% head
     })
     #do manipulation to the data and store in the var modifiedData for ui display
     output$modifiedData <- renderTable({
       rawData() %>% mutate(sum = speed + dist) %>% head
     })


 }
 shinyApp (ui=ui, server=server)
