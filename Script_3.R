##-------------------------------------------------
## Script # 3
## Based on Chapter 3 and 7 of r4ds
## Learning objectives:
##   1. Learn to how to ggplot2
##   2. Learn to conduct EDA/descriptive analysis
##-------------------------------------------------

##-----------
## Packages
##-----------
library(tidyverse)
library(readr)
library(ggplot2)
install.packages("ggthemes") # Install 
library(ggthemes) 


###-------------
### Discussion
###-------------

### We will use data of college majors and job outcomes 
### This data is used to write an article fivethirtyeight
### https://github.com/fivethirtyeight/data/blob/master/college-majors/recent-grads.csv
### Articles that use the data: https://fivethirtyeight.com/tag/college-majors/


college_major <- read_csv("recent-grads.csv")
str(college_major)
View(college_major)

##--------------------------
## Univariate distribution
##--------------------------

# Univariate distribution of a categorical variable: Major_category
# This will be our main input/independent variable for this analysis

ggplot(data = college_major) +
  geom_bar(mapping = aes(x = Major_category))

##-----------
## Practice
##-----------

## How would you describe this graph?

# It is difficult to read the labels on the x-axis
# So we will "flip" the graph 
ggplot(data = college_major) +
  geom_bar(mapping = aes(x = Major_category)) +
  coord_flip()

# The height of the bars displays how many observations occurred with each x value. 
# You can compute these values manually with `dplyr::count()`:

college_major %>% count(Major_category)

# Univariate distribution of a numeric variable: Median
# This will be our main output/dependent variable

# A variable is continuous if it can take any of an infinite set of ordered values. 
# Numbers and date-times are two examples of continuous variables. 
# To examine the distribution of a continuous variable, use a histogram:

ggplot(data = college_major) +
  geom_histogram(mapping = aes(x = Median, binwidth = 0.5))

##-----------
## Practice
##-----------

## How would you describe this graph?

# A histogram divides the x-axis into equally spaced bins and 
# then uses the height of a bar to display the number of observations 
# that fall in each bin. 

# You can set the width of the intervals in a histogram with the `binwidth` argument,
# which is measured in the units of the `x` variable. 
# You should always explore a variety of binwidths when working with histograms, 
# as different binwidths can reveal different patterns. 

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

# You can replac the unusual values with missing values.
# The easiest way to do this is to use `mutate()` to replace the variable
# with a modified copy. You can use the `ifelse()` function to replace
# unusual values with `NA`:

college_major_no_outlier <- college_major %>% 
  mutate(Median = ifelse(Median > 100000, NA, Median))

# ifelse() has three arguments. 
#  First argument: `test` should be a logical vector. 
#  The result will contain the value of the second argument, `yes`, 
#  when `test` is `TRUE`, and the value of the third argument, `no`, 
#  when it is false.

ggplot(data = college_major_no_outlier) +
  geom_histogram(mapping = aes(x = Median, binwidth = 0.5)) +
  scale_x_continuous(labels = scales::dollar)

##---------------------------------------
## Bi-variate or covariate distributions
##---------------------------------------

##----------------------------------------
## Categorical vs. continuous variable 
##----------------------------------------

# It's common to want to explore the distribution of a continuous variable broken down 
# by a categorical variable

# In this case, categorical variable is input/independent variable
#               continous variable is output/dependent variable

# You can use density to compare the distributions of continuous variable across categories
ggplot(mpg) +
  geom_density(mapping = aes(hwy))

ggplot(mpg, aes(hwy, colour = class)) +
  geom_density()

ggplot(mpg, aes(hwy, fill = class, colour = class)) +
  geom_density(alpha = 0.1)

# You can also use key statistics to compare the distributions of continuous variable across categories
ggplot(data = mpg) + 
  stat_summary(
    mapping = aes(x = class, y = hwy),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )

# Another example using college major data

ggplot(data = college_major) + 
  stat_summary(
    mapping = aes(x = Major_category, y = Median),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )

# Boxplot: boxplot is a type of visual shorthand for a distribution of values that is 
# popular among statisticians. 

ggplot(data = college_major, mapping = aes(x = Major_category, y = Median)) +
  geom_boxplot()

# difficult to read the labels on x-axis
# so we will flip the coordinate

ggplot(data = college_major, mapping = aes(x = Major_category, y = Median)) +
  geom_boxplot() +
  coord_flip()

# You can't tell what it is that we are plotting on y-axis
# because R is using scientific notation 
# we know that Median is $, we will use a package __scale__ to change the format 
ggplot(data = college_major, mapping = aes(x = Major_category, y = Median)) +
  geom_boxplot() +
  coord_flip() +
  scale_y_continuous(labels = scales::dollar)

