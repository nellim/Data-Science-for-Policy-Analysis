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

##-----------------------------------------
## Bi-variate or multivariate covariations
##-----------------------------------------

# In the last script, we learn how to explore and display 
# univarate distributions of categorical as well as continous variables.

# But our analyses are rarely about univariate distributions.
# Most of our work is about finding policy levers to bring about change. 
# For instance, we will want to know whether the reduction in classroom size 
# improve students' learning? Or does an increase in tax on soft drinks reduce
# the consumption of soft drinks? 

# These questions are about cauality. Finding causal relationships are very difficult. 

###-------------
### Discussion
###-------------

### What do we mean when we say something is a cause of another?
### There are many books and articles written about this topic.
### https://en.wikipedia.org/wiki/Causality
### http://www.stat.columbia.edu/~gelman/research/published/causalreview4.pdf

# Examining co-varations between variables is often the first step
# toward answering those policy questions.  

# When we examine co-variations, it is important to determine input-output, 
# independent-dependent relationship between the variables,
# and design the vitualization and analysis based on that determination. 

##------------------------------------------
## Co-variation between continous variables
##------------------------------------------

# When both dependent and independent variables are continuous/numeric variables,
# scatterplot is the most common way to vitualize the covariation.
# You can see covariation as a pattern in the points: `geom_point()`. 

# For example, we can visualize the covariation between the representation of female
# in a college major and the median income of that major
# In this case, the unit of analysis is : college majors
#               the input variable is   : Percent Female
#               the output variable is  : Median Wage
# Both of the variables are numeric/continous variables.

# import the data from fivethirtyeight
college_major <- read_csv("recent-grads.csv")

ggplot(data = college_major) +
  geom_point(mapping = aes(x = ShareWomen, y = Median)) 

##-------
## Bonus
##-------

# We can improve the graph with better scales and labels for the axes by using
# scale_x_continuous()
# scale_y_continuous()
?scale_x_continuous
?scale_y_continuous
ggplot(data = college_major) +
  geom_point(mapping = aes(x = ShareWomen, y = Median)) +
  scale_x_continuous(name = "Percent Female", labels = scales::percent) +
  scale_y_continuous(name = "Median Wage", labels = scales::dollar)

##----------
## Practice
##----------

## 1. Why ShareWomen is plotted on y-axis and Median on x-axis?

## 2. In general, how do you decide which variable should be on which axis?

##--------
## Answer
##--------

## Output : dependent variable : y-axis
## Input : independent variable : x-axis

##--------------------------------------- 
## Add more information into the graph
##----------------------------------------
ggplot(data = college_major) +
  geom_point(mapping = aes(x = ShareWomen, y = Median, color = "green")) 
# note: Inside of aes(): ggplot2 treats input as value in the data
#       space and maps it to a value in the visual space.

ggplot(college_major) + geom_point(aes(x = ShareWomen, y = Median), color = "green")
# note: Outside of aes(): ggplot2 treats input as value in
#       the visual space and sets the property to it.

ggplot(college_major) + geom_point(aes(x = ShareWomen, y = Median, color = Major_category))
# You can add third variable into the splot

#---------
# facets
#---------

# You can use facets to add third dimension to the graph.

#
# facet_grid() - 2D grid, rows ~ cols, . for no split
# facet_wrap() - 1D ribbon wrapped into 2D
#

ggplot(data = college_major) + 
  geom_point(mapping = aes(x = ShareWomen, y = Median)) + 
  facet_wrap(~ Major_category, nrow = 2)


##------------------
## Regression lines
##------------------

# We can use geom_smooth to estimate regressions and display the model on a graph

ggplot(data = college_major) + 
  geom_smooth(mapping = aes(x = ShareWomen, y = Median))

###-------------
### Discussion
###-------------

### How can we describe the graph? 
### Anything strange about this graph?

ggplot(data = college_major) + 
  geom_point(mapping = aes(x = ShareWomen, y = Median)) +
  geom_smooth(mapping = aes(x = ShareWomen, y = Median))

### How can we describe the graph? 
### Anything strange about this graph?

ggplot(data = college_major, mapping = aes(x = ShareWomen, y = Median)) + 
  geom_point(mapping = aes(color = Major_category)) + 
  geom_smooth()

### How can we describe the graph? 
### Anything strange about this graph?

###------------
### Discussion 
###------------

###-------------------------------- 
### Note about global and local
###--------------------------------
###
### Mappings (and data) that appear in ggplot() will apply globally to every layer
### ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
###  geom_point() +
###  geom_smooth()
###
### Mappings (and data) that appear in a geom_ function will add to or override the
### global mappings for that layer only
### ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
###  geom_point(mapping = aes(color = drv)) +
###  geom_smooth()
###
### Automatically draws a single line for each group implied by color.
### This occurs for other "monolithic" geoms as well.
### ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
###  geom_point(mapping = aes(color = drv)) +
###  geom_smooth(mapping = aes(color = drv), se = FALSE)

##--------------------------------------------
## adding a few more options for geom_smooth
##--------------------------------------------

ggplot(data = college_major, mapping = aes(x = ShareWomen, y = Median)) + 
  geom_smooth(method = "gam", formula = y ~ s(x))

