##----------------------------------------------------
## Script # 3
## Based on Chapter 5 of r4ds
## Learning objectives:
##   1. Learn to wrangle your data and more ggplot2
##----------------------------------------------------

#
# This script covers the final "verb" of dplyr: summarize()
# When you combine summarize() with group_by(), it becomes very powerful
#

library(tidyverse)
library(nycflights13)
library(ggplot2)

##--------------------------------------
## Grouped summaries with summarise()
##--------------------------------------

# `summarise()` collapses a data frame to a single row

summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

# `summarise()` is not terribly useful unless we pair it with `group_by()`. 
# This changes the unit of analysis from the complete dataset to 
# individual groups. Then, when you use the dplyr verbs on a grouped data 
# frame they'll be automatically applied "by group". 

# For example, if we applied exactly the same code to a data frame grouped by date, 
# we get the average delay per date:

by_day <- group_by(flights, year, month, day)
# above line saves a sorted and grouped copy of the data set flights 
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

##----------------------------------------------
## Combining multiple operations with the pipe
##----------------------------------------------

# Explore the relationship between the distance and average delay for each location. 
# Using what you know about dplyr, you might write code like this:

by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
  count = n(),
  dist = mean(distance, na.rm = TRUE),
  delay = mean(arr_delay, na.rm = TRUE)
  )
(delay <- filter(delay, count > 20, dest != "HNL"))

# It is difficult to see the relationship from the data frame
# So we will plot the data
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

# There are three steps to prepare this data:
# 1.  Group flights by destination.
# 2.  Summarise to compute distance, average delay, and number of flights.
# 3.  Filter to remove noisy points and Honolulu airport, which is almost
#     twice as far away as the next closest airport.

# We can solve the same problem with the pipe, `%>%`:

delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")

##-----------
## Practice
##-----------

# 1. Import the Philly city salaries data into R

# 2. How many employees in each of the departments in the City in 2017

# 3. Show the departmental distribution of average annual salaries?

# 4. Show the departmental distribution of median salaries?


##----------
## Answers
##----------

# 1. Import the Philly city salaries data into R
employee_salaries <- read_csv("employee_salaries.csv")

# 2. How many employees in each of the departments in the City in 2017
employee_salaries_2017 <- employee_salaries %>%
  filter(calendar_year == 2017 & quarter == 3) %>%
  group_by(department) %>% 
  summarise(
    count = n(),
    mean_salary = mean(annual_salary, na.rm = TRUE),
    median_salary = median(annual_salary, na.rm = TRUE)
  ) 
(data.frame(employee_salaries_2017$department,employee_salaries_2017$count))
# to be more helpful, we can sort the data by count
(data.frame(employee_salaries_2017$department,sort(employee_salaries_2017$count)))
# density plot of the distribution
ggplot(data = employee_salaries_2017, mapping = aes(x = count)) + 
  geom_histogram() 
# density plot of the distribution without outliers
ggplot(data = employee_salaries_2017, mapping = aes(x = count)) + 
  geom_histogram() +
  xlim(0,9000)

# 3. Show the departmental distribution of average annual salaries?
ggplot(data = employee_salaries_2017, mapping = aes(x = mean_salary)) + 
  geom_histogram()

ggplot(data = employee_salaries_2017, mapping = aes(x = mean_salary)) + 
  geom_histogram() +
  xlim(0,110000)

# 4. Show the departmental distribution of median salaries?
ggplot(data = employee_salaries_2017, mapping = aes(x = median_salary)) + 
  geom_histogram()


ggplot(data = employee_salaries_2017, mapping = aes(x = median_salary)) + 
  geom_histogram() +
  xlim(20000,110000)


##-----------------
## Missing values
##-----------------

# You may have wondered about the `na.rm` argument we used above. 
# What happens if we don't set it?

flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

# We get a lot of missing values! 
# That's because aggregation functions obey the usual rule of missing values: 
# if there's any missing value in the input, the output will be a missing value. 

# Fortunately, all aggregation functions have an `na.rm` argument 
# which removes the missing values prior to computation:

flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay, na.rm = TRUE))

# In this case, where missing values represent cancelled flights, 
# we could also tackle the problem by first removing the cancelled flights. 
# We'll save this dataset so we can reuse in the next few examples.

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

##----------
## Counts
##----------

# Whenever you do any aggregation, 
# include either a count (`n()`), 
# or a count of non-missing values (`sum(!is.na(x))`). 
# Check that you're not drawing conclusions based on very small amounts of data. 


delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)


# there are some planes that have an _average_ delay of 5 hours (300 minutes)!

# The story is actually a little more nuanced. 

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

# The shape of this plot is very characteristic: 
# whenever you plot a mean (or other summary) vs. group size, 

# The following codes combine dplyr and ggplot
delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
    geom_point(alpha = 1/10)

