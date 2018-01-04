#Introduction to R for Orientation

# In this script we will learn the basics of working with R in RStudio. 
# 
#-------------------------------
## Setting a Working Directory
#-------------------------------

# Your working directory is a location on your computer where R will look 
# for your data files. You will need to tell R what your working directory 
# is everytime you open RStudio, otherwise R will just guess. 

# Let's see what R has currently set as your working directory
getwd()
# Check out the pathway that prints out in your console
# This pathway is UNIQUE to your computer. Notice that R uses forward slash

# It is a best practice to create a folder for your R data and tell
# R to use that folder every time you open R using setwd()

#Here's the pathway that I would like to use to set my working directory
setwd("C:/Users/Samantha/Desktop/R Files")

# I have chosen to use a file on my desktop called "R Files" to keep my data

#-------------------------------
# Your turn!
# Can you edit my setwd() code to set your own working directory?
# Try it!
setwd("C:/Users/Samantha/Desktop/R Files")
#-------------------------------



#------------------------
## Types of data in R
#------------------------

# The most common type of data you will work with is something called 
# a dataframe. This is very similar to an Excel spreadsheet in appearance.

# There are two ways to create a dataframe in R, you can either
# write one yourself or read in a pre-made data file. Most of the time
# we will read in an external file. This tutorial will show you how to do
# both. 

# A. Creating a dataframe 
# Let's make one so you can see.

# beatles is the name of the dataframe
beatles <- data.frame(
  name = c("John", "Paul", "George", "Ringo"),
  birth = c(1940, 1942, 1943, 1940), 
  instrument = c("guitar", "bass", "guitar", "drums")
)

# You can see what is in your dataframe with View()
View(beatles)

# Notice that we created 3 columns: name, birth, and instrument,
# then populated those columns with information inside the function
# c()

# We can print our dataframe to our console
beatles


#------------------------
# Your turn! 
# Make your own dataframe that contains information on the band
# Aerosmith from the following data on instrument, birth year,
# and marital status for each member:

#Steven Tyler: lead vocals, born 1948, single
#Joe Perry: guitar, born 1950, married
#Tom Hamilton:  bass, 1951, married
#Joey Kramer: drums, 1950, married
#Brad Whitford: guitar, born 1952, married
#------------------------


aerosmith <- data.frame(
  name = c("Steven Tyler", "Joe Perry", "Tom Hamilton", "Joey Kramer", "Brad Whitford"),
  birth = c(1948, 1950, 1951, 1950, 1952), 
  instrument = c("vocals", "guitar", "bass", "drums", "guitar"),
  status = c("single", "married", "married", "married", "married")
)
View(aerosmith)


# the format for the command to save a data frame in a file is:
# save(xxx, file = "yyy.RData")
# xxx = the object name
# yyy = the file name
save(beatles, file = "beatles.RData")

# Once you have saved a dataframe, you can load it in this way:
load("beatles.RData")


#----------------------------------
# Managing Data Frames
#----------------------------------

# Now that you have a data frame, you can select different elements of the 
# data frame to examine and change. Each element of the data frame has an 
# "address". **The "address" structure is one of most important concepts to 
# master as a new user of R. You may find it confusing at first.**
#   
#   Table: "Address" of each element in a data frame
# 
#   |      | [,1]  | [,2]  | [,3]  |
#   |------|-------|-------|-------|
#   | [1,] | [1,1] | [1,2] | [1,3] |
#   | [2,] | [2,1] | [2,2] | [2,3] |
#   | [3,] | [3,1] | [3,2] | [3,3] |
#   
# Using these "addresses" to select the elements that you are interested. 
# The technical term for the address is the "index."

# you can select a column of a data frame
# for example, select names of the Beatles
beatles$name
# you can do the same task differently
beatles[,1] 
# note how the variable "name", the first column of the data frame, 
# beatles, is selected without using the variable name

# you can also select a particular member of the Beatles
beatles[1,]
beatles[beatles$name=="John",]

