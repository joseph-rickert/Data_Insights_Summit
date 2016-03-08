
# Regression Analysis
# Microsoft Data Insights Summit
# Joseph Rickert
# March 22, 2016


# Load the required libraries
library(ggplot2)
library(dplyr)
library(corrplot)

# Fetch data from the UCI MAchine Learning Repository
# https://archive.ics.uci.edu/ml/machine-learning-databases/auto-mpg/auto-mpg.names
# More infrmation on the data set
# http://cs.nyu.edu/courses/fall00/G22.3033-001/weka/weka-3-0-2/data/auto-mpg.arff
url <-"https://archive.ics.uci.edu/ml/machine-learning-databases/auto-mpg/auto-mpg.data"
mpg <- read.table(url,stringsAsFactors = FALSE,na.strings="?")

# For later use: write to disk and read in again
write.csv(mpg,"mpg_orig.csv",row.names=FALSE)
mpg <- read.csv("mpg_orig.csv")

# Look at the data and reset some of the data types
names(mpg) <- c("mpg","cyl","disp","hp","weight","accel","year","origin","name")
head(mpg)
dim(mpg)

# Count the numberof missing values in the data
length(which(is.na(mpg))==TRUE)
# Remove the missing values since there are only six of them
# In a serious work you might want to think about imputing 
# or setimating the missing values
mpg <- na.omit(mpg)

sapply(mpg,class)
summary(mpg)
mpg <- mutate(mpg, hp = as.numeric(hp),
              year = as.factor(year),
              origin = as.factor(origin))
sapply(mpg,class)

#-------------------------------

# Function to divide data into training, and test sets 
index <- function(data=data,pctTrain=0.7)
{
  # fcn to create indices to divide data into random 
  # training, validation and testing data sets
  N <- nrow(data)                                     
  train <- sample(N, pctTrain*N)                              
  test <- setdiff(seq_len(N),train) 
  Ind <- list(train=train,test=test)
  return(Ind)
} 

# Exploatory Data Analysis
# Look at summaries of the data
summary(mpg)
# Look at correlations among the numeric variables
mpg.num <- select(mpg,mpg,cyl,disp,hp,weight,accel)
cor(mpg.num)

corrplot(cor(mpg.num), method="ellipse")

# Look at the at pairwise relationships for continuous variables
pairs(mpg[,c(1,3:6)],                    # pairs is function that produces a maatrix of scatter plots
      panel=function(x,y){               # define a function panel for the content of the matrix 
        points(x,y, col="light blue")                       # plot the points
        abline(lm(y~x), lty=2,col="red") # add a linear regression 
      },
      diag.panel=function(x){            # define a new panel for the diagonals
        par(new=T)
        hist(x,main="",axes=F,nclass=12) # put a histogram on each diagonal
      }
)




# Look at distribution of mpg for discrete variables
# mpg by cyl
p1 <- ggplot(mpg, aes(factor(cyl),mpg))
p1 + geom_boxplot()

# mpg by origin
# origin: 1 = USA, 2 = Europe, 3 = Japan
p2 <- ggplot(mpg, aes(origin,mpg))
p2 + geom_boxplot()

# mpg by weight and origin
p3 <- ggplot(mpg, aes(weight,mpg,col=origin))
p3 + geom_point()

# mpg by year
p4 <- ggplot(mpg, aes(year,mpg))
p4 + geom_boxplot()


# scatter plot by origin
# palette(c("dark blue","red", "green"))    # Set custom colors
# plot(mpg[,c(1,3:6)], col=mpg$origin, pch=16)

# Lets fit a few regression models to the training data
ind <- index(mpg)
form.1 <- formula("mpg ~ cyl + disp + hp + weight + accel")
lm.fit.1  <- lm(formula=form.1,data=mpg[ind$train,])   # Build the model
summary(lm.fit.1)

form.2 <- formula("mpg ~ cyl + disp + hp + weight + accel + year -1" )
lm.fit.2  <- lm(formula=form.2,data=mpg[ind$train,])   # Build the model
summary(lm.fit.2)

form.3 <- formula("mpg ~ cyl + disp + hp + weight + accel + origin -1" )
lm.fit.3  <- lm(formula=form.3,data=mpg[ind$train,])   # Build the model
summary(lm.fit.3)


# Evaluate the best fit model
# Plot the regression diagnostics
par(mfrow=c(2,2))
c <- plot(lm.fit.2)
par(mfrow=c(1,1))

# Look at the outliers flagged in the diagnostic plots
outliers <- c(14,243,332,389)
mpg[outliers,]


# How good is the model on new data?
predictions <- predict(lm.fit.2,mpg[ind$test,],se.fit=TRUE,interval="prediction")
# Plot the fit
df <- data.frame(y = mpg[ind$test,]$mpg, predictions)
head(df,2)

#Plot predictions vs actuals 
# error bars = 1 standard deviation
p5 <- ggplot(df, aes(x = y, y = fit.fit))
p5 + geom_errorbar(aes(ymin = fit.lwr, ymax = fit.upr), width = .1) +
  geom_point() + 
  geom_abline(intercept = 0, slope = 1, linetype=2) +
  xlab("Reported MPG") +
  ylab("Predicted MPG") +
  ggtitle("95% CIs for Predictions")


