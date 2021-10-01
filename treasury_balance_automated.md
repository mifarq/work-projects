Treasury Cash Balance
================
Mike Farquharson
10/1/2021

## Setting Theme

``` r
ggthemr("pale")
```

## Load URL using API

``` r
url_api <- "https://api.fiscaldata.treasury.gov/services/api/fiscal_service/v1/accounting/dts/dts_table_1?format=csv&fields=record_date,account_type,close_today_bal,record_calendar_year&filter=record_calendar_year:in:(2020,2021)&page[number]=1&page[size]=6000"
dts <- read_csv(getURL(url_api))
```

    ## Rows: 1323 Columns: 4

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (1): account_type
    ## dbl  (2): close_today_bal, record_calendar_year
    ## date (1): record_date

    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

## Filter for just Fed in Account Type

``` r
dts <- dts %>% filter(account_type == "Federal Reserve Account")
```

## Changing Column Names

``` r
colnames(dts)
```

    ## [1] "record_date"          "account_type"         "close_today_bal"     
    ## [4] "record_calendar_year"

``` r
names(dts)[names(dts) == "record_date"] <- "Date"
names(dts)[names(dts) == "close_today_bal"] <- "Closing Balance"
```

## Creating GGPlot

``` r
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
```

![](treasury_balance_automated_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->
