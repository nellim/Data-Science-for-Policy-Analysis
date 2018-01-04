##---------------------------------------------------------
## Script # 8
## Learning objectives:
##  1. estimate OLS regression models
##  2. Use ggplot2 to make graphs from your data 
##--------------------------------------------------------


###-------------
### Discussion
###-------------

### There are a few national surveys that the Census Bureau and the Bureau of Labor Statistics
### collect and use to monitor the changes in the country
### Good to be familiar with these data sources. Since many governmental agencies 
### and non-profit organizations use these data 

### The best place to learn these data sources is www.ipums.org
### There are few packages to help you use Census data: 
###   1. __tidycensus__: https://github.com/walkerke/tidycensus
###   2. __ipumsr__: https://cran.r-project.org/web/packages/ipumsr/vignettes/ipums.html

library(tidyverse)
library(ggplot2)
library(readstata13) # to read stata data file saved in version 13

# bring in the data 
acs <- read.dta13("acsphillylaborforce.dta")
names(acs)


###################
# Data management #
###################

# create duplicate variables with new names 
# for better graphic and summary tables
acs <- acs %>% 
  rename(
    Race = raceth,
    Sex  = sex,
    Education = educ_year,
    Degree = education,
    Occupation = gen_occ,
    Industry = ind_cat5,
    Income = incwage,
    Managers = leader_cat,
    Age = age,
    College_major = major1,
    Marital_status = marst
  ) %>% 
  mutate(
    Age = as.numeric(Age)
  )

# you can add more documentation into your data by using labels
library(Hmisc)
# Hmisc is an old package that contains may useful functions
# http://data.vanderbilt.edu/fh/R/Hmisc/examples.nb.html 
# http://biostat.mc.vanderbilt.edu/wiki/Main/Hmisc 
label(acs$Income) <-  "Income from wages"
label(acs$Income) <- "Income from wages"
label(acs$Education) <- "Years of schooling"
label(acs$Managers) <- "Managerial Positions"
label(acs$Occupation) <- "Major Occupational Categories"
label(acs$Industry) <- "Major Industrial Categories"

# drop observations with no income

###-------------
### Discussion
###-------------

### many data set assign some values for missing data
### it is important to know your data
acs <- subset(acs, Income > 0 & Income < 999998)

###########
# Outcome #
###########
#look at our outcome variable: income from wages
summary(acs$Income)

# select some explanatory variables 
myvars <- c("Sex", "Race", "Age", "Education", "Occupation", "Industry")
# note how we use sapply to repeatedly apply the same operation on
# all variables in myvars
sapply(acs[myvars], summary)
# notice that something is wrong with age
acs$Age <- as.numeric(acs$Age)
summary(acs$Age)

####################
# comparing groups #
####################
# income difference between males and females
# use aggregate to compute average incomes by sex
# note that we exclude missing values in the calculation
aggregate(acs$Income, list(Sex = acs$Sex), mean)
# alternatively we can compute the same statistics with this code
# I like this second option, because it explicitly states which is
# the dependent variable and which is independent variable
# in this case Income is the dependent variable, Sex, the independent variable
mytable1 <- acs %>% 
  group_by(Sex) %>% 
  summarise(count = n(), 
            MeanIncome = mean(Income, na.rm = TRUE))

# use a package called plyr to rename the variable (Income)
# to (MeanIncome) to make the results more informative
mytable1 <- acs %>% 
  group_by(Sex) %>% 
  summarise(count = n(), 
            MeanIncome = mean(Income, na.rm = TRUE))

mytable1$diff <- mytable2$MeanIncome - mytable2$MeanIncome[1]
mytable1$diff_percent <- (mytable2$diff/mytable2$MeanIncome[1])*100
mytable1

##-----------
## Practice
##-----------

# 1. Vitualize the gender differences in income

##---------
## Answer
##---------

# 1. Vitualize the gender differences in income

# some graphical options for the income differences by gender
# this use the aggregate data computed above
ggplot(mytable1, aes(x=Sex, y=MeanIncome)) +
  geom_bar(stat="identity", width=0.5)

# the following options use ggplot2 to compute the statistics
ggplot(data = acs) +
  stat_summary_bin(
    mapping = aes(x = Sex, y = Income), 
    fun.y = "mean", 
    geom = "bar"
    ) 

ggplot(data = acs) +
  stat_summary(
    mapping = aes(x = Sex, y = Income),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = "mean"
  )

ggplot(data = acs,
       mapping = aes(x = Sex, y = Income)) +
  geom_boxplot()

# change set up option
options(scipen = 100000) # remove the scientific notation
#options(scipen = 0) # restore default

ggplot(data = acs,
       mapping = aes(x = Sex, y = Income)) +
  geom_boxplot()

#-----------------
# Bonus options
#-----------------

# Calculation of mean and sd of each group 
# This time we are going to display means and Standard Deviations for each group
Sex_diff <- acs %>% 
  group_by(Sex) %>% 
  summarise(count = n(), 
            Mean_Income = mean(Income, na.rm = TRUE),
            Std_Div = sd(Income, na.rm = TRUE))

# Make the plot
ggplot(Sex_diff) + 
  geom_point(aes(x=Sex , y=Mean_Income), color="red", size = 3) +
  geom_errorbar(data = Sex_diff, aes(x = Sex, y = Std_Div, ymin = Mean_Income - Std_Div, 
                                     ymax = Mean_Income + Std_Div), width=0.10)


# Regression is just a pivot table
fit <- lm(Income ~ Sex, data=acs)
summary(fit)
mytable1

fit <- lm(log(Income) ~ Sex, data=acs)
summary(fit)
mytable1


##----------
## Practice  
##----------

# 1. Compute the income differences across racial and ethnic
#     groups in Philly
# 2. Which group has the highest average income in Philly?
# 3. Which group has the lowest average income in Philly?
# 4. Produce the graphical display of racial income differences
#    in Philly?
# 5. Estimate the regression model that summarizes
#    racial differences in income in Philly?

##----------
## Answer  
##----------

# Income differencs among racial and ethnic groups
mytable2 <- aggregate(Income~Race,data=acs,FUN = mean, na.rm = TRUE)
mytable2 <- plyr::rename(mytable2, c("Income"="MeanIncome"))
mytable2$diff <- mytable2$MeanIncome - mytable2$MeanIncome[1]
mytable2$diff_percent <- (mytable2$diff/mytable2$MeanIncome[1])*100
mytable2

# Question #4: Produce the graphical display of racial income differences
# in Philly?
ggplot(mytable2, aes(x=Race, y=MeanIncome)) +
       geom_bar(stat="identity")

options(scipen = 0) # restore default
ggplot(acs, aes(x=Race, y=Income)) + geom_boxplot() + 
  scale_y_continuous(breaks=seq(0, max(acs$Income), 40000))

# Question #5: Estimate the regression model that summarizes
# racial differences in income in Philly?

# Regression is just a pivot table
fit2 <- lm(Income ~ as.factor(Race), data=acs)
summary(fit2)
mytable2

fit2 <- lm(log(Income) ~ as.factor(Race), data=acs)
summary(fit2)
mytable2