# Wouldn't it be easier to learn from the graph if majors are sorted
ggplot(data = college_major) +
  geom_boxplot(mapping = aes(x = reorder(Major_category, Median, FUN = median), y = Median)) +
  coord_flip() +
  scale_y_continuous(labels = scales::dollar)
# Note that we use a function __reorder__ to sort the categories of Major_category 
# You can see the power of R 


##--------------------------------
## Categorical vs. by categorical
##--------------------------------

ggplot(data = mpg) + 
  geom_bar(mapping = aes(x = class, fill = trans))

###------------
### Discussion 
###------------

### urgly colors, we will learn to change them
### note that we can't really compare the distributions of transmissions 
### across categories: WHY?

ggplot(data = mpg) + 
  geom_bar(mapping = aes(x = class, fill = trans), position = "fill")



###------------
### Discussion 
###------------

### Now that you know how ggplot works
### we should review the materials on the ggplot website
### http://ggplot2.tidyverse.org/reference/


##----------
## Practice
##----------

# 1. Load the dataframe cps_2017_small.rds

# 2. Change the variable names:
#    a. STATEFIP = State
#    b. EDUC = Education
#    c. INCWAGE = Wage 
## Hint: use rename() in tidyverse

# 3. Look at the distribution of wages in 2017

# 4. Plot the relationship between wages and educational attainment

# 5. Add a regression line that fits the relationship between wages and
#    educational attainment

# 6. Show the differences in wage distributions across states

##----------
## Answers
##----------

# 1. Load the dataframe cps_2017_small.rds
cps_data <- readRDS("cps_2017_small.rds")

# 3. Look at the distribution of wages in 2017
ggplot(cps_data) +
  geom_density(mapping = aes(Wage))

# bonus answer: This code cut off workers with no wages or make more than $500,000
# and use a package scale to format the ticks 
ggplot(cps_data) +
  geom_density(mapping = aes(Wage)) + 
  scale_x_continuous(limits = c(1, 500000), labels = scales::comma)

# 4. Plot the relationship between wages and educational attainment
ggplot(cps_data, aes(x = Education, y = Wage)) +
  geom_point()

# bonus answer: This is survey data. Survey data often contains labelled variables.
# These variables often create problems. The best quick solution is to remove the labels
# when you are dealing with numeric/continous variables.
cps_data <- cps_data %>% 
  mutate(
    Education = as.numeric(Education) , 
    Wage = as.numeric(Wage)) 

ggplot(cps_data, aes(x = Education, y = Wage)) +
  geom_point()

ggplot(cps_data, aes(x = Yrs_Schooling, y = Wage)) +
  geom_point()

# 5. Add a regression line that fits the relationship between wages and
#    educational attainment

ggplot(data = cps_data, mapping = aes(x = Yrs_Schooling, y = Wage)) + 
  geom_smooth(method = "lm") +
  geom_smooth(method = "gam", formula = y ~ s(x)) 

# 6. Show the differences in wage distributions across sex
ggplot(cps_data, aes(Wage, fill = Sex, colour = Sex)) +
  geom_density(alpha = 0.1) + 
  scale_x_continuous(limits = c(1, 500000), labels = scales::comma)

# 7. Do females receive similar returns on their educational investment?
ggplot(data = cps_data) + 
  geom_smooth(mapping = aes(x = Yrs_Schooling, y = Wage, linetype = Sex))

##--------
## Bonus
##--------

ggplot(data = cps_data) + 
  geom_smooth(mapping = aes(x = Yrs_Schooling, y = Wage, colour = Sex)) +
  labs(
    title = "Gender gap in wages increases with the level of education in 2017",
    subtitle = "On average women earn less than men across all levels of education",
    caption = "Source: Current Population Survey"
  ) +
  annotate("text", x=8, y=55000, label="Non-linear regression lines with standard errors") +
  scale_x_continuous(name = "Education (Years of Schooling)", breaks=seq(0, 20, 2)) +
  scale_y_continuous(name = "Wage", breaks=seq(0, 150000, 25000), labels = scales::dollar) +
  scale_colour_manual(values = c(Male = "red", Female = "blue"), labels = c("Men", "Women")) +
  theme(
    panel.grid.major = element_line(size = 0.5, linetype = 'solid',
                                    colour = "white"), 
    panel.grid.minor = element_line(size = 0.25, linetype = 'solid',
                                    colour = "white")
  )
