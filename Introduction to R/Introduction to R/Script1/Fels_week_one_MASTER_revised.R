# R is a tool to help you understand data. Some people get scared of
# programming because it looks complicated, but always remember that
# R is just a tool that you are in command of. It will take time to 
# become familiar with this tool, but the more you work at it, the 
# better you will become. The key to becoming good at R is persistence.
# Don't get discouraged because you don't understand it right away. 
# For many of you this is your first experience with programming. 
# It will take time. If you are feeling frustrated don't be afraid
# to walk away for a while, and please ask for help when you need it.
# There is a learning curve to programming so this class will be much
# smoother if you ensure that you have a strong understanding of the 
# basics.

# There are two things necessary to becoming good at R:
#     Persistence
#     Google
# If you can't get something to work, try Googling your question for 
# an answer. Rest assured, if you have a problem, someone else had 
# the same problem too. You will likely find it difficult to properly
# Google your question as you will lack important vocabulary and 
# understanding at the beginning of your journey. Keep trying. 
# Even time you try somethinng, even if it doesn't work, you are
# becoming better at R.

# Some of the things you will learn today may seem useless, but they
# will become important later in R so pay attention. If you have any
# questions please ask for help.

# Class Objectives:
  # In this class you will learn how to
  # 1. Load R and R studio
  # 2. Set a working directory
  # 3. Do basic math in R
  # 4. Create objects and assign values to these objects
  # 5. Organize your data through commands such as sort() and order()
  # 6. Find a specific row or column in your data
  # 7. Use IF commands
  # 8. Sample your data
  # 9. Install packages
  # 10. Read data from csv



# If you are confused about a function type ?function_name into the 
# command line and it will bring up a help menu. For example,
?mean
?round
?which.max


getwd()
setwd("C:/Users/nellim/Dropbox/Fels") # place your working directory into the
# folder which has your data. I work with data that I put on the 
# desktop so my directory is my desktop. note that R uses forward 
# slash / on all platforms

# To do basic math in R, all you need to do is type the equation in the
# command line Basic math
2 + 2
1 * 2 * 3
(1 + 2 + 3 - 4)/(5 * 7)

# Basic functions
sqrt(2) # This square roots the number
2^3     # This raises the first power to the second power. This is 2 cubed
round(2.718281828,3) # This rounds the first number to the second 
# number places. Try it with a different 
# second number.

# combine things together with c()
# This lets you do an immense amount of functions to a large set
# of data at the same time. 
c(1, 2, 3, 4, 5)
c(1, 2, 3, 4, 5)+1 # You can do math to combined items
c(1, 2, 3, 4, 5)*2
c("GAFL640","GAFL641","GAFL621") # You can also combined words

# This makes a range of numbers from the first number to the second
# number. So this code will count from 1 to 10. It will be used
# in what are called forloop, which essentially it a way to
# repeat a command many times. 
1:10

# You can do math on ranges of numbers. It will add (or any other
# desired math function) the numbers as long as they match the
# order of each other. The first number in the first range will
# add to the first number in the second range. The eighth 
# number in the first range will add to the eighth number
# in the second range. 
1:10 + 2:11
1:10 * 2:11

# You can also do math on combinations of numbers. It will perform
# the function on each individual number.
sqrt(c(1, 10, 3, 6, 2, 5, 8, 4, 7, 9))
(c(1, 10, 3, 6, 2, 5, 8, 4, 7, 9))^2
abs(c(-1, 1, -2, 2, -3, 3))

# This finds the sum of all numbers in the list
sum(c(1, 10, 3, 6, 2, 5, 8, 4, 7, 9))
# This finds how long the entire combined set is. This will be
# useful when you want to quickly count how many datapoints
# are in a set of data.
length(c(1, 10, 3, 6, 2, 5, 8, 4, 7, 9))

# Staticial measures can be taken on lists of numbers. 
mean(c(1, 10, 3, 6, 2, 5, 8, 4, 7, 9)) # This gives the mean number of 
# the list
median(c(1, 10, 3, 6, 2, 5, 8, 4, 7, 9)) # This gives the median number
sd(c(1, 10, 3, 6, 2, 5, 8, 4, 7, 9)) # This gives the standard 
# deviation

