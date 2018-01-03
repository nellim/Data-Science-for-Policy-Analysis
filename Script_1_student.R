##------------------------------------------
## Script # 1
## Based on Chapter 2, 4, 6, 11, and 18 of r4ds
## Learning objectives:
##   1. Review basics of R
##   2. workflow of an analysis
##   3. Learn to how to "pipe"
##------------------------------------------

# You will learn to analyze data using R in this course. 
# Even if you don't like to use R for the rest of your career, 
# the data analysis principles that you will learn from this course can be 
# applied to other software like Excel. Similarly, the coding skills and
# habits that you will develop in this class are transferable to other languages 
# like Phython. 

# So this is a good time to develop good programming habits. These habits will 
# reduce errors in your codes and enhance your quality of life.
# Error messages in R are known to be harmful to our mental health.

###------------
### Discussion 
###------------

### Here is a style guide that makes your codes easier to understand 
### and debug: http://style.tidyverse.org/ 
### Let's review them.

# In fact, there are two packages that help you apply the style guide:
# 1. __styler__ allows you to interactively restyle selected text, files, 
#    or entire projects.
# 2. __lintr__ performs automated checks to confirm that your conform to 
# the style guide. 

##-------------------------
## Welcome to "tidyverse"
##-------------------------

# You may notice the terms: "tidy" and "tidyverse" in the styple guide. 
# In this class, you are learning a relatively new approach to coding in R.
# Hadley Wickham, the chief scientist at R-studio, "invented" tidyverse.
# You can learn more about him at http://hadley.nz/. 
# His book R for Data Science is our main textbook in this class. 
# And he developed many influential and popular packages in R that support
# this alternative universe called "tidyverse." 

# tidyverse approach to R is different than the traditional approach to R.
# In the beginning I will show you both "Base-R" and tidyverse. Later we will
# only use Base-R when it is more efficient for us. As you can tell, I am a 
# ruthlessly pragmatic in my work. 

# Ruthless pragmatism is defined as "accepting the current circumstances and 
# making practical decisions based on them, at any cost." 
# https://www.quora.com/What-does-the-phrase-ruthlessly-pragmatic-mean 

# The official website for tidyvese is: https://www.tidyverse.org/ 

##-------------------
## Review of basics
##-------------------

# Here are a few basics of R that you already know. 
# But we will review them to make sure that we are on the same page
# You can use R as a calculator

1 / 200 * 30
(59 + 73 + 2) / 3
sin(pi / 2)

# You also know that R is an "object oriented" language. 
# You can create new objects with `<-`
# Structure of the code: <object_name> <- <value>
# Read that code as : "<object name> gets <value>." 
# Keyboard shortcut in R studio for <- : `Alt + (minus sign)`  

x <- 3 * 4

# You can inspect an object by typing its name:
x

###------------
### Discussion 
###------------

### Here is a collection of cheatsheets:
### https://www.rstudio.com/resources/cheatsheets/ 

### Download the cheatsheet for Base-R
### Download the cheatsheet for rstudio-ide 

##------------------------------------------
## Everything starts with a name: 
## Use __snake_case__ for descriptive names
##------------------------------------------

# Object names must start with a letter, and 
# can only contain letters, numbers, `_` and `.`. 
# Use __snake_case__ where you separate lowercase words with `_`. 

i_use_snake_case
otherPeopleUseCamelCase
some.people.use.periods
And_aFew.People_RENOUNCEconvention

this_is_a_really_long_name <- 2.5

# To inspect this object, try out RStudio's completion facility: 
# type "this" in the Console, press TAB, add characters until you have a unique prefix, 
# then press return.

##--------------------
## Calling functions
##--------------------

# R has a large collection of built-in functions that you can use (or "call") 
# like this: function_name(arg1 = val1, arg2 = val2, ...)

seq(1, 10)
y <- seq(1, 10, length.out = 5)
y

# You can save time by surrounding the assignment with parentheses, 
# which will print out the object that you created:

(y <- seq(1, 10, length.out = 5))

##-----------
## Practice
##-----------

# 1. Press Alt + Shift + K. What happens? 

# 2. How can you get to the same place using the menus?

##--------------------
## Workflow: scripts
##--------------------

# The most important keyboard shortcuts: Cmd/Ctrl + Enter. 
# This executes the current R expression in the console. 

# Start your script with the packages that you need. 
# Here is the documentation for R packages:
# https://www.rdocumentation.org/ 

# Install packages: dplyr, nycfilights13, tidyverse
# Note that you need to combine the names into a vector with c()
install.packages(c("dplyr","nycflights13","tidyverse"))

