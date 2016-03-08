
# Data_Manipulation
# Microsoft Data Insights Summit
# Joseph Rickert
# March 22, 2016



## Tidy Data
# The biggest part of a data analysis project is preparing the data for analysis. This includes cleaning the data, deciding which variables to use, dealing with missing values and just wrestling the data into a form that is useful. Hadley Wickham, a statistician and prolific R package deeveloper, has addressed this process of wrangling data on conceptual level with his notion of "tidy data" and has put this concept into play with a series of packages that simplify the various processes of data manipulation. The examples in this module are based on using functions in Hadley's dplyr package. First a definition of Tidy Data from Hadley's JSS paper that you can fine here:http://vita.had.co.nz/papers/tidy-data.pdf
# 
# Tidy data is a standard way of mapping the meaning of a dataset to its structure. A dataset is
# messy or tidy depending on how rows, columns and tables are matched up with observations,
# variables and types. In tidy data: (1) each variable forms a column, (2) each observation forms a row, and (3) each type of observational unit forms a table.
# 
# Load the dplyr package

library(dplyr)
library(tidyr)
  

## Data for this Module
#In this module we will use two data sets: the IBM stock data from the module on reading data into R and another data set from Yahoo Finance on IBM dividend data.

#If you have not worked through the code in the previous module then you will need to fetch it from Yahoo by running the followin code:
  

# url <- "http://real-chart.finance.yahoo.com/table.csv?s=IBM&d=1&e=1&f=2016&g=d&a=0&b=2&c=1962&ignore=.csv"
# IBM.stock <- read.table(url,header=TRUE,sep=",")
# head(IBM.stock)

#Otherwise just read this data from your disk:

# Read the data from a .csv file
dir <- "C:/DATA/IBM"
fileName <- "IBM.stock.csv"
file <- file.path(dir,fileName)

IBM <- read.csv(file)
head(IBM,2)

#To get the dividend data execute the following code:   

# url2 <- "http://real-chart.finance.yahoo.com/table.csv?s=IBM&a=00&b=2&c=1962&d=01&e=6&f=2016&g=v&ignore=.csv"
# IBM_div <- read.table(url2,header=TRUE,sep=",")
  
#Since I already have the file on my system, I will just read it from disk 

fileName2 <- "IBM.div.csv"
path <- file.path(dir,fileName2)
IBM_div <- read.csv(path)

head(IBM_div)

## Augmenting a Data Frame
#Here we add a new variability to a data frame using the mutate function

IBM <- mutate(IBM, Volatility = (High - Low)/Open,
              Date = as.Date(Date))
head(IBM)

## Pruning a Data Frame
#Here we create a new data frame contianing IBM stock data that is later than 1/1/2000. We do this by filtering out the rows with older data.  

IBMge2000 <- filter(IBM, as.Date(Date) > as.Date('2000-01-01'))
head(IBMge2000)
tail(IBMge2000)

## Aggregating Data
#Here we aggragate the daily stock data in our original IBM data frame into monthly data. The first thing we will do is create tow new variables Month and Year from the Date variable using R's substr() function


IBM <- mutate(IBM, 
       Month = as.integer(substr(Date,6,7)), # Add variable Month
       Year  = as.integer(substr(Date,1,4))  # Add variable Year 
)

head(IBM,2)
sapply(IBM,class) # look at what type the variables are
   
#Here we form a special kind of data frame, by_yr_mo, to help group the data. 

by_yr_mo <- group_by(IBM,Year,Month)

IBM_A <- summarise(by_yr_mo,
          m.Open = mean(Open, na.rm = TRUE),
          m.High = mean(High, na.rm = TRUE),
          m.Low  = mean(Low, na.rm = TRUE),
          m.Close = mean(Close, na.rm = TRUE),
          m.Volume = mean(Volume, na.rm = TRUE),
          m.Adj.Close = mean(Adj.Close, na.rm = TRUE),
          m.Volatility = mean(Volatility, na.rm = TRUE))

head(IBM_A); tail(IBM_A); dim(IBM_A)
  
## Merging Data Frames
# In this section we merge the IBM stock file with the IBM dividend file and create a new data frame to hold the merged data. We do a "right join" which will keep all of the rows in the IBM_div data frame and only include rows from the IBM stock data frame with dates that match a dividend date. This new data frame includes the dividends and stock pricies on the days the dividends were paid.

# Make the IBM.div date into a proper date object
IBM_div <- mutate(IBM_div, Date = as.Date(Date)) # Make Date into a proper date data type
class(IBM_div$Date)
IBM2 <- right_join(IBM,IBM_div,by="Date")        # Merge the data 
IBM2 <- arrange(IBM2, desc(Date))                # Sort by date in desceding order
head(IBM2,10); tail(IBM2)

## Reshaping a Data Frame
#One often needs to reshape a data frame from either long format to wide format or the other way around. What long and wide mean is just illustrated by example, but basically wide format is what you might see in an Excel spreadsheet and long format is generally what statisticians want: one row for every combination of data.

#To illustrate these transformations we will use a subset of the IBM data frame.

ibm <- select(IBM_A, Year, Month, m.Close)
head(ibm)

#Note that ibm is in long format, so we will reshape it into wide format.

ibm_wide <- spread(ibm,Month,m.Close)
head(ibm_wide,3)

#Next, we provide names for the columns. Note that R has a built in vector that gives abbreviated names for the months. R has many such convenience variables.

names(ibm_wide)[2:13] <- month.abb    
head(ibm_wide,3)

# Now we wll go back to long format and compare the new long format data frame with what we started out with

ibm_long <- gather(ibm_wide,Month,Close,Jan:Dec)
ibm_long <- arrange(ibm_long,Year,Month)          # Sort the data frame
head(ibm_long,3)                                    # New long format data frame
head(ibm)                                           # What we started with

# For more information on these spread() and arrange() functions see the following tutorial:
# http://www.cookbook-r.com/Manipulating_data/Converting_data_between_wide_and_long_format/