ggplot(data = college_major, mapping = aes(x = ShareWomen, y = Median)) + 
  geom_smooth(method = "lm")

ggplot(data = college_major, mapping = aes(x = ShareWomen, y = Median)) + 
  geom_smooth(method = "lm") +
  geom_smooth(method = "gam", formula = y ~ s(x))

###-------------
### Discussion
###-------------

### lm is a Orginary Least Square regression
### How can we describe the graph? 
### Anything strange about this graph?
### Compare this graph with previous graph
### What do you see?

##----------------------
## update on template
##----------------------

# ggplot(data = <DATA>) +
#   <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>),
#                   stat = <STAT>) +
#   <FACET_FUNCTION>

##------------
## Practice 
##------------

# 1. Show the covariation between the representation of female in a college major and 
#    the unemployment rate of college graduates with that major

# 2. Compare the two covariations: 
#   (1) the representation of female in a college major and the median income and
#   (2) the representation of female in a college major and the unemployment rate.
#   What do you find?

##---------
## Answer
##---------

# 1. Show the covariation between the representation of female in a college major and 
#    the unemployment rate of college graduates with that major

ggplot(data = college_major) +
  geom_point(mapping = aes(x = ShareWomen, y = Unemployment_rate)) +
  scale_x_continuous(name = "Percent Female", labels = scales::percent) +
  scale_y_continuous(name = "Unemployment Rate", labels = scales::percent)

# Scatterplots become less useful as the size of your dataset grows, because points begin to overplot, 
# and pile up into areas of uniform black (as above).

# As an example, we can analyze the Current Population Survey (CPS) data.
# CPS is the offical data source for the US Bureau of Labor Statistics to 
# monitor the conditions of the national labor force. 

###-------------
### Discussion
###-------------

### The best place to get data from the national surveys is: www.ipums.org


# Load the data
cps_small <- readRDS("cps_2017_small.rds")

ggplot(data = cps_small) +
  geom_point(mapping = aes(x = Yrs_Schooling, y = Wage))

# One way to fix the problem: using the `alpha` aesthetic to add transparency.
ggplot(data = cps_small) +
  geom_point(mapping = aes(x = Yrs_Schooling, y = Wage), alpha = 1/100)


# Another option is to bin one continuous variable so it acts like a categorical variable. 
# You could bin `Yrs_Schooling` and then for each group, display a boxplot:

ggplot(data = cps_small, mapping = aes(x = Yrs_Schooling, y = Wage)) + 
  geom_boxplot(mapping = aes(group = cut_width(Yrs_Schooling, 0.1))) +
  scale_x_continuous(name = "Years of Schooling") + 
  scale_y_continuous(name = "Wage", labels = scales::dollar)

# You can also control the bin based on our knowledge about the years of education.
# Let's group the years of education into:
#  1. Less than HS (<HS)
#  2. High School (HS)
#  3. Some College (Some College)
#  4. BS (BS)
#  5. Graduate school (Grad)
cps_small <- cps_small %>% 
  drop_na(Yrs_Schooling) %>%
  mutate(Degree=cut(Yrs_Schooling, breaks=c(-Inf, 11, 12, 15, 16, 20), 
                    labels=c("<HS","HS","Some College", "BS", "Grad")))

ggplot(data = cps_small, mapping = aes(x = Degree, y = Wage)) + 
  geom_boxplot() +
  scale_x_discrete(name = "Education") + 
  scale_y_continuous(name = "Wage", labels = scales::dollar)

# remove the outliers and zoom in and see the relationship better
ggplot(data = cps_small, mapping = aes(x = Degree, y = Wage)) + 
  geom_boxplot(outlier.shape = NA) +
  scale_x_discrete(name = "Education") + 
  scale_y_continuous(name = "Wage", labels = scales::dollar, limits = c(0, 200000) )

##----------------------------------------------------------------------
## Covariation between a categorical variable and a continuous variable 
##----------------------------------------------------------------------

# It's common to want to explore the distribution of a continuous variable broken down 
# by a categorical variable.

# In this case, categorical variable is input/independent variable
#               continous variable is output/dependent variable

###------------
### Discussion
###------------

### What should we do when the input variable is continous and the output variable
### is categorical?

# We will use a data set, mpg, that comes with ggplot package.
?mpg

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


##---------------------------------
## Both variables are categorical 
##---------------------------------

# When both input/independent variable and output/dependent variable are categorical,
# you'll need to count the number of observations for each combination. 
# One way to do that is to rely on the built-in `geom_count()`:

ggplot(data = mpg) +
  geom_count(mapping = aes(x = class, y = drv))

# The size of each circle in the plot displays how many observations 
# occurred at each combination of values. 
# Covariation will appear as a strong correlation between specific x values and specific y values. 

# Another approach is to compute the count with dplyr:

mpg %>% 
  count(class, drv)

# Then visualise with `geom_tile()` and the fill aesthetic:

mpg %>% 
  count(class, drv) %>%  
  ggplot(mapping = aes(x = class, y = drv)) +
  geom_tile(mapping = aes(fill = n))

# Or we can use a stacked bar graph
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
