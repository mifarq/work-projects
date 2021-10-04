setwd("/Users/mfarquharson/Code/CMU")

library(forecast)
library(ggplot2)
library(plotly)
library(RCurl)
library(readxl)
library(tidyverse)
library(ggthemr)

ggthemr("pale")

# Load URL using API. 

url_api <- "https://api.fiscaldata.treasury.gov/services/api/fiscal_service/v1/accounting/dts/dts_table_1?format=csv&fields=record_date,account_type,close_today_bal,record_calendar_year&filter=record_calendar_year:in:(2020,2021)&page[number]=1&page[size]=6000"
dts <- read_csv(getURL(url_api))

# Filter for just Federal Reserve Account (renamed TGA starting in FY 2022) in Account Type
target <- c("Federal Reserve Account", "Treasury General Account (TGA)")
dts <- dts %>% filter(account_type %in% target)

## Setting Plotly API and UN

Sys.setenv("plotly_username"="your_username")
Sys.setenv("plotly_api_key"="your_api_key")

## Changing Column Names

colnames(dts)
names(dts)[names(dts) == "record_date"] <- "Date"
names(dts)[names(dts) == "close_today_bal"] <- "Closing Balance"

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

## Setting the ggplot as an interactive Plotly and posting to Plotly account

api_create(line,
  filename = "existing_filename_if_you_have_one_to_update",
  width = NULL,
  height = NULL,
  tooltip = "all",
  dynamicTicks = FALSE,
  layerData = 1,
  originalData = TRUE,
  source = "A"
)

