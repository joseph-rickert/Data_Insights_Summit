# First Look at R
# Microsoft Data Insights Summit
# Joseph Rickert
# March 22, 2016
# R is an interpretive language. At its most basic, the console can bu used as a simple calculator.
# Notice that typing "#" is the way to introduce a comment
#
# ";" lets you put simple statements on the same line
2 + 2; log(10); sqrt(99); sin(pi)   # ";" lets you put simple statements on the same line
# R was built for statistical analysis. 
# Here we draw 1000 numbers from a Normal (Gaussian)
# distribution with mean 0 and variance 1 and assign them to the vector x all in one
# line of code
x <- rnorm(1000)
# Notice that nothing happened. R normally does not give you any output
# until you ask for it.
head(x, 10)   # Look at the first 10 numbers in the vector x
tail(x,5)     # Look at the last 5 numbers in the vector xlength(x)     
length(x)     # To check on the length of x
summary(x)    # Get a summary of x
plot(x)       # Produce a scatter plot of x the index (the numbers 1 to 1000)
hist(x)       # Look at the histogram
# Produce a fancier histogram with some color, a superimposed 
# standard normal distribution curve and  a "rug" underneath showing
# where the points are.
hist(x, freq = FALSE, col = "pink")         
curve(dnorm,                                    # plot normal density
      col = "dark blue",                        # set coor of curve
      lwd=2,                                    # fill in the area under the curve
      add = TRUE)                               # add curve to existing plot
rug(x,col="red") 
# R is rich in built in functions.
# In addition to the mathematical functions sin(), log() etc rnorm(), head(), tail(), 
# length(), summary(), plot(), hist(), curve() are all R functions
# Type ?foo to get help with the function foo
?rnorm
## R is vectorized. 
# There is not so much of a need to write loops in R

y <- 1:10         # Assign the numbers 1 to 10 to a vector
y                 # Print the vector
2 + y; 2 * y      # Perform vector addition and multiplication


# There are lots of built in data sets in R
# Type "data()" to see what data sets are available. This depends on what 
# packages you have loaded
# type "data(ds_name)" to load the data set. Then type "ds_name" to look at it
data()
data(mtcars)
help(mtcars)      #  or type ?mtcars
head(mtcars)      #  to look at the first 6 rows
# mtcars is a data frame. This is the fundamental data structure for 
# doing statistical analysis
class(mtcars)     # To check on the class of an R object
class(x)

# R shines at exploratory data analysis
                    
# Use the with function to work with the variables in the data frame
with(mtcars,cor(drat,mpg))        # There is a positive correlation beteen
                                  # rear axel ratio and mpg!!
# Refer directly to the variables in the data frame mecars
plot(mtcars$drat,mtcars$mpg)      # Notice this is the same plot function we used above for 1 variable
cor(mtcars)    

# Look at all of the correlations
# Another way R is vectorized
# The sapply() function applies the scale() function to every column
# in the data frame simultaneously
df <-sapply(mtcars,scale)         # center and scale all of the variables
boxplot(df, col="yellow")

# Fit a simple regression model
reg1 <- lm(mtcars$mpg ~ mtcars$drat)
summary(reg1)        # Notice this is the same summary function we used above on the vector x
anova(reg1)          # Standard analysis of variance table
# Plot the data with the regression line added
plot(mtcars$drat,mtcars$mpg, main="Regression Model")
abline(reg1,col="red")
par(mfrow=c(2,2))    # Some code to put the 4 plots together
plot(reg1) 
str(reg1)            # Look at the model object
reg1$coefficients    # Pull out the coefficients


# Clean up

rm(mtcars)           # Remove mtcars
rm(list=ls())        # Remove everything: USE WITH GREAT CARE!!

