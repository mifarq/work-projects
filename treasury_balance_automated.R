setwd("/Users/mfarquharson/Code/CMU")

library(forecast)
library(ggplot2)
library(plotly)
library(RCurl)
library(readxl)
library(tidyverse)
library(ggthemr)

ggthemr("pale")

# Load URL using API. See API documentation to see what I did https://fiscaldata.treasury.gov/api-documentation/

url_api <- "https://api.fiscaldata.treasury.gov/services/api/fiscal_service/v1/accounting/dts/dts_table_1?format=csv&fields=record_date,account_type,close_today_bal,record_calendar_year&filter=record_calendar_year:in:(2020,2021)&page[number]=1&page[size]=6000"
dts <- read_csv(getURL(url_api))

# Filter for just Fed in Account Type
dts <- dts %>% filter(account_type == "Federal Reserve Account")

## Setting Plotly API and UN

Sys.setenv("plotly_username"="mfarq")
Sys.setenv("plotly_api_key"="qrD6m7CM5ulEVYI8uIvn")

## Changing Column Names

colnames(dts)
names(dts)[names(dts) == "record_date"] <- "Date"
names(dts)[names(dts) == "close_today_bal"] <- "Closing Balance"

## Reading data

#dts <- read.csv("dts.csv", header = T)
#dts

## Checking Date labeled incorrectly as "chr"

#str(dts)

## Converting date from "chr" to date

#dts$Record.Date <- as.Date(dts$Record.Date, format = "%m/%d/%y")
#str(dts)

## Alternative Time Series Series Plot using autolplot

#dtst <- ts(dts$Closing.Balance.Today, start=c(2020,1), freq=365)
#dtst
#autoplot(dtst)

## Creating GGPlot 

line <- ggplot(dts, aes(x = Date, y = `Closing Balance`)) +
  ggtitle("Treasury Daily Cash Balance") +
  ylab("Closing Balance, in millions") +
  xlab("Date") +
  geom_line(colour = "#007f7f", size = 0.8) +
  scale_y_continuous(labels=scales::dollar_format()) +
  labs(caption = "Committee for a Responsible Federal Budget using Treasury data. Dot-dash line represents beginning of extraordinary measures.") +
  geom_vline(xintercept = as.numeric(as.Date("2021-08-02")), linetype=4, color = "black") +
  geom_hline(yintercept = 0, size = 0.5, colour="#333333")
line

## Setting the ggplot as an interactive Plotly and posting to my Plotly account

api_create(line,
  filename = "Plot 49",
  width = NULL,
  height = NULL,
  tooltip = "all",
  dynamicTicks = FALSE,
  layerData = 1,
  originalData = TRUE,
  source = "A"
)