# biggest and smallest
max(c(1, 10, 3, 6, 2, 5, 8, 4, 7, 9))
which.max(c(1, 10, 3, 6, 2, 5, 8, 4, 7, 9))
min(c(1, 10, 3, 6, 2, 5, 8, 4, 7, 9))
which.min(c(1, 10, 3, 6, 2, 5, 8, 4, 7, 9))

# sorting
sort(c(1, 10, 3, 6, 2, 5, 8, 4, 7, 9)) # This sorts in increasing order
sort(c(1, 10, 3, 6, 2, 5, 8, 4, 7, 9),decreasing = TRUE) # decreasing = TRUE 
# sorts in decreasing
# order
# where is the ith biggest number?
# order() is the same as sort except it gives you the place number
# for the results. You see it gives 1 first, that corresponds to the
# 1 that starts our list. It gives 5 second, that corresponds to the
# number 2 in the 5th place in the list. You will learn an easier
# way to go to that place in the list later in this lesson. 
order(c(1, 10, 3, 6, 2, 5, 8, 4, 7, 9))

#  functions work on character strings
my.states <- c("WA","DC","CA","PA","MD","VA","OH")
# Paste lets you add words to words on the list. The following will
# add ", USA" to the end of every word in our list
paste(my.states,", USA")
# This becomes a very powerful tool when we start mapping data.
# It lets you easily add geographic information, such as city and 
# zipcode to data that may otherwise be missing it. 


# Class exercises
# 1. Print all even numbers less than 100

# There are a few ways to solve this. Here are some ways
1:49 * 2
1.5:50 * 2 - 1
seq(2, 99, by=2) # seq allows you to set how many number you count by. Since it is set to count
                 # by 2 it skips a number each time.

# 2. Have R put my.states in alphabetical order
c("WA","DC","CA","PA","MD","VA","OH")

sort(c("WA","DC","CA","PA","MD","VA","OH"))  # This sorts the list alphabetically
order(c("WA","DC","CA","PA","MD","VA","OH")) # This also sorts the list alphabetically but
                                             # gives the number corresponding to the order
                                             # in the list. It gives 3 first because CA is the
                                             # third in the list and is first alphabetically

# Use <- to assign a value to an object. Using the equals sign also 
# works but is bad form in R to use. When you assign a value to an
# object you say that the object "gets" that value In the next line 
# a "gets" 1. This means that when you call "a" in R you will get 
# the value 1 You can use this to save time and avoid having to 
# rewrite the value, or many values. You can assign various values 
# to object, such as lists, dataframes, or basic numbers. 
a <- 1
b <- 2 + 2
# If the object has numbers inside it, you can do math to it as you
# would to a list of numbers
a <- a + b
a <- 1:10
b <- 2 * a
a + b
sd(a)

# If making objects does not make sense, think of it like building a 
# recipe. Your object gets your ingredients. If you are making 
# scrambled eggs you add eggs, milk, salt, and pepper together. The
# R version of this is to say scrambled eggs gets eggs, milk, salt,
# and pepperscrambled_eggs <- c("eggs", "milk", "salt", "pepper")


# Class exercise
# 1. Bake a cake in R. The main ingredients in most cakes are eggs, sugar, flour, salt,
#    vanilla, baking powder

cake <- c("eggs", "sugar", "flour", "salt", "vanilla", "baking powder")

# Indexing
# This will call the item in the bracket from the object. In the next 
# example it calls the 1st item from the object called "state_names"
state_names <- c("WA","DC","CA","PA","MD","VA","OH")
state_names[1] # This says the first value
state_names[1:3] # This says values 1 to 3 
state_names[c(1,5,9)] # This says values 1, 5, 9

# negative indices call up everything except what has a - before it. 
# This calls up all states except for 7. 
state_names[-7]

# This first sorts the list, then grabs the first item in the sorted
# list
sort(state_names)[1]

# This makes an object of the ordered state names and puts it in the
# object called i
i <- order(state_names)
i[1:3] # First 3 locations of the ordered state names object
state_names[i[1:3]] # You can tie all these together and grab
# the first 3 states in the alphabetical list



#Class exercises
# 1. What is the last state in the list?

state_names[7]
state_names[-(1:6)]


# 2. Pick out states that begin with "M" using their indices

  sort(state_names)[3] # Must sort alphabetically first then select desires ones
  state_names[grep("^M", state_names)] # This uses grep to find it. This is more advanced than
                                       # The first lesson material.

# 4. What's the last state in alphabetical order?

