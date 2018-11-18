# Basic R commands and usage
# 2018 January 30
# Adrian Wiegman 

#Useful hotkey commands 
#ctrl + shift + c puts # in first space of selected lines
#ctrl + enter # ctrl enter
#ctrl + shift + enter # runs the entire file

#History shows recent console commants
#Environment shows things contained in memory
library(ggplot2)
#using the assignment operator
x<-5 #preferred
print(x)
y = 4 #legal but not used except in functions
y = y + 1.1 #
plantHeight <- 5.5
#____________________(end Jan 30 class)

#the combine function c()
z <- c(3,3,3,10) # simple atomic vector, vars are read in as double or real
print(z)
typeof(z) #returns variable type or mode
str(z) #get structure of variable 
is.numeric(z) # logical test for var type
is.character(z) #same test for caracter
# c() always flattens to an atomic vector
z<- c(c(3,5),c(5,6)) 
print(z)
#character strings with single or double quotes 
z<- c('perch','bass','trout','pike')
print(z)
#use both quote times for an internal quote
z<-c("this is only 'one' character string",'a second "string"')

#logical TRUE FALSE 
z <- c(TRUE,TRUE,FALSE) #SPELL OUT IN FULL ALL CAPS
is.logical(z)

#Three properties of all atomic vectors
# 1. 'type' of atomic vector: string, numeric, factor, logical
typeof(z)
is.numeric(z)
# 2. 'length' of the vector
length(z) #useful for defining loops
# 3. 'name' of vector elements (optional)
z <-runif(5) #random uniform variable defautl range b/w 0-1
names(z) <- c('chow','pug','beagle','shepard','poodle')
print(z)
#add names when variable is build
z2 <- c(gold=3.3, silver=10, lead=2) #this is equivalend to the operation above
print(z2)
names (z2) <- NULL #command strips out the names  
names(z2)<-c("copper","zinc")

#special data values
#----NA
z <- c(3.2,3.3,NA) # NA is the assignment for missing values
length(z) #doesnt change length
typeof(z[3]) #z[n] accesses the nth element in vector z
mean(z) #WATCH OUT FOR NA it will fuck your code
is.na(z) #Find NA using this function
!is.na(z) # ! is the NOT operator
mean(!is.na(z)) #WRONG gives the mean of the TRUE = 1 and FALSE = 0 designation
mean(z[!is.na(z)])
#-----#NaN,Inf,-Inf
#bad results from numeric calculations
#not a numnber, infinity, neg infinity
z<-0/0
print(z)
z<--1/0
print(z)
typeof(z)
#-------NULL
#an object that is nothing
z <-NULL
typeof(z)
length(z)
is.null(z) 
# useful for clearing values of parameters and checking empty assingments

#Three properties of atomic vectors
#Coercion
a <- c(2.1,2.2)
typeof(a)
b <- c("butt","armpit")
typeof(b) 
d <- c(a,b) # one reason we want meaningful variable names
typeof(d) #all elements of atomic vector are 'coerced' into one type
#hierarchy of coersion
#logical->integers->double->character
#everything can be converted into character

a <-runif(10)
print(a)
a > 0.5 #logical operation 
temp <- a > 0.5
print(b)
sum(temp) #sum is looking for numeric so logical values are coerced into integers TRUE = 1 FALSE=0
#what proportion of the values are > 0.5
mean(a > 0.5)
#is the same as
mean(temp)
#is the same as
sum(temp)/length(a)

#qualifying exame question:
#aproximately what proportion of observations from a normal (0,1) random variable are > 2.0
mean(rnorm(1000)>2) # 0.01-0.03 results are variable because the sample size is small
mean(rnorm(1000000)>2) # 0.02268

#---- Vectorization
z <- c(10,20,30)
z + 1 #adds one to all elements in vector z)
y <- c(1,2,3) #adds elements of y and z that have the same position or element-by-element matching
z+y
short <- c(1,2)
z + short # if vectors are not the same lenght elements of the shorter vector are recycled. If not an even multiple a warning is displayed.
#we are allow to operate on the element as a whole
z^2 #squares the elements 

#creating vectors
#create an empty vector

z <- vector(mode="numeric",length=0)
print(z)

z <- c(z,5) #DONT DO THIS, it must be stored in memory and slows the code
print(z)

z <- rep(0,100) #fills the vector with 100 zeros, NOT RECOMMENDED
z[1] <- 3.3
head(z)

z <- rep(NA,100) #fills with 100 NAs 
typeof(z)
#if no type is specified it will go to top of hierarchy, logical->integer->double
z[c(1,2)] <- c('washington',2.2)
typeof(z)
z[c(1,10)] #references elements 1 and 10 in vector z
z[c(1:10)] #references elements 1 through 10


