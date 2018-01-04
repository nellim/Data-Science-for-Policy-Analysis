##----------------------------------------------------
## Script # 4
## Based on Chapter 5 of r4ds
## Learning objectives:
##   1. Learn to wrangle your data
##----------------------------------------------------

##---------------------
## Data transformation 
##---------------------

# You rarely will get data that are ready to be analyzed.
# You will have to wrangle it before you can analyze it

# We will use the dplyr package to manage our data

library(nycflights13)
# Flights that departed from New York City in 2013. 
# Source: US [Bureau of Transportation Statistics]
# (http://www.transtats.bts.gov/DatabaseInfo.asp?DB_ID=120&Link=0), 
?flights

# load tidyverse that includes dplyr
library(tidyverse)

###-------------
### Discussion
###-------------

# Let's take a look at the cheatsheet for dplyr
# https://www.rstudio.com/resources/cheatsheets/ 

# Always good to start by looking at the data and any documentation
str(flights)
View(flights)
?flights

# Row of three (or four) letter abbreviations under the column names. 
# `int` stands for integers.
# `dbl` stands for doubles, or real numbers.
# `chr` stands for character vectors, or strings.
# `dttm` stands for date-times (a date + a time).

# `lgl` stands for logical, vectors that contain only `TRUE` or `FALSE`.
# `fctr` stands for factors
# `date` stands for dates.

###-------------
### Discussion
###-------------

###---------------
### dplyr basics
###---------------

### Five key dplyr functions (verbs) 

### 1. filter(): Pick observations by their values 
### 2. arrange(): Reorder the rows 
### 3. select(): Pick variables by their names
### 4. mutate(): Create new variables with functions of existing variables 
### 5. summarise(): Collapse many values down to a single summary 

### We can use `group_by()` with these verbs 
### which changes the scope of each function from operating on 
### the entire dataset to operating on it group-by-group. 

### These six functions provide the verbs for data manipulation:

### All verbs work similarly: 

### 1. The first argument is a data frame.
### 2. The subsequent arguments describe what to do with the data frame,
###    using the variable names (without quotes).
### 3. The result is a new data frame.

##-----------------------------
## Filter rows with `filter()`
##-----------------------------

# it is simple: you use __filter__ to select/subset observations
filter(flights, month == 1, day == 1)

# you can save the data that you filtered/selected/subseted
jan1 <- filter(flights, month == 1, day == 1)

# by putting the codes inside the () automatically print out the information 
# about the data frame that you just created
(dec25 <- filter(flights, month == 12, day == 25))

##-----------------
## Comparisons ==
##-----------------

# When you use `=` instead of `==` when testing for equality, 
# you'll get an informative error:

filter(flights, month = 1)

# Another common problem when you use `==` with floating point numbers 
# It is a bit technical but common problem

sqrt(2) ^ 2 == 2
# You see that R is tell you that these two numbers not the same
# similarly,
1/49 * 49 == 1

# It is because computers (or R) use finite precision arithmetic 

near(sqrt(2) ^ 2,  2)
near(1 / 49 * 49, 1)

# When you use the function __near__, R will tell you that these numbers are "near"
# Let's learn more about this function
?near

# From now on, if you need to compare two numbers, use __near__. 
# It is safer than using __==__ to compare two numbers in R. 

##-------------------
## Logical operators
##-------------------

# You need to use logical operators to identify data that
# you need to wrangle/manage/transform

# To filter flights in November and December
filter(flights, month == 11 | month == 12)

# You can't write `filter(flights, month == 11 | 12)`, 

# A useful short-hand for this problem is `x %in% y`. 
# This will select every row where `x` is one of the values in `y`. 

# Alternatively you can use %in%
nov_dec <- filter(flights, month %in% c(11, 12))

# De Morgan's law: 
# `!(x & y)` is the same as `!x | !y` 
# `!(x | y)` is the same as `!x & !y` 

filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)

###-------------
### Discussion
###-------------

# Whenever you start using complicated, multipart expressions in 
# `filter()`, consider making them explicit variables instead. 

##----------------
## Missing values
##----------------

# One important feature of R that can make comparison tricky are 
# missing values, or `NA`s ("not availables"). 
# `NA` represents an unknown value so missing values are "contagious": 
# almost any operation involving an unknown value will also be unknown.

NA > 5
10 == NA
NA + 10
NA / 2

# The most confusing result is this one:
NA == NA

# If you want to determine if a value is missing, use `is.na()`:
is.na(x)

##----------
## Practice
##----------

# Import the Philly City salary data

# 1. Select City employees working in Mayor's office?

# 2. Select City employees who earned more than $250,000 in 2017?
#     Did you notice anything unusual about the result?

# 3. Select the City employees in the Mayor's office in the third quarter of 2017

# 4. Select the City employees in the Mayor's office or the City Council


##----------
## Answers
##----------

# import the data
library(readr)
# https://cran.r-project.org/web/packages/readr/README.html

employee_salaries <- read_csv("employee_salaries.csv")

# 1. Select City employees working in Mayor's office?
filter(employee_salaries, department=="MAYOR'S OFFICE")

# 2. Select City employees who earned more than $250,000 in 2017?
#     Did you notice anything unusual about the result?
filter(employee_salaries, annual_salary >= 250000 & calendar_year == 2017)
# Note that there are duplicates, since the data is quarterly and we have three quarters in 2017
filter(employee_salaries, annual_salary >= 250000 & calendar_year == 2017 & quarter == 3)
# there are two employees who make more than $250,000 a year

