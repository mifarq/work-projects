library(shiny)
library(DT)
library(rio)

data <- rio::import("https://data.sba.gov/dataset/4ad86088-4c7b-4525-9562-ecd9488916c9/resource/33270c2a-f1c5-4dcb-bc98-aedcaec19ef3/download/awards-as-of-9-27.xlsx")

ui <- basicPage(
    h2("Shuttered Venue Operators Grantees Data"),
    DT::dataTableOutput("mytable")
)

server <- function(input, output) {
    output$mytable = DT::renderDataTable({
        data
    })
}

shinyApp(ui, server)
