##---------------------------------------------------------
## Script # 8
## Based on Chapter 15 and 28 of r4ds
## Learning objectives:
##   2. Learn more features of ggplot
##-----------------------------------------------------------

###-------------
### Discussion
###-------------

### Guidelines for good graphic:
### 1. Aim for high data density.
### 2. Use clear, meaningful labels.
### 3. Provide useful references.
### 4. Highlight interesting aspects of the data.
### 5. Consider using small multiples.
### 6. Make order meaningful.

### Here is a link with examples and explanations:
### https://bookdown.org/rdpeng/RProgDA/customizing-ggplot2-plots.html 

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