#-----------------------------
# Your turn: 
# (1) Print the names of Aerosmith's members
# (2) Print information about a member of Aerosmith
#-----------------------------

#names of members
aerosmith$name

#Info on Steven Tyler
aerosmith[1,]


## Reading in a data file 
# The function for reading in a data file will differ depending on 
# they type of file you are reading. In this example, we will use
# a csv

# Here we are reading in the csv file, Philly_schools.csv
library(foreign)
schools <- read.csv("Philly_schools.csv", stringsAsFactors = FALSE)

# we print top 3 observations to take a look
head(schools, n=3)

View(schools)

# This dataset contains information on public schools in Philadelphia.
# Each row represents 1 school.

# Note that we use a function `read.csv` from a package called `foreign`. 
# We also turn on an option `stringsAsFactors = FALSE`. This code tells R
# not to convert character variables into factors. Just make a mental note 
# of this for now. We talk more about this below.  



#---------------------------
# Working with Variables
#---------------------------

# Conceptually there are two types of variables: categorical and
# continuous. (We are over simplifying for this handout.) 
# Categorical variables are associated with, you guess it, 
# categories like gender, race, college major, academic degrees, 
# ranks. Continous variables are associated with measures with 
# many (or infinite) values like age, income, wage, or body weight.  

# There are three main classifications for variables in R:
#character, numeric, and factor.

# Character variables
# Character variables are just text. In the schools dataframe, the
# SCHOOL_NAME_1 variable is a character- it is just the name of the school.

# We can check to see if a variable is a character
class(schools$SCHOOL_NAME_1)

# Here we are asking R to give us the class type of the column
# for school name inside the dataframe, schools.
# This dataframe$columnname syntax
# will become quite familiar to you in time!

# Alternatively,The attach() function allows us to simplify 
# our code by removing the need to refer to the name of the
# dataframe

attach(schools)
class(schools$SCHOOL_NAME_1)

# Notice that the function is working without the 
# dataframe$column name syntax.

# Factor Variables
# Factors are a special type of variable. They will appear in a dataframe
# as either character or numeric, but they have some additional information
# associated with them that is hidden to us, but that R uses. Factor
# levels control how variables are graphed, displayed in tables, 
# and matter for interpreting regressions. We'll discuss factors
# in greater detail later on. 

# The school level variable is currently a character 
class(schools$SCHOOL_LEVEL_NAME)

# change this variable to a factor variable
schools$SCHOOL_LEVEL_NAME <- as.factor(schools$SCHOOL_LEVEL_NAME)

# check that this variable is now a factor
class(schools$SCHOOL_LEVEL_NAME)

# See the factor levels
levels(schools$SCHOOL_LEVEL_NAME)
# We'll see how R uses these levels later on in this script.


# Numeric Variables
# Numeric variables are just numbers. 
# The variables Average_salary is the average salary of teachers in 
# each school. 
class(schools$Average_salary)


#----------------------------
# Basic Data Manipulation
#----------------------------

# To get us familiar with working in R, we will learn some 
# basic functions commonly applied to numeric and character variables


# Working with character data

# Print an alphabetized list with `sort()`
listofschools <- sort(schools$SCHOOL_NAME_1)
# the list is too long
# we will only print the names of the first 10 schools
head(listofschools, n=10)

# The table function provides us a count of character variables
table(schools$SCHOOL_LEVEL_NAME)


# Working with numeric data

# With numeric data, you can compute simple summary 
#(or descriptive) statistics using `mean()` and `summary`.

# mean value of number of suspensions in Philly public schools
mean(schools$Total_suspensions)
# alternative way to get similar summary statistics
summary(schools$Total_suspensions)


### Creating new variables using arithmetic operators
# creating a new variable, NewEnrollmentProp, using two existing variables: New_student and Enrollment
schools$NewEnrollmentProp <- (schools$New_student / schools$Enrollment)*100
summary(schools$NewEnrollmentProp)


