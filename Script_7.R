##---------------------------------------------------------
## Script # 7
## Based on Chapter 15 of r4ds
## Learning objectives:
##   1. Manage factor/categorical variables
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
