library(shiny)
library(DT)
library(rio)
library(tidyverse)

data <- rio::import("https://data.sba.gov/dataset/8aa276e2-6cab-4f86-aca4-a7dde42adf24/resource/be89502c-1961-4a79-a44c-979eb3f411a8/download/public_150k_plus_210630.csv")

target <- c("BorrowerName", "BorrowerAddress","BorrowerCity", 
            "BorrowerState", "BorrowerZip", "LoanStatus", 
            "CurrentApprovalAmount", "OriginatingLender", 
            "CD", "NAICSCode", "JobsReported", "ForgivenessAmount", "ForgivenessDate")

data = subset(data, select = target)

ppp <- basicPage(
    h2("PPP Data"),
    DT::dataTableOutput("mytable")
)

server <- function(input, output) {
    output$mytable = DT::renderDataTable({
        data
    })
}

shinyApp(ppp, server)