# 3. Select the City employees in the Mayor's office in the third quarter of 2017
filter(employee_salaries, department=="MAYOR'S OFFICE" & calendar_year == 2017 & quarter == 3)

# 4. Select the City employees in the Mayor's office or the City Council
filter(employee_salaries, department=="MAYOR'S OFFICE" | department=="CITY COUNCIL")


##-----------------------------
## Arrange rows with `arrange()`
##-----------------------------

# `arrange()` changes the order of the rows. 

arrange(flights, year, month, day)


# Use `desc()` to re-order by a column in descending order:

arrange(flights, desc(arr_delay))

##----------
## Practice
##----------

# 1. Sort City employees working in Mayor's office by their salary

# 2. Sort the departments by size of their workforce in the data set

##----------
## Answers
##----------

# 1. Sort City employees working in Mayor's office by their salary
arrange(filter(employee_salaries, department=="MAYOR'S OFFICE"), annual_salary)

# 2. Sort the departments by size of their workforce in the data set
arrange(data.frame(table(employee_salaries$department)),desc(Freq))


##--------------------------------
## Select columns with `select()`
##--------------------------------

# select() subset variables based on their names

# Select columns by name
select(flights, year, month, day)

# Select all columns between year and day (inclusive)
select(flights, year:day)

# Select all columns except those from year to day (inclusive)
select(flights, -(year:day))


# Helper functions for `select()`:
# `starts_with("abc")`: matches names that begin with "abc".
# `ends_with("xyz")`: matches names that end with "xyz".
# `contains("ijk")`: matches names that contain "ijk".
# `matches("(.)\\1")`: selects variables that match a regular expression.

#  This one matches any variables that contain repeated characters. 
#  `num_range("x", 1:3)` matches `x1`, `x2` and `x3`.
   
# select(flights, time_hour, air_time, everything())

##----------
## Practice
##----------

# 1. Select department, job title, and annual salary

##----------
## Answers
##----------

# 1. Select department, job title, and annual salary
select(employee_salaries, department, title, annual_salary)

##----------------------------------
## Create new variables with `mutate()`
##----------------------------------

# `mutate()` always adds new columns at the end of your dataset 

flights_sml <- select(flights, 
  year:day, 
  ends_with("delay"), 
  distance, 
  air_time
)
mutate(flights_sml,
  gain = arr_delay - dep_delay,
  speed = distance / air_time * 60
)

# Note that you can refer to columns that you've just created:

mutate(flights_sml,
  gain = arr_delay - dep_delay,
  hours = air_time / 60,
  gain_per_hour = gain / hours
)

# If you only want to keep the new variables, use `transmute()`:

transmute(flights,
  gain = arr_delay - dep_delay,
  hours = air_time / 60,
  gain_per_hour = gain / hours
)

##---------------------------
## Useful creation functions
##---------------------------

# Arithmetic operators: `+`, `-`, `*`, `/`, `^`. 

# Arithmetic operators are also useful in conjunction with the aggregate
# functions you'll learn about later. 
# For example, `x / sum(x)` calculates the proportion of a total, 
# and `y - mean(y)` computes the difference from the mean.
    
# Modular arithmetic: `%/%` (integer division) and `%%` (remainder), 
# where `x == y * (x %/% y) + (x %% y)`. 
# Modular arithmetic is a handy tool because it allows you to break 
# integers up into pieces. For example, in the flights dataset, 
# you can compute `hour` and `minute` from `dep_time` with:

transmute(flights,
    dep_time,
    hour = dep_time %/% 100,
    minute = dep_time %% 100
    )
# what is transmute?
?transmute
# mutate(): add new variable into the data set
# transmute(): only keep the new variables 


# Logs: `log()`, `log2()`, `log10()`. 
# Logarithms are an incredibly useful transformation for dealing 
# with data that ranges across multiple orders of magnitude. 
# All else being equal, I recommend using `log2()` 
# because it's easy to interpret: 
# a difference of 1 on the log scale corresponds to doubling on
# the original scale and a difference of -1 corresponds to halving.

# Offsets: `lead()` and `lag()` allow you to refer to leading or lagging 
# values. This allows you to compute running differences (e.g. `x - lag(x)`) 
# or find when values change (`x != lag(x))`. They are most useful in 
# conjunction with `group_by()`, which you'll learn about shortly.
(x <- 1:10)
lag(x)
lead(x)

# If you're doing a complex sequence of logical operations it's 
# often a good idea to store the interim values in new variables 
# so you can check that each step is working as expected.

##----------
## Practice
##----------

# 1. Create a new variable total_salary

# 2. Display the distribution of total_salary in 2017

# 3. Transform the total_salary by log(total_salary)

# 4. Disply the distributions of log_total_salary


##----------
## Answers
##----------

# 1. Create a new variable total_salary
employee_salaries <- mutate(employee_salaries, 
                            total_salary = annual_salary + ytd_overtime_gross)

# 2. Display the distribution of total_salary in 2017
library(ggplot2)
employee_salaries %>%
  filter(calendar_year == 2017 & quarter == 3) %>%
  ggplot(aes(x = total_salary)) + 
  geom_histogram() +
  scale_x_continuous(limits = c(1, 300000), labels = scales::dollar) 
  
# 3. Transform the total_salary by log(total_salary)
employee_salaries <- mutate(employee_salaries,
                            log_total_salary = log(total_salary))

# 4. Disply the distributions of total_salary and log_total_salary
employee_salaries %>%
  filter(calendar_year == 2017 & quarter == 3) %>%
  ggplot(aes(x = log_total_salary)) + 
  geom_histogram() +
  scale_x_continuous(limits = c(9, 13)) 
