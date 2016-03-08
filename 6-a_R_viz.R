
# R Visualizations
# Microsoft Data Insights Summit
# Joseph Rickert
# March 22, 2016

# There are three major plotting systems in R: (1) base graphics, (2) lattice graphics and (3) ggplot2
# Additionally, there is a significant amount of development work going on to allow R users to produce, Javascript plots.
# In this module we ill give an example of plotting histograms in all three systems and then go on
# to show more ggplot2 examples and finish with a Javascript based interactive plot

# R's Three Plotting Systems
# For this we will use Duncan's famous Prestige data set that shows income, education level and a prestige score
# for "professional" (prof), "blue collar" (bc), and "white collar" (wc) workers/

# Base Graphics Histograms
library(car)
data(Duncan)
dim(Duncan)
head(Duncan)

# Select data using basic subsetting
inc_prof <- Duncan[Duncan$type=="prof","income"]
inc_bc <- Duncan[Duncan$type=="bc","income"]
inc_wc <- Duncan[Duncan$type=="wc","income"]

par(mfrow=c(1,3))  # set option to put 3 plots in one pane
hist(inc_bc, prob = TRUE, col = "pink", main = ("Income BC"), xlab=("Dollars"))
             lines(density(inc_bc))
hist(inc_prof, prob = TRUE, col = "yellow", main = ("Income Prof"), xlab=("Dollars")) 
             lines(density(inc_prof))
hist(inc_wc, prob = TRUE, col = "light blue", main = ("Income WC"), xlab=("Dollars")) 
lines(density(inc_wc))
par(mfrow=c(1,1))

#Lattice (trellis) Graphics
# Lattice graphics are the second major plotting system in R. Plots built with lattice have a very distinctive look, but the real value is the ease of making trellis plots - graphs that display a variable conditioned on an other variable. Some useful websites are: http://www.statmethods.net/advgraphs/trellis.html http://user2007.org/program/presentations/sarkar.pdf

library(lattice)
histogram( ~ income | type, 
           data = Duncan,
           nint=10,
           xlab = "Income",  
           main= "Hitogram by profession",
           type = "density",
           panel = function(x, ...) {
             panel.histogram(x, ...)
             panel.mathdensity(dmath = dnorm, col = "black",
                               args = list(mean=mean(x),sd=sd(x)))
           } )


# ggplot2 Graphics
# ggplot is the third major plotting system for R. It is based on Leland Wilkinson’s grammar of graphics. Plots are built in layers.
# 
# Some useful websites are: 
# http://www.cs.uic.edu/~wilkinson/TheGrammarOfGraphics/GOG.html 
# http://ggplot2.org/ http://docs.ggplot2.org/current/ 
# http://www.cookbook-r.com/Graphs/
# http://www.rstudio.com/wp-content/uploads/2015/12/ggplot2-cheatsheet-2.0.pdf
library(ggplot2)
p1 <- ggplot(Duncan,aes(income,..density.., fill=type))
p1 + geom_histogram(bins=10) + 
     facet_grid(. ~ type) +
     geom_density() +
     xlab("Income: Canadian $") +
     ggtitle("Histogram by Profession")



# More ggplot 2 visualizations
library(dplyr)
data(diamonds)
head(diamonds)
dim(diamonds)
set.seed(123)
dsmall <- sample_n(diamonds,5000)

# Scatter plots
# http://docs.ggplot2.org/current/geom_path.html
# plot price by caret and color with cut
p1 <- ggplot(dsmall,aes(carat,price,color=cut))
p1 + geom_point()

# Break out by clarity
p1 + geom_point() + facet_grid(. ~ clarity)

# Histograms
# http://docs.ggplot2.org/current/geom_histogram.html
p2 <- ggplot(dsmall, aes(x = price))
p2 + geom_histogram(bins=200)

p2 <- ggplot(dsmall, aes(x = price, ..density..))
p2 + geom_histogram(bins=200) + geom_density()

# Boxplots
# http://docs.ggplot2.org/0.9.3.1/geom_boxplot.html
p3 <- ggplot(dsmall, aes(cut,carat,fill=cut))
p3 + geom_boxplot()


# Scatter plot with statistical smoothing
#http://docs.ggplot2.org/current/geom_smooth.html
p4 <- ggplot(data = dsmall, aes(carat, price)) 
p4 +  geom_point(aes(colour=cut)) + 
      geom_smooth(method="loess") + 
      ggtitle("Sample of Diamonds Data with Smoother") 

# Plotting the Nile
# library(ggplot2)            # for plotting functions
# library(car)                # for the recode function, rc
library(reshape2)           # for melt function to build long form data frame
library(pracma)             # for Nile river data
data(nile)
head(nile)
# Many data frames arenaturally in “wide” form. To plot this data with ggplot2 te data must be transformed into “long” form.
nile_dat <- melt(nile,idvar="Year",measure.vars=month.abb,variable.name="Month",value.name="Obs")
nile_dat_long <- nile_dat[with(nile_dat,order(Year,Month)),]         # sort
head(nile_dat_long)

# Make a date variable
nile_dat_long$Date <- paste(with(nile_dat_long,Date<- paste(Month,"-","15","-",as.character(Year),sep="")))
nile_dat_long$Date <- as.Date(nile_dat_long$Date,format="%b-%d-%Y")

head(nile_dat_long)

# Plot the time series
p <- ggplot(nile_dat_long[100:300,],aes(x=Date,y=Obs))
p + geom_line() + geom_point(shape=1,col="red") + 
  ylab("Flow in cubic meters / second") + 
  ggtitle("Monthly Flow of Nile River at Dongola Station")


# Boxplots of monthly flows
b <- ggplot(nile_dat_long,aes(factor(Month),Obs))
b + geom_boxplot() +
  xlab("Month") +
  ylab("Flow in cubic meters / second") + 
  ggtitle("Variation of Flow at Dongola Station by Month")

# Create an interactive graph with a Javascript library
library(xts)
library(dygraphs)
# Make into a time series object
nile_ts <- xts(nile_dat_long$Obs,
               order.by=nile_dat_long$Date,
               frequency=12,start=c(1871,1))

# Plot wit htmlwidget dygraph
dygraph(nile_ts,ylab="cubic m / s", 
        main="Nile Monthly Flow Data") %>%
  dySeries("V1",label="Flow") %>%
  dyRangeSelector(dateWindow = c("1871-01-01","1984-12-01"))



