##-------------------------------------------------
## Script # 2
## Based on Chapter 3 and 7 of r4ds
## Learning objectives:
##   1. Learn to how to ggplot2
##   2. Learn to conduct EDA/descriptive analysis
## Version: 01/06/2018
##-------------------------------------------------

##-----------
## Packages
##-----------
library(ggplot2)
library(tidyverse)
library(readr)

# The most likely data analysis that you will do at your work is
# exploratory data analysis (EDA). EDA is more art than science.
# The deep understanding of mathematical statistics or econometric 
# is not as important as intuitive and contextual knowledge about your data.

# The application of EDA can start with a question from your boss about 
# the data. Or you may generate questions from observing the data.
# You will search for answers by visualising, transforming, and modelling your data.
# As you learn more about the data, you will refine your questions 
# and/or generate new questions. At the end, the objective of your effort is
# to uncover a hidden structure of the data and communicate the findings to
# the decision makers, internal and external stakeholders. 

# Two questions usually guide your EDA:
# 1. What type of variation occurs within your variables? Technically, this question
# is about univarate distribution of the variables. 
# 2. What type of covariation occurs between your variables? This question is about
# bi- or multivarate associations among the variables. 

# Some definitions for our discussion
# 1. Variable     : a quantity, quality, or property that you can measure. 
# 2. Value        : the state of a variable when you measure it. The value of a
#    variable may change from measurement to measurement.
# 3. Observation  : a set of measurements made under similar conditions.
#    An observation will contain several values, each associated with a different 
#    variable. 
# 4. Tabular data : a set of values, each associated with a variable and 
#    an observation.  

# Import data
employee_salaries <- read_csv("employee_salaries.csv")
# We will use "employee_salaries.csv" from Open Data Philly website.


# We will use ggplot2 for most of our EDA work

###------------
### Discussion 
###------------

###------------------
### General tempate
###------------------
### ggplot(data = <DATA>, mapping = aes(<MAPPINGS>)) + 
###  <GEOM_FUNCTION>(
###    mapping = aes(<MAPPINGS>),
###    stat = <STAT>, 
###    position = <POSITION>
###  ) +
###  <COORDINATE_FUNCTION> +
###  <FACET_FUNCTION>


###------------------
### Useful websites
###------------------
### http://docs.ggplot2.org/current/
### This is how I learn to use ggplot: http://www.cookbook-r.com/Graphs/ 
### The official book on ggplot2: http://ggplot2.org/book/.
### Another very good book: http://socviz.co/.
### Download the cheatsheet for ggplot.
###----------------------------------------------------

##-------------------------------------
## Graphical display of distributions 
##-------------------------------------

# Your data analysis often begins with examining the distribution of your variables.

# Variation

# Variation is the tendency of the values of a variable to change from 
# measurement to measurement. Every variable has its own pattern of variation, 
# which can reveal interesting information. 

# The best way to understand that pattern is to visualise the distribution of 
# the variable's values.

##-----------------------------
## Categorical or Continuous 
##-----------------------------

# How you visualise the distribution of a variable will depend on whether the variable
# is categorical or continuous. 

# A variable is categorical if it can only take one of a small set of values. 
# In R, categorical variables are usually saved as factors or character vectors. 
# To examine the distribution of a categorical variable, use a bar chart:

##--------------------------------------
## Variation of categorical variables
##--------------------------------------

# looking at the distribution of a categorical variable
# we will use geom_bar to crate a bar graph
ggplot(data = employee_salaries) + 
  geom_bar(mapping = aes(x = calendar_year))

# Above codes contain two parts:
# First: you tell ggplot that your data is: employee_salaries
p1 <- ggplot(data = employee_salaries)
# Second: you tell ggplot to add geom_bar that map the variable: calendar_year.
p1 + geom_bar(mapping = aes(x = calendar_year))

# Let's look at geom_bar for more details:
?geom_bar

