##---------------------------------------------------------
## Script # 7
## Based on Chapter 15 and 28 of r4ds
## Learning objectives:
##   1. Manage factor/categorical variables
##   2. Learn more features of ggplot
##-----------------------------------------------------------

###-------------
### Discussion
###-------------

### Even though most data science and econometric literature is about analyzing 
### continuous variables, the most common type of variables you will work with 
### is categorical variables. 

##---------
## Factors
##---------

# In R, factors are used to work with categorical variables, variables that have a fixed 
# and known set of possible values. They are also useful when you want to display character 
# vectors in a non-alphabetical order.

# Historically, factors were much easier to work with than characters. As a result, many of the 
# functions in base R automatically convert characters to factors. 

# This means that factors often crop up in places where they're not actually helpful. 
# Fortunately, you don't need to worry about that in the tidyverse, and can focus on 
# situations where factors are genuinely useful.

# To work with factors, we'll use the __forcats__ package, which provides tools for dealing with 
# categorical variables (and it's an anagram of factors!). 

library(tidyverse)
library(forcats)

# Useful website for forcats package: http://stat545.com/block029_factors.html

## General Social Survey data comes with __forcats__

gss_cat
?gss_cat
summary(gss_cat)

# When factors are stored in a tibble, you can't see their levels so easily. 
# One way to see them is with `count()`:

gss_cat %>%
  count(race)

# Or with a bar chart:

ggplot(gss_cat, aes(race)) + 
  geom_bar()

# By default, ggplot2 will drop levels that don't have any values. 
# You can force them to display with:
  
ggplot(gss_cat, aes(race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)

# These levels represent valid values that simply did not occur in this dataset. 
# You can drop the unused levels using a function gss_cat()
gss_cat <- droplevels(gss_cat)

ggplot(gss_cat, aes(race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)


###------------
### Discission
###------------

### When working with factors, the two most common operations are:
### 1. changing the order of the levels
### 2. changing the values of the levels. 

##------------------------
## Modifying factor order
##------------------------
  
# It's often useful to change the order of the factor levels in a visualisation. 
# For example, imagine you want to explore the average number of hours spent watching 
# TV per day across religions:

relig_summary <- gss_cat %>%
  group_by(relig) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
)

ggplot(relig_summary, aes(tvhours, relig)) + geom_point()
# It is difficult to interpret this plot because there's no overall pattern. 

###-------------
### Discussion
###-------------

### We can improve it by reordering the levels of `relig` using fct_reorder(). 
### `fct_reorder()` takes three arguments:
### 1. `f`, the factor whose levels you want to modify.
### 2. `x`, a numeric vector that you want to use to reorder the levels.
### 3. Optionally, `fun`, a function that's used if there are multiple values of
###    `x` for each value of `f`. The default value is `median`.

ggplot(relig_summary, aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point()

# Reordering religion makes it much easier to see that people in the "Don't know" category 
# watch much more TV, and Hinduism & Other Eastern religions watch much less.

# As you start making more complicated transformations, I'd recommend moving them out of `aes()` 
# and into a separate `mutate()` step. For example, you could rewrite the plot above as:

relig_summary %>%
  mutate(relig = fct_reorder(relig, tvhours)) %>%
  ggplot(aes(tvhours, relig)) +
  geom_point()

# What if we create a similar plot looking at how average age varies across reported income level?

rincome_summary <- gss_cat %>%
  group_by(rincome) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    n = n()
    )

ggplot(rincome_summary, aes(age, fct_reorder(rincome, age))) + 
  geom_point()

##-------------------------
## Modifying factor levels
##-------------------------

###-------------
### Discussion
###-------------

### More powerful than changing the orders of the levels is changing their values. 
### This allows you to clarify labels for publication, and collapse levels for high-level displays. 
### The most general and powerful tool is `fct_recode()`. 

# It allows you to recode, or change, the value of each level. For example, take the `gss_cat$partyid`:

gss_cat %>% 
  count(partyid)

# The levels are terse and inconsistent. 
# Let's tweak them to be longer and use a parallel construction.

gss_cat %>%
  mutate(partyid = fct_recode(partyid,
    "Republican, strong" = "Strong republican",
    "Republican, weak"   = "Not str republican",
    "Independent, near rep" = "Ind,near rep",
    "Independent, near dem" = "Ind,near dem",
    "Democrat, weak"        = "Not str democrat",
    "Democrat, strong"      = "Strong democrat"
    )) %>%
  count(partyid)


### `fct_recode()` will leave levels that aren't explicitly mentioned as is, 
### and will warn you if you accidentally refer to a level that doesn't exist.

# To combine groups, you can assign multiple old levels to the same new level:

gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat",
                              "Other"                 = "No answer",
                              "Other"                 = "Don't know",
                              "Other"                 = "Other party"
                              )) %>%
  count(partyid)