sort(state_names)[7]
sort(state_names)[-(1:6)]

# 5. What are the last three states in alphabetical order?

sort(state_names)[5:7]
sort(state_names)[-(1:4)]

# Boolean means TRUE or FALSE answers. Binary possibility. 
# This is more powerful than it may seem at first. You will be 
# using boolean values extensively when you begin cleaning up
# and subsetting (dividing big pieces of data into smaller pieces)
# in future lessons. What you will do in those lessons is ask
# R to match data. If there is a match, it says TRUE and does 
# something, if there is no match it says FALSE and does something
# else. 
# It may looks like these do nothing, but they become important soon.
TRUE
FALSE
c(TRUE,FALSE,TRUE,FALSE)

# Boolean values are a little tricky in that if you ask for more than
# one condition with an "and" command, all of them must be true for it
# to say TRUE. If even one is false, it says FALSE. Try it out yourself. 
TRUE  && TRUE 
FALSE && TRUE
FALSE || TRUE # Those straight bars mean "or"
FALSE || FALSE

6 > 5 # This asks R to perform a logic test. Is 6 bigger than 5?
# Because 6 is bigger, it returns true. What happens if you
# ask if 5 is bigger than 6?
(6 > 5) || (100 < 3) # This asks is 6 bigger than 5 or 100 is less than 3
# Because one of those is true (remember this is an
# or condition, not an and condition) it returns true
(6> 5) && (100 < 3) # Now that it says "and", and 100 is less than 3,
# it returns FALSE

a <- 1:10
a == 5
a != 5  # != means "not equal to"
a < 5
a >= 5 # >= means greater than or equal to

a>5 & a<8  # & means "and"   IMPORTANT use single & or | for vectors
a<3 | a>=7 # | means "or"    otherwise just compares the first values

#  %in% tests whether something is in a set
a %in% c(3,7,10)

my_states <- c("MD","OH","VA","CA","WA","DC")
i <- state_names %in% my_states
i

# Classroom exercises
# 1. Report TRUE or FALSE for each state depending on if you have lived there

my_states <- c("CA", "PA")
state_names %in% my_states

# Conditionals
# use if(){} to test conditions. Put your condition in between the ()
# and you response to the condition in between the {}
# This is where we use boolean values in a real sense. This if command
# says look at this, if it matches then do something. In this case it 
# says if the first state is WV, print "The Mountain State." Basically,
# it the comparison (state_names[1] matching "WV") returns TRUE, then
# do the print command
if(state_names[1] == "WV")
{
  print("The Mountain State")
}


# What happens if it does not match? As this code is written, nothing 
# happens. 
if(state_names[2] == "WV")
{
  print("The Mountain State")
}

# Nothing happened becuase you said if the if statement is true do
# something. You never said what if the if statement is not true.
# Use the "else" command to specific what if it returns a FALSE
if(state_names[1] == "WV")
{
  print("The Mountain State")
} else {
  print("Not the Mountain State")
}


# sample() randomly shuffles numbers
# Sampling may seem unimportant but it will be extremely useful it the
# statistical lessons we will use later in class. 
sample(1:10)
sample(1:10)
sample(1:10)
a <- sample(1:1000,size=10)
a
a <- sample(1:6,size=1000,replace=TRUE)
a

# table tabulates the values
# This will also be extremely important later in this class. It is an
# easy way to look at lots of data together. This next line simply 
# says how many of the 1000 samples landed in each number (we said
# that it could only be numbers from 1 to 6). If you are looking at 
# real world data, say a list of reasons people call 311 for assistance
# , you could use table to see how many people called for each reason. 
table(a)
max(table(a)) # Says the maximum value
order(table(a))

# Classroom exercise
# 1. Use sample() to estimate the probability of rolling a 6

a <- sample(1:6,size=100000,replace=TRUE)
table(a) / 100000 


# The command read.csv allows you to read a .csv file into R and you 
# can place the data into an object. 
teacher <- read.csv("philly_teacher.csv")
View(teacher)

# In this lesson your learned how to:
  # 1. Load R and R studio
  # 2. Set a working directory
  # 3. Do basic math in R
  # 4. Create objects and assign values to these objects
  # 5. Organize your data through commands such as sort() and order()
  # 6. Find a specific row or column in your data
  # 7. Use IF commands
  # 8. Sample your data
  # 9. Install packages
  # 10. Read data from csv