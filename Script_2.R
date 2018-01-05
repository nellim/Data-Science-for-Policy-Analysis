##-------------------------------------------------
## Script # 2
## Based on Chapter 3 and 7 of r4ds
## Learning objectives:
##   1. Learn to how to ggplot2
##   2. Learn to conduct EDA/descriptive analysis
##-------------------------------------------------

##-----------
## Packages
##-----------
library(ggplot2)
library(tidyverse)


# The most likely data analysis that you will do at your work is
# exploratory data analysis, or EDA for short. 

# EDA is an iterative cycle. 

# You:
# 1. Generate questions about your data.
# 2. Search for answers by visualising, transforming, and modelling your data.
# 3. Use what you learn to refine your questions and/or generate new questions.

# Two guiding questions for your EDA:

# 1. What type of variation occurs within your variables?
# 2. What type of covariation occurs between your variables?


# Some definitions
# 1. __variable__ is a quantity, quality, or property that you can measure. 
# 2. A __value__ is the state of a variable when you measure it. The value of a
#    variable may change from measurement to measurement.
# 3. An __observation__ is a set of measurements made under similar conditions.
#    An observation will contain several values, each associated with a different 
# variable. I'll sometimes refer to an observation as a data point.
# 4. __Tabular data__ is a set of values, each associated with a variable and 
#    an observation. Tabular data is _tidy_ if each value is placed in its own
#    "cell", each variable in its own column, and each observation in its own row. 

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
### The official book on ggplot2: http://ggplot2.org/book/
### Another very good book: http://socviz.co/
### download the cheatsheet for ggplot
###----------------------------------------------------


###------------
### Discussion 
###------------

### We will use a small data file that comes with ggplot2
### mpg: Fuel economyh data from 1999 and 2008 for 38 popular models of car
### Make a habit of looking at the data
### You can download the latest version of this data: http://www.fueleconomy.gov/feg/download.shtml 


# look at the data we will use to learn ggplot
View(mpg)
str(mpg)
?mpg

### Ask these questions when you are looking at the data
### 1. How many observations?
### 2. How many variables?
### 3. How many categorical variables?
### 4. How many continous/numeric variables?
### 5. Which variables can be outcome variables?
### 6. Which variables can be input variabeles?


# Here is your first graph
ggplot(data = mpg) + #always add the plus sign at the end of the line, not at the front
  geom_point(mapping = aes(x = displ, y = hwy))

### How can we describe the graph?

# alternative
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + #always add the plus sign at the end of the line, not at the front
  geom_point()

###------------
### Discussion 
###------------

### What are the differences between two ways that produce the same graph?

### Why hwy is plotted on y-axis and displ on x-axis?
### In general, how do you decide which variable should be on which axis?

### Output : dependent variable : y-axis
### Input : independent variable : x-axis

##-----------
## color
##-----------

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

# alternative
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = class)) + 
  geom_point(mapping = aes(color = class))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

# alternative
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(color = "blue")


###------------
### Discussion 
###------------

###--------------------------------------------
### general notes about what have learn so far
###--------------------------------------------
###                                                aesthetic variable to
###                                                 property  map it to
###                                                    |        |   
### ggplot(mpg) + geom_point(aes(x = displ, y = hwy, color = class))
### ggplot(mpg) + geom_point(aes(x = displ, y = hwy, size = class))
### ggplot(mpg) + geom_point(aes(x = displ, y = hwy, shape = class))
### ggplot(mpg) + geom_point(aes(x = displ, y = hwy, alpha = class))

#--------------- 
# set vs. map
#---------------
ggplot(mpg) + geom_point(aes(x = displ, y = hwy, color = "green"))
# note: Inside of aes(): ggplot2 treats input as value in the data
#       space and maps it to a value in the visual space.
ggplot(mpg) + geom_point(aes(x = displ, y = hwy), color = "green")
# note: Outside of aes(): ggplot2 treats input as value in
#       the visual space and sets the property to it.

#-----------
# facets
#-----------
 
#
# facet_grid() - 2D grid, rows ~ cols, . for no split
# facet_wrap() - 1D ribbon wrapped into 2D
#
 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)


##-------
## geom
##------

###------------
### Discussion 
###------------

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

### How can we describe the graph? 
### Anything strange about this graph?

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

### How can we describe the graph? 
### Anything strange about this graph?

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

### How can we describe the graph? 
### Anything strange about this graph?

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()

### How can we describe the graph? 
### Anything strange about this graph?

###------------
### Discussion 
###------------

###-------------------------------- 
### note about global and local
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

##-----------------------
## something fun
##-----------------------

# execute this and what do you see?
ggplot(data = mpg,
       mapping = aes(x = cty, y = hwy, color = drv)) +
  geom_density_2d(color = "white") +
  geom_point()

##--------------------------------------------
## adding a few more options for geom_smooth
##--------------------------------------------

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(method = "gam", formula = y ~ s(x))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(method = "lm")

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(method = "lm") +
  geom_smooth(method = "gam", formula = y ~ s(x))

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

##-------------------------------------
## Graphical display of distributions 
##-------------------------------------

# Your data analysis often begins with examining the distribution of your variables

# Variation

# Variation is the tendency of the values of a variable to change from 
# measurement to measurement. Every variable has its own pattern of variation, 
# which can reveal interesting information. 

# The best way to understand that pattern is to visualise the distribution of 
# the variable's values.

##-----------------------------
## Categorical vs. Continuous 
##-----------------------------

# How you visualise the distribution of a variable will depend on whether the variable
# is categorical or continuous. 

# A variable is categorical if it can only take one of a small set of values. 
# In R, categorical variables are usually saved as factors or character vectors. 
# To examine the distribution of a categorical variable, use a bar chart:

##--------------------------------------
## Bar graphs for categorical variables
##--------------------------------------

# looking at the distribution of a categorical variable
# we will use geom_bar to crate a bar graph
ggplot(data = mpg) + 
  geom_bar(mapping = aes(x = class))

# alternative 
ggplot(data = mpg) + 
  stat_count(mapping = aes(x = class))

# you can enter the data and create a bar graph
# this workflow is the same as what you will do in Excel
demo <- tribble(
  ~a,      ~b,
  "bar_1", 20,
  "bar_2", 30,
  "bar_3", 40
)

ggplot(data = demo) +
  geom_bar(mapping = aes(x = a, y = b), stat = "identity")

ggplot(data = mpg) + 
  geom_bar(mapping = aes(x = class))

# can you create a bar graph that show % of SUVs in the mpg data?
ggplot(data = mpg) + 
  geom_bar(mapping = aes(x = class, y = ..prop.., group = 1))
# note the option __group = 1__

###------------
### Discussion 
###------------

### you can compute statistics inside ggplot, but it is not a good idea


##--------------------------------------
## Density plots for numeric variables
##--------------------------------------

# histograms
ggplot(data = mpg) +
  geom_histogram(mapping = aes(x = hwy), binwidth = 0.5)

ggplot(data = mpg) +
  geom_histogram(mapping = aes(x = hwy), binwidth = 1.0)

# Note how the graph changes with __binwidth__

ggplot(data = mpg) +
  geom_histogram(mapping = aes(x = hwy), binwidth = 2.0)

# density plots
ggplot(mpg) +
  geom_density(mapping = aes(hwy))

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
#    c. Visualize the covariation of two numeric variables.

