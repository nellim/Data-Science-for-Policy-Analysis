# Name: Script 1
# Author: Nelson Lim
# Purpose: Introduce Basic R Concepts

#-----------------------------------------------------
# Read Chapter 4 and Chapter 6 of R for Data Science
#-----------------------------------------------------

#----------------------------------------------------------------------------
# Turn on Code Diagnostics 
# https://support.rstudio.com/hc/en-us/articles/205753617-Code-Diagnostics
#----------------------------------------------------------------------------

#-------------
# Objectives
#-------------
# Learning objectives
# 1. Use R as a caculator
# 2. Create and subset vectors
# 3. Create and subset data frame
# 4. Install packages
# 5. Basics of ggplot2

#--------------------------
# Using R as a calculator
#--------------------------
# 1. Choose any number and add 2 to it.
# 2. Multiply the result by 3.
# 3. Subtract 6 from the answer.
# 4. Divide what you get by 3.

10
10+2
12 * 3
36 - 6
30 / 3

#--------------------
# create an object
#--------------------
a <- 1 #a scalar 
a

#-------------------------
# Managing vectors
#-------------------------
# Vectors are basic type of data in R


# Saving your first object in R
x <- c(0, 0, 0, 0, 1, 0 ,0) # x is a vector
?c # What is c? It is a function
# Make a copy
y <- x
y

# Each element of a vector is indexed
# We need to feel comfortable using the index to manage vectors

# Vectors

vec <- c(6, 1, 3, 6, 10, 5) # vec is a vector
vec
vec[0]
vec[c(5,6)]

## your turn
# select 1st element
vec[1]
# select 1st and 5th element
vec[c(1,5)]

vec[-c(5,6)] # this is very useful, when you have too many elements you want to keep

# why the following codes do not work?
vec(1:4)
vec[-1:4]

# name the elements
names(vec) <- c("a","b","c","d","e","f")
vec
vec[c("a","b","d")]
vec[c("a","c","f")]

# one type of data: logical vector
vec[c(FALSE,TRUE,FALSE,TRUE,TRUE,FALSE)]

# replace the selected values
vec
vec[5] <- 20 
vec
vec[c(FALSE,TRUE,FALSE,TRUE,TRUE,FALSE)] <- 100 # this makes R very efficient
vec

# you can analyze the vector
sort(vec) # sort the vector
max(vec) # maximum value of the vector
min(vec) # minimum value of the vector
sample(vec, 2) # random sample of 2 numbers from the vector 
?sample # note "replace = FALSE 

#--------------------
# Data types in R
#--------------------
# reference: https://www.tutorialspoint.com/r/r_data_types.htm 
# different types of data
# character vector (text)
t <- c("a", "b", "c")
t
class(t) # why not what t is?

# numeric vector
num <- c(1, 2, 3)
num
class(num)

# you can change the data type
num <- as.character(num) # now it is a character vector
class(num)
num <- as.numeric(num) # now it is back to being numeric vector

look <- c(1, "1", "a")
look # did you notice anything strange?


#--------------
# Data frame
#--------------
# df is a data frame
df <- data.frame(
  name = c("John", "Paul", "George", "Ringo"),
  birth = c(1940, 1942, 1943, 1940), 
  instrument = c("guitar", "bass", "guitar", "drums")
)
?data.frame

df
View(df) # new line 1
class(df)
class(df$name)
class(df$birth)
class(df$instrument)
# do you notice a new type of data?

# it is a strange feature of R
# when you create a data frame, it will convert character vectors
# into factor, a type of data, that can create problems 
# when you create graphs or analysis

# look at the manual page of data.frame again
?data.frame

df <- data.frame(
  name = c("John", "Paul", "George", "Ringo"),
  birth = c(1940, 1942, 1943, 1940), 
  instrument = c("guitar", "bass", "guitar", "drums"), 
  stringsAsFactors = FALSE
)
class(df$name) # do you notice the difference?


# Subsetting the data frame

df[2,3]
df[c(2,4),c(2,3)]
df[c(2,4),3]

1:4 
df[1:4, 1:2]
df[c(1,1,1,2,2), 1:3]

df[1:2, 0]

df[c(2:4), 2:3]
df[-c(2:4), 2:3]
df[-c(2:4),-(2:3)]

df[c(1,2)]

df[1, ]
df[ ,2]

df[ ,"birth"]
df[ ,c("name","birth")]

df[c(FALSE,TRUE,TRUE,FALSE), ]


# create new vector in the data frame
df$guitar <- df$instrument=="guitar"
df

# here is different way to create a similar vector
# this is technically called a dummy variable
df$guitar[df$instrument=="guitar"] <- 1 
df

# Exercise:
# Make a dummy variable that indicates Beatles named Paul
df$paul <- df$name=="Paul"
df$paul[df$instrument=="Paul"] <- 1 
df

# Looking at the dataframe
library("ggplot2") # make sure that it is loaded
?mpg

mpg[1:6, ]
nrow(mpg)

head(mpg)
tail(mpg)

View(mpg)


#-----------
# Packages
#-----------
# R is a computer langauge
# packages make it a software like Stata
# there are thousand of packages
# here is a good collection
# https://github.com/rstudio/RStartHere 


# install.packages(c("ggplot2", "hexbin", "maps", "mapproj","RColorBrewer", "scales"))
# install.packages(tidyverse)
library(tidyverse)
library("ggplot2")
library("hexbin")
library("maps")
library("mapproj")
library("RColorBrewer")
library("scales")


#----------
# Homework
#----------
# 1. complete the Complete this tutorial  http://tryr.codeschool.com/
# 2. Read Chapter 3.1 to 3.6 of "R for Data Science"
# 3. Install a package called "fivethirtyeight"
install.packages("fivethirtyeight")
# 4. Load the package "car"
library(fivethirtyeight)
# 5. Find a data set call "police_locals"
# 6. How many variables are in Duncan?
head(police_locals)


