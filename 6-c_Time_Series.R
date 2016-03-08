
# Time Series Analysis
# Microsoft Data Insights Summit
# Joseph Rickert
# March 22, 2016

library(dplyr)
library(xts)
library(forecast)
library(ggplot2)
library(reshape2)

# Read the IBM data from the .csv file
dir <- "C:/DATA/IBM"
fileName <- "IBM.stock.csv"
file <- file.path(dir,fileName)

IBM <- read.csv(file)
head(IBM,2)
tail(IBM,2)

# Filter out data before 2001
IBM2 <- filter(IBM, as.Date(Date) > as.Date('2000-01-01'))
# Select only Date and Closing Price
IBM2 <- select(IBM2,Date,Close)
head(IBM2,2)
sapply(IBM2,class)
# Make Date into a Date object
IBM2 <- mutate(IBM2, Date = as.Date(Date))
# Sort in ascending order
IBM2 <- arrange(IBM2,Date)
head(IBM2,2)

# Build a time series object
IBM_ts <- xts(IBM2$Close,order.by=IBM2$Date)
head(IBM_ts)
plot(IBM_ts)

# Narrow down the time series for analysis
IBM_ts2 <- IBM_ts['2012-01/2013']
plot(IBM_ts2)

# Automatically fit an ARIMA Model
fit <- auto.arima(IBM_ts2)
summary(fit)

# Generate and automatic forecast
fore <- forecast(fit)
plot(fore)
fore

# Build a common data frame for forecast
Jan2014<- IBM_ts['2014-01']
Jan_data <- as.data.frame(Jan2014)
row.names(Jan_data)
res <- data.frame(row.names(Jan_data)[1:10],Jan2014[1:10,1],
                  fore$mean,fore$lower[,1],
                  fore$upper[,1],
                  row.names = NULL)
names(res) <- c("Date", "Actual","Point","Lower","Upper")
res


meltdf <- melt(res,id="Date")
p <- ggplot(meltdf,aes(x=Date,y=value,colour=variable,group=variable)) 
p +  geom_line() + geom_point() +
  ylab("Closing Prices") +
  ggtitle("Forecast for IBM Stock")

