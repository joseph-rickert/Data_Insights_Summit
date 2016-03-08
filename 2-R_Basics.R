# R Basics
# Microsoft Data Insights Summit
# Joseph Rickert 
# March 22, 2016
# ---
#   ## Basic Data Structures
#   R has 5 basic data structures:     
#   (1) atomic vectors, (2) matrices, (3) arrays, (4) lists and (5) data fra es
# 
# Note that there are no scalars in R.
# 
# ### Atomic Vectors
# Atomic vectors have 3 basic properties:
#   (1) type, (2)length, (3) attributes
# 
# The four common types of atomic vectors are:   
#   (1) integer, (2) double, (3) character and (4) logical


v <- 10 
v; typeof(v); length(v)
u <- c(12,55,43,9)
u; typeof(u); length(u)


#### Integer vectors   

u1 <- c(12L,55L,43L,9L)    # specify integer type
typeof(u1)
u  <- as.integer(u)        # coerce u to be an integer vector
typeof(u)   

#### Character vectors

c1 <- c("abc","def","any old string")       # form a character vector
typeof(c1)
length(c1)

c2 <- c("2","3"); c2
u2 <- as.integer(c2)        # coerce c2 to be an integer
u2; typeof(u2)
 

#### Logical vectors    

u3 <- c(TRUE,T,FALSE,F)     # form a logical vector
typeof(u3)

u4 <- runif(10) > .5		    # create a logical vector  
u4; typeof(u4)  


#### Vector Operations  

v1 <- seq(1,50, by=5)          # 
v1; v1[5]                    # Index into a vector
#
v2 <- 1:10               # another way to generate a sequence
v2[3:4]
#
s <- v1 + v2             # add vectors element by element
s
#
p <- v1 * v2             # multiply element by element
p
#
s[v2 > 5]                # index into one vector using a function on another vector


### Matrices   

m1 <- matrix(1:100,nrow=10,ncol=10,byrow=TRUE)  
m1  
typeof(m1); class(m1); length(m1); dim(m1)  
m1[5,5]  					# index into the matrix	  	
#

### Some Elementary Matrix Functions

m1^2						# square elements
#

m2 <- matrix(1:100,nrow=10,ncol=10)
m2
#
m1 + m2						# add 2 matrices elementwise
#
m1 * m2						# multiply 2 matrices elementwise
#
m1 %*% m2					# matrix multiplication
#
c3 <- subset(letters,letters!="z")
c3
m3 <- matrix(c3,nrow=5)		# matrix of characters
m3; typeof(m3); class(m3)


### Arrays   
# Multidimensional arrays are basic data types   

A <- array(runif(24),c(3,4,2))
A
B <- array(A,c(2,3,4))   # reshape A
B
  
### Lists

lst <- list(v,v1,v2,c1,list(m1,m2),c3,m3, A,B)
lst
typeof(lst)
class(lst)
length(lst)
lst[[5]][2]  				# Index into a list


## Data Frames
# Data frames are the most common data structure in R. They mirror the ways that statisticians think about data: each row an observation and each column a variable.
# Here we build a data frame "by hand".
#  

# The data is based on the cystfbr data set in the ISwR package.
age <-c(7,7,8,8,8,9,NA,12,12,13,13,14,14,15,16)
sex <- c("f","m","f","m","f","f","m","m","f","m","f","m","f","m","m")
pemax <- c(95,85,100,85,95,80,65,110,70,95,110,90,100,80,134)
height <- c(109,112,124,NA,NA,130,139,150,146,155,156,153,160,158,160)
weight <- c(13.1,12.9,14.1,16.2,21.5,17.5,30.7,28.4,NA,31.5,39.9,42.1,45.6,51.2,35.9)
bmp <- c(68,65,64,67,93,68,89,69,67,68,89,90,93,93,66)
#
dF <- data.frame(pemax,sex,height,weight,bmp)
head(dF) 
dim(dF)
sapply(dF,class)
sapply(dF,summary)

 
# Notice that sex is now of type "integer"!!! The data.frame() function 
# automatically turned it into an object of class "factor". 
# This is most likely what a statistician would want done. Factors are 
# "categorical variables".

#Data scientists and software developers, however, usually don't 
# like R messing with their strings. In this case, sex got made into 
# a factor because the default for the parameter stringsAsFactors in the
# data.frame() function is TRUE.

args(data.frame)

# As the documentation data.frame()says:
# stringsAsFactors	
# logical: should character vectors be converted to factors? 
# The ‘factory-fresh’ default is TRUE, but this can be changed by setting 
# options(stringsAsFactors = FALSE).

## Functions
# "A function is a group of instructions that takes inputs, uses them 
# to compute other values, and returns the result" - Norm Matloff The Art of R Programming

### Writing Functions  
# Let's write our own mean function  

jmean <- function(x){
  m <- sum(x)/length(x)		# where is m?
  return(m)
}
jmean(pemax)
# R will through an error because m is not in the global environment
# m 

#Try again and improve the formatting

jmean2 <- function(x){
  m <- round(sum(x)/length(x),2)
  return(m)
}

jmean2(pemax)

# Why not give the user more control of the rounding process?   
# The magic 3 dots ... enable arguments to be passed to sub functions  


jmean3 <- function(x,...){
  m <- round(sum(x)/length(x),...)
  return(m)
}
?round						# look to see what parameters round is expecting

jmean3(pemax,3)
jmean3(pemax)				# the default value for round is 0
jmean3(pemax,1)


### Some Important,  Helpful Functions
#Missing Values
# NA is the way to designate a missing value as we saw above.

z <- c(1:3,NA)				
z

# But, the following logical expression is incomplete, and therefore 
# undecideable, so everything is NA

z == NA 

# Here is the proper way to search for NAs 

zm <- is.na(z)				
zm

#NaN is not a number

z1 <- c(z,0/0)				# NaN: not a number
z1
is.na(z1)					    # Finds NAs and NaNs
#
is.nan(z1)            # Only finds NaNs

### Getting rid of NAs
# na.omit removes the entire row containing an NA from a data frame
dF
na.omit(dF)					
# Notice that rows 4 and 5 are now missing. Applying na.omit() to a data frame will remove the entire row
# if it finds an NA in any of the columns.

