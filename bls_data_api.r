library(blsAPI)
library(blscrapeR)
library(tidyverse)
library(reshape2)
library(viridis)
library(hrbrthemes)

#Setting BLS API
Sys.getenv("your_api_key")

#BLS codes
# Leisure and hospitality CES7000000001
# Professional and business services CES6000000001
# Retail trade CES4200000001
# Transportation and warehousing CES4300000001
# Information CES5000000001
# Manufacturing CES3000000001
# Construction CES2000000001
# Wholesale trade CES4142000001
# Mining and logging CES1000000001
# Financial activities CES5500000001
# Utilities CES4422000001
# Education and health services CES6500000001
# Other services CES8000000001
# Government CES9000000001

target <- c("CES7000000001", "CES6000000001", 
            "CES4200000001", "CES4300000001",
            "CES5000000001", "CES3000000001",
            "CES2000000001", "CES4142000001",
            "CES1000000001", "CES5500000001",
            "CES4422000001", "CES6500000001",
            "CES8000000001", "CES9000000001")

df <- bls_api(target, startyear = 2020) %>% spread(seriesID, value) %>% dateCast()

# Removing unwanted columns
df <- subset(df, select = -c(latest,footnotes, year, period, periodName))

#Renaming Employment Categories
df <- df %>%
  rename("Leisure and hospitality" = CES7000000001,
         "Professional and business services" = CES6000000001,
         "Retail trade" = CES4200000001,
         "Transportation and warehousing" = CES4300000001,
          "Information" = CES5000000001,
          "Manufacturing" = CES3000000001,
          "Construction" = CES2000000001,
          "Wholesale trade" = CES4142000001,
          "Mining and logging" = CES1000000001,
          "Financial activities" = CES5500000001,
          "Utilities" = CES4422000001,
          "Education and health services" = CES6500000001,
          "Other services" = CES8000000001,
          "Government" = CES9000000001)

# Re-shaping data to turn into stacked area chart
df1 <- melt(df,id.vars=c("date"))

# Re-ordering by size
lvl <- df1 %>%
  filter(date=="2020-01-01") %>%
  arrange(value)
df1$variable <- factor(df1$variable, levels=lvl$variable )

# Plotting Stacked Chart
ggplot(df1, aes(x = date, y=value, fill=variable)) + 
  geom_area(alpha=0.6 , size=.5, colour="white") +
  scale_fill_viridis(discrete = T) +
  theme_ipsum() + 
  xlab("Time") +
  theme(legend.title=element_blank()) +
  scale_y_continuous(labels = scales::comma) +
  ylab("Employees, in thousands (Seasonally Adjusted)") +
  ggtitle("Employees on nonfarm payrolls by industry sector")