### Aggregating numeric variables by categories of character variable
class(schools$Total_suspensions)
class(schools$SCHOOL_LEVEL_NAME)
#compute average number of total suspension by school level
aggregate(schools$Total_suspensions, by=list(schools$SCHOOL_LEVEL_NAME), FUN=mean)



#------------------------
# Your turn: 
#(1) Look in the dataframe schools, and find two examples of categorical and continuous variables.
#(2) Find the average teacher salary in Philadelphia 
#(3) Find the average teacher salary in Philadelphia by school level
#------------------------

# (1)
# Categorical: school code, school level, school term grade
# Continuous: Attendance, Enrollment

# (2)
mean(schools$Average_salary)

# (3)
aggregate(schools$Average_salary, by=list(schools$SCHOOL_LEVEL_NAME), FUN=mean)





#-------------------------------------------
# Graphing Different Types of Variables
#-------------------------------------------

# R is wellknown for its capability to produce effective 
# vitualization of the data. We will show you how to use
# core graphical commands in R. In the Spring, we will show 
# you how to use *ggplot* and other packages that are more powerful. 


# Continuous and Categorical variables naturally lend themselves to 
# different types of graphs. 


# Histrogram: Base R offers a frequency chart of numeric variables
hist(schools$Low_income_family)

# A Density plot displays similar information
plot(density(schools$Low_income_family))

# Boxplots a useful for understanding the spread of the data
boxplot(schools$Total_suspensions ~ schools$SCHOOL_LEVEL_NAME)
# Notice anything funny about this graph? What is causing it?


# To change the levels:
schools$SCHOOL_LEVEL_NAME<-factor(schools$SCHOOL_LEVEL_NAME, levels = c("ELEMENTARY SCHOOL", "MIDDLE SCHOOL", "HIGH SCHOOL", "CAREER AND TECHNICAL HIGH SCHL"))
levels(schools$SCHOOL_LEVEL_NAME)

# Now everything looks right!
boxplot(schools$Total_suspensions ~ schools$SCHOOL_LEVEL_NAME)


# Scatter plot
plot(schools$Low_income_family, schools$Gifted_education)

plot(schools$Attendance, schools$Gifted_education, col = schools$SCHOOL_LEVEL_NAME, pch=16)
legend(x=80, y=60, legend=levels(schools$SCHOOL_LEVEL_NAME), col=c(1:4), pch=16)

#------------------------
# Your turn: Find something interesting to you in the data and plot it!
#------------------------

plot(schools$Teacher_attendance, schools$Attendance)

boxplot(schools$Teacher_attendance)
boxplot(schools$Attendance ~schools$SCHOOL_LEVEL_NAME)




#------------------------
# Your turn: Now you will analyze a new dataset using your new skills!
# 1. Read in the csv file, "acs_orientation.csv". This file contains information on the gender, years of education, race, and income of 500 residents of Philadelphia. 
# 2. Find the number of males and females in this dataset
# 3. Find the average salary of this dataset
# 4. Find the average salary of this dataset by gender
# 5. Find the average salary of this dataset by race
# 6. Plot the relationship between years of education and income
#------------------------

#------------------------

# 1. Read in the csv file, "acs_orientation.csv"

acs<-read.csv("acs_orientation.csv", stringsAsFactors = FALSE)

# This file contains information on the gender, years of education,
# race, and income of 500 residents of Philadelphia. 

# 2. Find the number of males and females in this dataset
table(acs$Sex)

# 3. Find the average salary of this dataset
mean(acs$Income)
summary(acs$Income)

# 4. Find the average salary of this dataset by gender
aggregate(acs$Income, by=list(acs$Sex), FUN=mean)

# 5. Find the average salary of this dataset by race
aggregate(acs$Income, by=list(acs$Race), FUN=mean)


# Plot the relationship between years of education and income
plot(acs$Education, acs$Income, pch=16)


