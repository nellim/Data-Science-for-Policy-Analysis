##---------------------------------------------------------
## Script # 6
## Based on Chapter 7 of r4ds
## Learning objectives:
##   1. Learn to conduct exploratory/descriptive analysis
##-----------------------------------------------------------

library(tidyverse)
library(ggplot2)

###------------
### Discussion
###------------

### We will continue to explore technique to vitualize and analyze covariations.
### Determine input-output, independent-dependent relationship between the variables.
### And design the vitualization and analysis based on that determination. 

##---------------------------
## Continuous vs. Continuous
##---------------------------

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
  geom_point(mapping = aes(x = ShareWomen, y = Median)) +
  scale_x_continuous(name = "Percent Female", labels = scales::percent) +
  scale_y_continuous(name = "Median Wage", labels = scales::dollar)

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

##------------------------------
## Categorical vs. Categorical
##------------------------------

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

#------------------------
# General Social Survey
#------------------------

# To learn more about analyzing covariations among categorical variables,
# we will use Genearal Social Survey (GSS)
# It is the oldest and most established survey of social and political attitudes in US.
# You can get more information about GSS: http://gss.norc.org/ 

# bring the data
library(readstata13) # to read stata data file saved in version 13
gss <- read.dta13("gss_conlegis.dta")

#-------------------
# Data management 
#-------------------

# using str (compact display of the structure) function to examine objects
str(gss)
View(gss)

# In this example, we will analyze how much confidence Americans have in Congress.
# We want to know how their confidence has changed over the years. And we want to know
# whether the confidence in Congress varies across race and sex. 

##-------------------
## frequency tables
##-------------------

# Frequency tables are an important tools to analyze categorical variables.
# We can use table() to create basic frequency tables that show the distribution of 
# categorical variables like conlegis: "Confidence in Congress".

?table

#---------------
# one way table
#---------------

mytable1 <- with(gss, table(conlegis)) # save the table as an object
mytable1  # frequencies
# Note that there are levels (or categories) with no observations. We can remove these unused levels
# using droplevels()
gss <- gss %>% 
  droplevels() # drop levels in the data frame that unused

mytable1 <- with(gss, table(conlegis)) # save the table as an object
mytable1  # frequencies

# You can also get the same information using count()
gss %>% 
  count(conlegis)

# Simple counts are not as helpful as percentages. You will want to know the prevalence 
prop.table(mytable1) # proportions
prop.table(mytable1)*100 # percentages

##-----------
## Practice
##-----------

# 1. How would you describe the results? What is the levels of confidence Americans have in Congress?

#---------------
# two way table
#---------------

# To see a covariation between two categorical variables, we need a two-way table.

# We will use xtabs() to create a two-way table
?xtabs

# Note that xtabs() specify the variables in a formular that starts with the symbol ~

# For example, we want to see how the confidence in congress has changed over the years.

mytable2 <- xtabs(~ year+conlegis, data=gss)
mytable2

# Again counts are not as helpful as percentages. We can use prop.table() to get the percentages.
?prop.table

# But there are three different percentages you can compute for a crosstab:
#  1. Row percentages
#  2. Column percentages
#  3. Cell percentages

prop.table(mytable2, 1) # row proportions
prop.table(mytable2, 2) # column proportions
prop.table(mytable2) # cells proportions

# Good habit to add margins to the tables to confirm the direction of the computation.
addmargins(prop.table(mytable2, 1))
addmargins(prop.table(mytable2, 2))
addmargins(prop.table(mytable2))

##-----------
## Practice
##-----------

# 1. Which percentage should we use to analyze the changes over time?  

# 2. How would you describe the results? 

# 3. Subset the data for 2014?

# 4. Can you compute the covariation between race and the confidence in Congress?

# 5. Which percentage should we use to analyze the changes over time?  

# 6. How would you describe the results? 

##---------
## Answer
##---------

# 1. Which percentage should we use to analyze the changes over time?  

# 2. How would you describe the results? 

# 3. Subset the data for 2014?
gss2014 <- gss %>% 
  filter(year==2014) # subset GSS data for year == 2014

# 4. Can you compute the covariation between race and the confidence in Congress?
mytable3 <- xtabs(~ race+conlegis, data=gss2014)
mytable3 # frequencies
margin.table(mytable3,1) #row sums
margin.table(mytable3, 2) # column sums
addmargins(prop.table(mytable3)) # cell proportions
addmargins(prop.table(mytable3, 1)) # row proportions
addmargins(prop.table(mytable3, 2)) # column proportions

# 5. Which percentage should we use to analyze the changes over time?  

# 6. How would you describe the results? 

##-------------------
## Fancy Crosstabs
##-------------------

# Crosstabulations are essential elements of data analysis, especially among social scientists.
# Base R and Tidyverse don't have functions that create complex crosstabs like other softwares
# like SPPS or Stata.

# Two way table using CrossTable
# The results look like Stata or SPSS tables
library(gmodels)

?CrossTable

#CrossTable(x, y, digits=3, max.width = 5, expected=FALSE, prop.r=TRUE, prop.c=TRUE,
#           prop.t=TRUE, prop.chisq=TRUE, chisq = FALSE, fisher=FALSE, mcnemar=FALSE,
#           resid=FALSE, sresid=FALSE, asresid=FALSE,
#           missing.include=FALSE,
#           format=c("SAS","SPSS"), dnn = NULL, ...)

CrossTable(gss2014$race, gss2014$conlegis)
CrossTable(gss2014$race, gss2014$conlegis, prop.c=FALSE, prop.t=FALSE, prop.chisq=FALSE, format="SPSS")

CrossTable(gss$year, gss$conlegis, prop.c=FALSE, prop.t=FALSE, prop.chisq=FALSE, format="SPSS")

##-----------
## Practice
##-----------

# 1. Which group has the most confidence in Congress in 2014?
#    a. Men? Women?
#    b. White? Black? Other?

# 2. How does education affect confidence in Congress in 2014?

# 3. Which political party members have the highest confidence in Congress in 2014?

##---------
## Answer
##---------

# 1. Which group has the most confidence in Congress in 2014?
#    a. Men? Women?
#    b. White? Black? Other?

mytable4 <- xtabs(~ race+conlegis, data=gss2014)
addmargins(prop.table(mytable4, 1)) # row proportions

mytable5 <- xtabs(~ sex+conlegis, data=gss2014)
addmargins(prop.table(mytable5, 1)) # row proportions

# 2. How does education affect confidence in Congress in 2014?

mytable6 <- xtabs(~ degree+conlegis, data=gss2014)
addmargins(prop.table(mytable6, 1)) # row proportions

# 3. Which political party members have the highest confidence in Congress in 2014?

mytable7 <- xtabs(~ partyid+conlegis, data=gss2014)
addmargins(prop.table(mytable7, 1)) # row proportions