###-------------
### Discussion
###-------------

### You must use this technique with care: if you group together categories that are 
### truly different you will end up with misleading results.

### If you want to collapse a lot of levels, `fct_collapse()` 
### is a useful variant of `fct_recode()`. 
### For each new variable, you can provide a vector of old levels:

gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
                                other = c("No answer", "Don't know", "Other party"),
                                rep = c("Strong republican", "Not str republican"),
                                ind = c("Ind,near rep", "Independent", "Ind,near dem"),
                                dem = c("Not str democrat", "Strong democrat")
                                )) %>%
  count(partyid)


# Sometimes you just want to lump together all the small groups to make a plot or table simpler. 
# That's the job of `fct_lump()`:

gss_cat %>%
  mutate(relig = fct_lump(relig)) %>%
  count(relig)

# The default behaviour is to progressively lump together the smallest groups, 
# ensuring that the aggregate is still the smallest group. 
# In this case it's not very helpful: it is true that the majority of Americans in this 
# survey are Protestant, but we've probably over collapsed.

# Instead, we can use the `n` parameter to specify how many groups (excluding other) we want to keep:

gss_cat %>%
  mutate(relig = fct_lump(relig, n = 10)) %>%
  count(relig, sort = TRUE) %>%
  print(n = Inf) # this code makes sure that all the data will be printed 

##--------------------------
## More features of  ggplot
##--------------------------

#------------------------
# General Social Survey
#------------------------

# We will use Genearal Social Survey (GSS) that we used in Script 6
# You can get more information about GSS: http://gss.norc.org/ 

# bring the data
library(readstata13) # to read stata data file saved in version 13
gss <- read.dta13("gss_conlegis.dta")

gss <- gss %>% 
  droplevels() # drop levels in the data frame that unused
# this makes your plots clean and tidy
# you can also use fct_drop() from __forcats__

# using str (compact display of the structure) function to examine objects
str(gss)
View(gss)
summary(gss)

# In this example, we will analyze how much confidence Americans have in Congress.
# We want to know how their confidence has changed over the years. And we want to know
# whether the confidence in Congress varies across race and sex.

# Now we learn how to display these results using R
# We will start with looking at the trends for all Americans

# first we need to compute the percentages for each category of
# the outcome variable: confidence in congress
mytable <- xtabs(~ year+conlegis, data=gss) # two-way table
mytable <- prop.table(mytable, 1) # row proportions
mydata <- data.frame(mytable) # transform the matrix into a dataframe

head(mydata)

mydata$Percent <- mydata$Freq # preparing % for Y-axis
mydata$Percent <- mydata$Percent*100
mydata$year <- as.character(mydata$year)
mydata$year <- as.numeric(mydata$year)

# basic line graph
plot1 <- ggplot(data = mydata, aes(x=year, y=Percent, linetype=conlegis)) +
  geom_line()
plot1
# take control of x and y 
plot2 <- plot1 + scale_x_continuous(breaks=seq(1973, 2014, 4)) +  
  scale_y_continuous(breaks=seq(0, 70, 5)) 
plot2
# Add labels
plot3 <- plot2 + labs(title="Confidence in Congress", x="Year", y="%", 
                      fill = "Levels")
plot3
# Add annotations
plot4 <- plot3 + annotate("text", x=1975, y=35, label="Watergate", colour="red") +
  annotate("text", x=1998, y=20, label="Clinton Impeachment", colour="blue") +
  annotate("text", x=2001, y=47, label="Republican Control", colour="red")
plot4
# Shaded rectangular box
plot5 <- plot4 + annotate("rect", xmin=1995, xmax=2007, ymin=0, ymax=70, alpha=.1,
                          fill="red")
plot5
# remove background using theme
plot6 <- plot5 + theme_bw() 
plot6
# remove grid lines
plot7 <- plot6 + theme_bw() + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
plot7
# Change Legend title
plot8 <- plot7 + labs(linetype='Levels')
plot8

