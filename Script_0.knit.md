---
title: "Script_0"
output: html_document
---
 
# Introduction to R 

In this script we will learn the basics of working with R in RStudio. 
 
##  Working Directory

Your working directory is a location on your computer where R will look for your data files. You will need to tell R what your working directory is everytime you open RStudio, otherwise R will just guess. 

Let's see what R has currently set as your working directory



```r
getwd()
```

```
## [1] "C:/Users/user/Dropbox/R_project/Data-Science-for-Policy-Analysis"
```

Check out the pathway that prints out in your console. This pathway is UNIQUE to your computer. Notice that R uses forward slash.

It is a best practice to create a folder for your R data and tell R to use that folder every time you open R using setwd()

Here's the pathway that I would like to use to set my working directory:    
setwd("C:/Users/Samantha/Desktop/R Files")

I have chosen to use a file on my desktop called "R Files" to keep my data. Can you edit my setwd() code to set your own working directory? 
Try it!


## Types of data in R

The most common type of data you will work with is something called a dataframe. This is very similar to an Excel spreadsheet in appearance.

There are two ways to create a dataframe in R, you can either
write one yourself or read in a pre-made data file. Most of the time
we will read in an external file. This tutorial will show you how to do
both. 

A. Creating a dataframe 
Let's make one so you can see.

df is the name of the dataframe


```r
df <- data.frame(
  name = c("John", "Paul", "George", "Ringo"),
  birth = c(1940, 1942, 1943, 1940), 
  instrument = c("guitar", "bass", "guitar", "drums")
)
```


You can see what is in your dataframe with View()


```r
View(df)
```


 Notice that we created 3 columns: name, birth, and instrument,
 then populated those columns with information inside the function
 c()


------------------------
 Your turn! 
------------------------

 Make your own dataframe that contains information on the band
 Aerosmith from the following data on instrument, birth year,
 and marital status for each member:

Steven Tyler: lead vocals, born 1948, single
Joe Perry: guitar, born 1950, married
Tom Hamilton:  bass, 1951, married
Joey Kramer: drums, 1950, married
Brad Whitford: guitar, born 1952, married


```r
aerosmith <- data.frame(
  name = c("Steven Tyler", "Joe Perry", "Tom Hamilton", "Joey Kramer", "Brad Whitford"),
  birth = c(1948, 1950, 1951, 1950, 1952), 
  instrument = c("vocals", "guitar", "bass", "drums", "guitar"),
  status = c("single", "married", "married", "married", "married")
)
View(aerosmith)
```




 B. Reading in a data file 
 The function for reading in a data file will differ depending on 
 they type of file you are reading. In this example, we will use
 a csv

 Here we are reading in the csv file, Philly_schools.csv



















