# Notice y-axis? It is strangely formatted. 
# We will fix it by changing calendar_year as a factor variable.

ggplot(data = employee_salaries) + 
  geom_bar(mapping = aes(x = as.factor(calendar_year)))

# Notice that you can transform the variable within ggplot. 

# Alternative approach: 
ggplot(data = employee_salaries) + 
  stat_count(mapping = aes(x = as.factor(calendar_year)))

# You can enter the data and create a bar graph
# this workflow is the same as what you will do in Excel
demo <- tribble(
  ~Department,      ~Employees,
  "Finance", 20,
  "IT", 10,
  "HR", 30
)

ggplot(data = demo) +
  geom_bar(mapping = aes(x = Department, y = Employees), stat = "identity")

# Can you create a bar graph that show % of departments in the data?
ggplot(data = employee_salaries) + 
  geom_bar(mapping = aes(x = as.factor(calendar_year), y = ..prop.., group = 1))
# Note the option group = 1.

##----------
## Practice
##----------

## 1. Why do we want to show % instead of counts? 

###------------
### Discussion 
###------------

### you can compute statistics inside ggplot, but it is not a good idea

###-------------
### Discussion
###-------------

### One more data set for us to explore. 
### This data is used to write an article fivethirtyeight
### https://github.com/fivethirtyeight/data/blob/master/college-majors/recent-grads.csv
### Articles that use the data: https://fivethirtyeight.com/tag/college-majors/


college_major <- read_csv("recent-grads.csv")
str(college_major)
View(college_major)

# As before we will concentrate on variation of a categorical variable: Major_category.

##-----------
## Practice 
##-----------

## 1. Can you produce a bar graph to display the variation of Major_category?

## 2. How would you describe this graph?

##----------
## Answers
##----------

ggplot(data = college_major) +
  geom_bar(mapping = aes(x = Major_category))

# It is difficult to read the labels on the x-axis
# So we will "flip" the graph 
ggplot(data = college_major) +
  geom_bar(mapping = aes(x = Major_category)) +
  coord_flip()

# Let's look at more about coord_flip().
?coord_flip

# The height of the bars displays how many observations occurred with each x value. 
# You can compute these values manually with `dplyr::count()`:

college_major %>% dplyr::count(Major_category) 

# Note that we are using a function from a package, dplyr, without explicitly loading dplyr. 

##--------------------------------------
## Variation of numeric variables
##--------------------------------------

# When we want to examine the variation/distribution of a numeric variable,
# we will use a histogram. 

##--------------------
## Bonus information
##--------------------

# When data file is large, it can take time to display the variations of numeric variables.
# To speed up our work we can sample the data for the 3rd quarter of 2017
employee_salaries_2017 <- employee_salaries %>% 
  filter(calendar_year == 2017 & quarter ==3) %>% # You will learn more about filter very soon.
  group_by(department) %>% # We are grouping the data by departments.
  # We will sample from each department so that we will maintain the structure of the data.
  # This is technically called Stratified Sampling. In this case, strata are departments.
  sample_frac(.5) # sample half of the workforce



# Histograms
ggplot(data = employee_salaries_2017) +
  geom_histogram(mapping = aes(x = annual_salary))

# Let's review the details of geom_histogram
?geom_histogram

ggplot(data = employee_salaries_2017) +
  geom_histogram(mapping = aes(x = annual_salary), binwidth = 5000)

# A histogram divides the x-axis into equally spaced bins and 
# then uses the height of a bar to display the number of observations 
# that fall in each bin. 

# You can set the width of the intervals in a histogram with the `binwidth` argument,
# which is measured in the units of the `x` variable. 
# You should always explore a variety of binwidths when working with histograms, 
# as different binwidths can reveal different patterns. 

# Scale of x-axi is in scientific notations. We can fix that in a variety of ways.
ggplot(data = employee_salaries_2017) +
  geom_histogram(mapping = aes(x = annual_salary)) +
  scale_x_continuous(labels = scales::dollar)