# Now we will look at the outcomes by racial groups
# computing percentages to plot
mytable2 <- xtabs(~ year+race+conlegis, data=gss)
mytable2 <- ftable(prop.table(mytable2, c(1,2)))
mydata2 <- data.frame(mytable2)
library(dplyr) # make sure you install the package
# subset only those who have "hardly any confidence" in congress
mydata2 <- data.frame(mydata2 %>% filter(conlegis == "hardly any"))
mydata2$Percent <- mydata2$Freq
mydata2$Percent <- mydata2$Percent*100
mydata2$year <- as.character(mydata2$year)
mydata2$year <- as.numeric(mydata2$year)
View(mydata2)
plot9 <- ggplot(data = mydata2, aes(x=year, y=Percent, linetype=race)) +
  geom_line()
plot9
plot10 <- plot9 + scale_x_continuous(breaks=seq(1973, 2014, 4)) +  
  scale_y_continuous(breaks=seq(0, 70, 5)) 
plot10
plot11 <- plot10 + labs(title="Percent of Americans Who Had Hardly Any Confidence \nin Congress by Race", x="Year", y="%", 
                        fill = "Race")
plot11
plot12 <- plot11 + annotate("text", x=1975, y=35, label="Watergate", colour="red") +
  annotate("text", x=1998, y=20, label="Clinton Impeachment", colour="blue") +
  annotate("text", x=2001, y=47, label="Republican Control", colour="red")
plot12
plot13 <- plot12 + annotate("rect", xmin=1995, xmax=2007, ymin=0, ymax=70, alpha=.1,
                            fill="red")
plot13
plot14 <- plot13 + theme_bw() 
plot14
plot15 <- plot14 + theme_bw() + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
plot15
plot16 <- plot15 + labs(linetype='Race')
plot16


##--------
## Bonus
##--------

library(tidyverse)
# Subset the data for 2014?
gss2014 <- gss %>% 
  filter(year==2014) # subset GSS data for year == 2014

# now we look at outcomes in 2014 by racial groups
# mosaic plots are useful to see the relationships among categorical variables
library(vcd)
mosaic( ~ race + conlegis, data=gss2014, highlighting="conlegis",
        highlighting_fill=c("lightblue","pink","red"))
gss$conlegis <- factor(gss$conlegis, 
                        labels = c("Great Deal","Only Some", "Hardly Any"))
table(gss2014$race)
gss2014$race <- factor(gss2014$race, 
                       labels = c("W", "B", "O")) 
mosaic( ~ sex + race + conlegis, data=gss2014, highlighting="conlegis",
        highlighting_fill=c("lightblue","pink","red"),
        direction=c("h","h","v"))


# we can use a more traditional plot: bar graph to display the same information
mytable3 <- xtabs(~ race+conlegis, data=gss2014)
mytable3
mytable3 <- prop.table(mytable3, 1) # row proportions
mydata3 <- data.frame(mytable3)
mydata3$Percent <- mydata3$Freq
mydata3$Percent <- round(mydata3$Percent*100, digits=1)
mydata3a <- mydata3 %>% 
  group_by(race) %>% 
  mutate(label_y=cumsum(Percent))
plot17 <- ggplot(mydata3a, aes(x=race, y=Percent, fill=conlegis)) + 
  geom_bar(stat = "identity") +
  geom_text(aes(y=label_y,label=paste(Percent,"%"), vjust=1.5))
plot18 <- plot17 + theme_bw() + labs(fill="Levels")
plot18 


##----------------------------
## 3-dimensional covariation
##----------------------------

# we will look at differences across race AND sex

# dot plots
gss2014 <- gss2014 %>% 
  mutate(race_sex = paste(race, sex, sep = ' '))

gss2014$race_sex <- gss2014$race_sex %>% 
  fct_relevel("white female", "white male", "black female", "black male", "other female", "other male")

mytable4 <- xtabs(~ race_sex+conlegis, data=gss2014)
mytable4
mytable4 <- prop.table(mytable4, 1) # row proportions
mydata4 <- data.frame(mytable4)
mydata4$Levels <- mydata4$conlegis
mydata4$Percent <- mydata4$Freq
mydata4$Percent <- round(mydata4$Percent*100, digits=1)
ggplot(mydata4, aes(x=Percent, y=race_sex)) + 
  labs(title="Confidence in Congress by Race and Sex", x="Percent", y="Race and Sex") +
  scale_x_continuous(breaks=seq(0, 70, 10)) +
  geom_point(size=3, aes(colour=Levels)) 

##-----------
## Practice
##-----------

# 1. How would you explain the graph?

# 2. Can you say that the racial differences in the confidence in Congress vary across gender?