##---------------------------------------------
## Useful summary functions {#summarise-funs}
##---------------------------------------------

# Combine aggregation with logical subsetting. 
not_cancelled %>% 
      group_by(year, month, day) %>% 
      summarise(
        avg_delay1 = mean(arr_delay),
        avg_delay2 = mean(arr_delay[arr_delay > 0]) # the average positive delay
      )

# Measures of spread: `sd(x)`, `IQR(x)`, `mad(x)`. 
not_cancelled %>% 
      group_by(dest) %>% 
      summarise(distance_sd = sd(distance)) %>% 
      arrange(desc(distance_sd))

# Measures of rank: `min(x)`, `quantile(x, 0.25)`, `max(x)`. 

# When do the first and last flights leave each day?
not_cancelled %>% 
      group_by(year, month, day) %>% 
      summarise(
        first = min(dep_time),
        last = max(dep_time)
      )

# Measures of position: `first(x)`, `nth(x, 2)`, `last(x)`. 
not_cancelled %>% 
      group_by(year, month, day) %>% 
      summarise(
        first_dep = first(dep_time), 
        last_dep = last(dep_time)
      )

# These functions are complementary to filtering on ranks. 
# Filtering gives you all variables, with each observation in a separate row:
not_cancelled %>% 
      group_by(year, month, day) %>% 
      mutate(r = min_rank(desc(dep_time))) %>% 
      filter(r %in% range(r))

# Counts: Youve seen n(), which takes no arguments, and returns the 
# size of the current group. 
# To count the number of non-missing values, use `sum(!is.na(x))`. 
# To count the number of distinct (unique) values, use `n_distinct(x)`.
    
# Which destinations have the most carriers?
not_cancelled %>% 
      group_by(dest) %>% 
      summarise(carriers = n_distinct(carrier)) %>% 
      arrange(desc(carriers))

# You can optionally provide a weight variable. For example, you could use 
# this to "count" (sum) the total number of miles a plane flew:
not_cancelled %>% count(tailnum, wt = distance)

# Counts and proportions of logical values: `sum(x > 10)`, `mean(y == 0)`.
# When used with numeric functions, `TRUE` is converted to 1 and `FALSE` to 0. 
# This makes `sum()` and `mean()` very useful: `sum(x)` gives the number of 
# `TRUE`s in `x`, and `mean(x)` gives the proportion.
    
# How many flights left before 5am? (these usually indicate delayed
# flights from the previous day)
not_cancelled %>% 
      group_by(year, month, day) %>% 
      summarise(n_early = sum(dep_time < 500))
    
# What proportion of flights are delayed by more than an hour?
not_cancelled %>% 
      group_by(year, month, day) %>% 
      summarise(hour_perc = mean(arr_delay > 60))

### Grouping by multiple variables

# When you group by multiple variables, 
# each summary peels off one level of the grouping. 
# That makes it easy to progressively roll up a dataset:

daily <- group_by(flights, year, month, day)
(per_day   <- summarise(daily, flights = n()))
(per_month <- summarise(per_day, flights = sum(flights)))
(per_year  <- summarise(per_month, flights = sum(flights)))

# Be careful when progressively rolling up summaries: 
# it's OK for sums and counts, but you need to think 
# about weighting means and variances, and 
# it's not possible to do it exactly for rank-based 
# statistics like the median. 

### Ungrouping

# To remove grouping
daily %>% 
  ungroup() %>%             # no longer grouped by date
  summarise(flights = n())  # all flights


##-----------
## Practice
##-----------

##---------------
## More Practice
##---------------

# 1. Import the proposed city operational budget into R

# 2. How many departments the city has?

# 3. How much is the budget for each department?

# 4. Which department gets the largest budget?


##---------
## Answers:
##---------

# 1. Import the proposed city operational budget into R
city_budget <- read_csv("operating_budget_fy_2018_proposed.csv")

# 2. How many departments the city has?
unique(city_budget$department)

# 3. How much is the budget for each department?
city_budget_department <- city_budget %>% 
  group_by(department) %>% 
  summarise(Total_budget = sum(total))
ggplot(city_budget_department, aes(x = department, y = Total_budget)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = scales::dollar)
# make it easier to read the labels
ggplot(city_budget_department, aes(x = department, y = Total_budget)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = scales::dollar) +
  coord_flip()
# let sort the data 
ggplot(city_budget_department, aes(x = reorder(department,Total_budget), y = Total_budget)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = scales::dollar) +
  coord_flip()
# filter top 15 department
city_budget_department_top20 <- city_budget_department %>%
  top_n(30, wt=Total_budget)
ggplot(city_budget_department_top20, aes(x = reorder(department,Total_budget), y = Total_budget)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = scales::dollar) +
  coord_flip()

# 4. Which department gets the largest budget?
city_budget_department$department[city_budget_department$Total_budget==max(city_budget_department$Total_budget)]