#!!!!!!!!!!!!!!!!SUPER USEFUL CODE FOR FILE NAMING
#!!!!!!!!!!!!!!!!
#generate a long list of names
myVector <- runif(100) # get 100 random uniform values
myNames <- paste("File",seq(1:length(myVector)),".txt",sep="")
#paste() puts together a list of strings
#seq() repeats

names(myVector) <- myNames
head(myVector)

#_________________(end Feb 1 class)

#
#using "rep" to repeat elements and create vectors
# use the "Help" in the lower right pane to search functions
rep(0.5,6) #repeats element x 0.5, 6 times)
rep(x=0.5,times=6)
rep(times=6,x=0.5) #works forward and backward if elements are named properly
myVec <- c(1,2,3)
rep(myVec,times=2) # repeats entire vector twice
rep(x=myVec,each=2) #repeats each element in the vector twice 
rep(x=myVec,times=myVec) #matches up nth element in vectors and repeats that many times
rep(x=1:3,times=3:1)

#"seq" for creating sequences
seq(from=2,to=4) #analogous to do loops
seq(from=3,to=30,by=6)
seq(1,100,10)
seq(from=1,to=100,length=20) #length divides into equal intervals that total to the specified lenght, 99/20 = interval

x <- seq(from=2,to=4,lenght=7)
1:length(x) #lists the element number, slow because : is a function
seq_along(x) #faster
n = 100
seq_len(n) #creats a vector of length n listing the element number from 1 to n
str(x)
x<- NULL
1:length(x) #this goes from 1 to 0
seq_along(x) #this gives you 0

#using random numbers
runif(1) #randum uniform number ranging between zero and 1 
set.seed(100) # sets the random number sequence 
runif(1) #this value will now be the same if 
set.seed(100) # sets the random number sequence 
runif(n=5,min=100,max=200) #a vector lenth = 5, between 100 and 200
#set.seed must be run on the line before the random number command to have same number
set.seed(100) 
z <- runif(n=1000,min=30,max=300)
qplot(x=z)

#random normal values
z <-rnorm(1000)
z <-rnorm(n=100000, mean=50, sd=20)
qplot(x=z)

#use "sample" to pull values from an existing vector
longVec <- seq_len(10)
sample(x=longVec) #shuffles the values in a vector, gives random order
sample(x=longVec,size=3) #samples without replacement
sample(x=longVec,size=3,replace=TRUE) #random sample with replacement
myWeights <- c(rep(20,5),rep(100,5))  #must be same lenght as vector being sampled and values must be positive
sample(x=longVec,replace=TRUE,prob=myWeights)

#subsettting of atomic vectors
z <- c(3.1,9.2,5.3,1.4,0.5)
#four ways to subset
#subest on positive index values
z[5] #returns the nth element of z
z[c(1,3)] # returns the 1st and 3rd element of z

#subset on negative index values (subtracting elements)
z[-c(2,4)] # returns all elements except for 2 and 4

#subet by creating a boolean vector to select elements that meet a condition
z<4 # returns a vector of TRUE FALSE values
z[z<4] # returns the values of z that are less than 4
which(x=z<4) # returns the element index number of z that are less than 4
myCriteria <- z<4
z[myCriteria]
z[which(z<4)]
zx <- c(NA,z)
zx[zx<4] # retains the missing values, useful for working with data frames
zx[which(zx<4)] # removes the missing values, useful for simple functions

#keep enitre vector
z[] #useful for working with matrices

z[-(length(z):(length(z)-2))] #this type of codeing is good for general use with variable length vectors

#subset on names of vector elements
names(z) <-letters[(seq_along(z))]
z
z[c('a','b','e')] #we can only make positive selections

# arithmetich operators
10 + 3
10 - 3
10 * 3
10 / 3
10 ^ 3
log(10) # log base e or LN
log10(10) #log base 10 

#remainder, modules operator 
10 %% 3

#integer division
10 %/% 3

#generate the set of all numbers that are divisible by nine
q <- seq_len(100)
q[q%%9==0]

#__________________ (end of Feb 6 Lecture)

#boolean or logical operators
#aka relational operators
3>4
3>=4
3==4
3==4:8 #vector form

#set operators compare two atomic vectors and return one atomic vector always stip out duplicate elements
i <- c(1,1:7)
print(i)
j <- 3:10
print(j)
#union is all of the elements
union(i,j)  #removing duplicates
intersect(i,j) #common elements
setdiff(i,j) #unique elements of i not in j, an asymetric function, order of variables matters
setdiff(j,i) #setdiff returns the elements in i are not in j 

#set operators that return  a single boolean
setequal(i,j) #i and j identical, TRUE of FALSE
setequal(i,i)
is.element(i,j) #says if the elements in i are contained in j, order matters

#logical operators
z <- 10:20
z < 15
z < 20 & z > 17 # AND operator
z < 20 | z > 17 # OR operator

#remenber atomic vectors all are the same type