# Let's examine the option:
# http://ggplot2.tidyverse.org/reference/scale_continuous.html.


##-----------
## Practice
##-----------

# Use college_major data. 
# Examine a univariate distribution of a numeric variable: Median

## 1. Can you produce a graph to display the variation of Median?

## 2. How would you describe this graph?

##----------
## Answers
##----------

ggplot(data = college_major) +
  geom_histogram(mapping = aes(x = Median, binwidth = 0.5))

# We can make it little more informative by adding more information
# We know that Median is the median salary of college majors
# We will use a package __scales__
ggplot(data = college_major) +
  geom_histogram(mapping = aes(x = Median, binwidth = 0.5)) +
  scale_x_continuous(labels = scales::dollar)

# You can compute this by hand by combining `dplyr::count()` 
# and `ggplot2::cut_width()`:

college_major %>% 
  count(cut_width(Median, 0.5))

# Now that you can visualise variation, what should you look for in your plots? 
# And what type of follow-up questions should you ask? 

# Typical values

# 1. Which values are the most common? Why?
# 2. Which values are rare? Why? Does that match your expectations?
# 3. Can you see any unusual patterns? What might explain them?

# Clusters of similar values suggest that subgroups exist in your data. To understand the subgroups, ask:
# 1. How are the observations within each cluster similar to each other?
# 2. How are the observations in separate clusters different from each other?
# 3. How can you explain or describe the clusters?
# 4. Why might the appearance of clusters be misleading?

## Unusual values

# Outliers are observations that are unusual; 
# data points that don't seem to fit the pattern. 
# Sometimes outliers are data entry errors; other times outliers suggest 
# important new science. When you have a lot of data, outliers are 
# sometimes difficult to see in a histogram.  

ggplot(data = college_major) +
  geom_histogram(mapping = aes(x = Median, binwidth = 0.5)) +
  scale_x_continuous(labels = scales::dollar)

# Note that there is one college major that paid more than $100,000

##-----------
## Practice
##-----------

## what is that major?

##----------
## Answer
##---------
(data.frame(college_major$Major[college_major$Median > 100000]))


# You can "zoom" into any part of the distribution by "filtering" the data
low_wage_major <- college_major %>% 
  filter(Median < 40000)

ggplot(data = low_wage_major) +
  geom_histogram(mapping = aes(x = Median, binwidth = 0.5)) +
  scale_x_continuous(labels = scales::dollar)

# It's good practice to repeat your analysis with and without the outliers. 
# If they have minimal effect on the results, and you can't figure out why they're there, 
# it's reasonable to replace them with missing values, and move on. 
# However, if they have a substantial effect on your results, you shouldn't drop them 
# without justification. 
# You'll need to figure out what caused them (e.g. a data entry error) and 
# disclose that you removed them in your write-up.

## Missing values

# You can replace the unusual values with missing values.
# The easiest way to do this is to use `mutate()` to replace the variable
# with a modified copy. You can use the `ifelse()` function to replace
# unusual values with `NA`:

college_major_no_outlier <- college_major %>% 
  mutate(Median = ifelse(Median > 100000, NA, Median)) # You will learn more about mutate soon.

# ifelse() has three arguments. 
#  First argument: `test` should be a logical vector. 
#  The result will contain the value of the second argument, `yes`, 
#  when `test` is `TRUE`, and the value of the third argument, `no`, 
#  when it is false.

ggplot(data = college_major_no_outlier) +
  geom_histogram(mapping = aes(x = Median, binwidth = 0.5)) +
  scale_x_continuous(labels = scales::dollar)


##----------
## Practice
##----------

# 1. Go to https://github.com/fivethirtyeight/data and explore the data sets.
# 2. Pick a data set that you want to explore.
# 3. Download the data set.
# 4. Import it into R.
# 5. Explore the data by using ggplot.
#    a. Visualize the distribution of a categorical variable
#    b. Visualize the distribution of a numeric variable.