library(dplyr) # package that you will use to manage your data
library(nycflights13) # a data set of flights coming and going from New York city
library(tidyverse) # official package that creates a alternative "universe" for R users 

##---------------------
## Workflow: projects
##---------------------

##---------------------------------------
## Create projects to organize your work
##---------------------------------------

# Instruct RStudio not to preserve your workspace between sessions:
# This will force you to capture all important interactions in your code. 

# There is a great pair of keyboard shortcuts that will work together to make sure 
# you've captured the important parts of your code in the editor:

# 1. Press Cmd/Ctrl + Shift + F10 to restart RStudio.
# 2. Press Cmd/Ctrl + Shift + S to rerun the current script.

##---------------------------------
## New way to organize your work
##---------------------------------

# You know the importance of the __working directory__. 
# This is where R looks for files.
# RStudio shows your current working directory at the top of the console:

# And you can print this out in R code by running `getwd()`:

getwd()

###-------------
### Discussion
###-------------

### Keeping your files organized may be the most important habit that you 
### need to develop if you are going work with data.
### Many "experienced" analysts failed to properly develop this habit.
### This failure has trapped them into a unhappy life.

##---------------------------------------------
## Make your work self-contained and portable
##---------------------------------------------

# Don't set your working directory using `setwd()`
# A blog describing the virtue of project-oriented workflow
# https://www.tidyverse.org/articles/2017/12/workflow-vs-script/

# The author of the blog wrote:
# "The chance of the setwd() command having the desired effect -
# - making the file paths work -- for anyone besides its author is 0%.
# It's also unlikely to work for the author one or two years or 
# computers from now."

# You should use the project, which is "self-contained" and portable.

##-------------------
## RStudio projects
##-------------------

###------------
### Discussion 
###------------

### R experts keep all the files associated with a project together

##-----------
## Practice
##-----------

# 1. Create a directory; call it "Week1" using a file manager of your 
#    operating system. 
# 2. Put Script_1 and employee_salaries.csv into the directory
#    into "Week1"

# 3. Click File > New Project in R-studio
# 4. Select the option: existing directory

# 5. Now you should have a project called: Week1 

# Whenever you want to work on the documents related to Week1, start your work
# by picking the project "Week1"
# R-studio will keep track of all your work
# You will not get errors because you can't find your data or objects.


##-------
## Pipes
##-------

###-------------
### Discussion
###-------------

### We will be using "pipes" as a part of tidyverse.

# Pipes are a tool for expressing a sequence of multiple operations. 

# The pipe, `%>%`, comes from the __magrittr__ package by Stefan Milton Bache. 

library(magrittr)

# Introduction to magrittr
# https://cran.r-project.org/web/packages/magrittr/vignettes/magrittr.html

# Examples of piping

# filtering observations from flights data
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
# summarizing the time delays by year, month, and day
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))


###-------------
### Discussion 
###-------------

### Now time to do some programming

##-------------------------------------------------------
## Import data from Excel worksheet saved as cvs format
##-------------------------------------------------------
# install a package __readr__
# You can use a package __pacman__ to install and manage your packages
pacman::p_load("readr")
# <package_name>::<function_name>("<package_name>")

# load the package
library(readr)
# https://cran.r-project.org/web/packages/readr/README.html

##---------
## Practice
##----------

# download the cheat sheet for Data Import at
# https://www.rstudio.com/resources/cheatsheets/

# import data
employee_salaries <- read_csv("employee_salaries.csv")
# I downloaded the data set "employee_salaries.csv" from Open Data Philly website.
# https://www.opendataphilly.org/dataset/employee-salaries-overtime 
# It contains the salaries of the City employees. You should examine this data set, 
# not just because we will use this data in this course. If you are interested in 
# working for the City of Philadelphia, you can learn the structure of the City work force
# including wages associated with particular jobs from this data. 
# __read_csv()__ can import spreadsheets saved as column seperated format

##----------
## Practice
##----------

# 1. How many city employees in the data?

# 2. How many employees the city of Philadelphia has in 2017? 

# 3. What is the highest salary of a city employee without overtime?

# 4. What is the highest salary of a city employee with overtime?

# 5. What is the job title of the highest paid city employee without overtime?

# 6. What is the job title of the highest paid city employee with overtime?

##----------
## Additional practice
##----------

# 1. Go to https://github.com/fivethirtyeight/data and explore the data sets.
# 2. Pick a data set that you want to explore.
# 3. Download the data set.
# 4. Import it into R.
# 5. Explore the data. 