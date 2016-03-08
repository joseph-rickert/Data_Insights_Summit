
# Working_with_SQL
# Microsoft Data Insights Summit
# Joseph Rickert
# March 22, 2016

## R Connecting to a SQL Database
# The standared way to programmatically connect to a SQL database, 
# including Microsoft SQL Server, is through the ODBC (Open Database Connectivity) 
# which was originally developed by Microsoft in the early 1990's. 
# The R drivers for doing this are accesible through the RODBC package. 
# The vignette that describes how to use RODBC can be found here: 
# http://bit.ly/1orm9HK     

# If you don't already have access to SQL Server database the easiest way 
# to experiment with connecting to SQL from R is to set up a SQL database on Azure. 
# This is a completely painless procedure requiring only clicking on a few text 
# boxes and no SQL admin knowledge, but it does require setting up an Azure 
# account - a free trial account will do nicely. Information for getting started can 
# be found in this blog post: http://bit.ly/24cKLVm   

library(RODBC)
library(nycflights13)
library(dplyr)
 
# If you obtain your connection string from the Azure user interface it 
# should looks something like this:
# connectionString <- "Driver={SQL Server Native Client 11.0};
#       Server=tcp:xxxxxxxxx.database.windows.net,1433;Database=Test_R;
#       Uid=My_server_logon@hzgi1l8nwn;Pwd={My_Password};Encrypt=yes;
#       Connection Timeout=30;"

# Otherwise, build your connection string in the following manner from 
# information you that is particular to your data base.

# Build up the connection string from its parts
myServer <- "tcp:hzgi1l8nwn.database.windows.net"      
myUser <-  "joseph.rickert"
myPassword <- readLines("SQL_password.txt",n=1)
myDatabase <- "Test_R2"
myDriver <- "{SQL Server Native Client 11.0}" 

#Build the connection string  
connectionString <- paste0(
  "Driver=", myDriver,
  ";Server=", myServer,
  ";Database=", myDatabase,
  ";Uid=", myUser,
  ";Pwd=", myPassword)


# Open your RODBC connection
myconn <- odbcDriverConnect(connectionString)

## Populate the database
# Here we use the New York City 2013 Flight Data from the package nycflights12

dim(flights)
head(flights)

# Save the table to the database
# sqlSave(channel=myconn, dat=flights, tablename = "flightsTbl")

### Query the database

sqlQuery(myconn,"SELECT * FROM sysobjects WHERE xtype='U'" )
# Fetch movies with ratings GT 3 from Azure SQL DB
sqlQuery_m1 <- "SELECT * FROM flightsTbl WHERE month < 3"
m1 <- sqlQuery(myconn, sqlQuery_m1)
head(m1)
dim(m1)

odbcCloseAll()

