#Illustrates control sturctures

#basic if statements
z <- signif(runif(1),digits=2)
print(z)
z>0.5
# if z is larger than 0.5 contatonate(z, "statement", newline)
# cat is good for printing outputs
if(z>0.5)cat(z,"is a bigger than average number","\n")

#else must be on the same line as the original statement or }
if (z>0.8)cat(z, "is a bigger than average number","\n") else 
  if (z<0.2) cat(z,"is a smaller than average number","\n") else 
  {cat(z,"is a number of typical size","\n")
    cat("z^2 =",z^2,"\n")}

# put block statements into functions before using with an if structure
# condition in if returns only a single true false value

# example of bad if statement
z<-1:10
if(z>7)print(z)
if(z<7)print(z)
# if statements dont work well with vectors

# if inside of subset
print(z[z<7])


#ifelse operates on vectors 
#ifelse(object,yes,no)

#insect clutch size poisson with lambda = 10.2
#parasitism probability = 0.35 with 0 eggs laid
tester <- runif(1000)
eggs <- ifelse(tester>0.35,rpois(n=1000,lambda=10.2),0)
head(eggs,10)
hist(eggs)

#A
#use to create vector of stats for plotting
pVals <- runif(1000)
z <- ifelse(pVals<=0.025,"lowerTail","nonSig")
#subset
#this type of subset requires vectors of same length
z[pVals>=0.975] <- "upperTail"
head(z,10)
table(z)

#A more readable way to subset on conditions
z1 <- rep("nonSig",length(pVals))
z1[pVals<=0.025] <- "lowerTail"
z1[pVals<=0.975] <- "upperTail"
table(z)

#THE SINGLE MOST IMPORTANT CONTROL STRUCTURE IN ALL PROGRAMING
# FOR LOOPS

# a common way to start a loop
# for(i in 1:length(myDat)){} # not great because if my dat is zero it will run from 1 to 0 


myDat <- signif(runif(10),digits=2)

# a much better way to start a loop
#ttis prevents loop from running if empty
for(i in seq_along(myDat)){ #alway indent after the bracket
  cat("loop number =",i,"vector element",myDat[i],"\n")
} # end for i in seq_along(myDat)
print(i)


# use a constat to define the length of the loop
zz<-5
myDat <-signif(runif(zz),digits=2)
for(i in seq_len(zz)){
  cat("loop number =",i,"vector element",myDat[i],"\n")
}

#these functions prevent for loop from failing object value is zero
#seq_len(constant) is equal to 1:constant
#seq_along(vector) is equal to 1:length(vector)

# use a constat to define the length of the loop
zz<-5
zz2<- 4:6
myDat <-signif(runif(zz),digits=2)
for(i in zz2){
  cat("loop number =",i,"vector element",myDat[i],"\n")
}

# THINGS NOT TO DO IN FOR LOOP
# don't do anything in the for loop...
# unless you have to
myDat <- vector(mode="numeric",length=10)
#any function that can be vectorized MUST BE REMOVED
for (i in seq_along(myDat)){
  myDat[i] <- signif(runif(1),digits=2)
  cat("loop number =",i,"vector element",myDat[i],"\n")
}
#the code above is make 10 separate calls to the runif and signif functions

#don't change the object dimensions in loop
myDat <- runif(1)
for (i in 2:10){
  temp <- signif(runif(1),digits=2)
  myDat <- c(myDat,temp) 
  cat("loop number =",i,"vector element",myDat[i],"\n")
}
# because the c() function is called each time the loop will be very slow

#DO NOT CHANGE THE LENGTH OF A VECTOR IN A LOOP 
# e.g. c(),list(),rbind(),cbind()
#THIS SLOWS THE PROGRAM DOWN 


#do not write a loop if you can vectorize
myDat <- 1:100 
slower <- function (myDat)
  for (i in seq_along(myDat)){
  myDat[i] <- myDat[i] + myDat[i]^2
  cat("loop number =",i,"vector element",myDat[i],"\n")
  }
slow <- system.time(slower(myDat))
#most languages require a for loop to do this

#since R works is designed to operate on vectors 
#these things can be done on an entire vector
faster <- function(myDat){
  myDat <- myDat + myDat^2
  print(myDat)
}
fast <- system.time(faster(myDat))
slow[3]/fast[3]
z<-c(10,2,4)
for(i in seq_along(z)){
  cat("i=",i,"z[i]=",z[i],"\n")
}

#counter variable retains its final value

#use next to skip elements in loop
#operate only on odd-numbered elements
z <- 1:20 
slower1 <- function (z){
  for (i in seq_along(z)){
  if(i %% 2==0) next  
  #this finds the remainder of i/2, 
  #if i/2 is zero skip to next i value
  cat("i=",i,"z[i]=",z[i],"\n")
  }
}
system.time(slower1(z))
#another way to skip elements
zodd <- z[z%%2!=0] #only odd numbers in z
faster2 <- function(z){
  for (i in seq_along(z)){
  #this finds the remainder of i/2, 
  #if i/2 is zero skip to next i value
  cat("i=",i,"z[i]=",z[i],"\n")
  }
}
system.time(faster2(zodd))

#fill a vector with zeros
zstore <- vector(mode='numeric',length=length(z))
#fill a vector with NA
zstore <- rep(NA,length(z))

            
