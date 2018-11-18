# Using Probability Simulation in R
# February 15 2018
# Adrian Wiegman
# stochastic vs deterministic models

# install/load necessary packages
library(ggplot2)

#generate random uniform data
testData <- runif(1000)
qplot(x=testData)

#creating a function in R to make custom graphs
#functions must go at the top of programs so that 
#they can be compiled into the memory 
#///FUNCTIONS-----------------------

#_Function Histo
# better histogram plot
# input xData = numeric vector
# input fColor = fill color
# output = corrected ggplot histogram
# output = summary statistics 
# output = 95% interval
Histo <- function(xData=runif(1000),fColor='salmon') {z <-qplot(x=xData,color=I('black'),fill=I(fColor),xlab='X',boundary=0) 
print(z)
print(summary(xData))
print(quantile(x=xData,probs=c(0.025,0.975)))
}
#function(){} is an R function for building functions
#qplot() is a ggplot function
#I() is a variable for passing arguments?????

#Function IHisto
#works better than histo for integer values!
#input xData = vector of integers
#input fColor = fill color
#output = summary of x data 
#output = 95% confidence interval
iHisto <- function(xData=runif(1000),fColor='salmon') {
  z <-qplot(x=factor(xData),color=I('black'),fill=I(fColor),xlab='X',boundary=0) 
print(z)
print(summary(xData))
print(quantile(x=xData,probs=c(0.025,0.975)))
}


#///MAIN PROGRAM-------------------------


Histo()
temp <- rnorm(1000)
Histo(xData=temp,fColor='yellow1')
iHisto()

#DISCRETE PROBABILITY DISTRIBUTION
#Poisson distribution
temp2 <- rpois(n=1000,lambda=0.5) #poisson distribution, lamba represents the average rate of events per sampling interval
#poisson gets more course as lambda approaches zero
iHisto(temp2)
iHisto(xData=temp2, fColor='springgreen')
mean(temp2==0) # mean of a string of TRUE FALS that were coerced to integer

# Binomial distribution
# integer from 0 to number of trials
# input parameters...
# n= number of trials
# size= number of replications per trial
# p= probaility of success
zz <- rbinom(n=1000,size=40,p=0.75)
iHisto(xData=zz,fColor='slateblue')

#poisson constant rate process
z <- rpois(n=1000,lambda=1)
iHisto(z)
mean(z==0)

#the negative binomial distribution fits environmental data nicely
#range from 0 to infinity
#n = number of replicates
#size is number of trials per replicate
# prob = probability of success with 1 trial
z < rnbinom(n=1000, size=2, prob=0.5)
iHisto(z)
#number of failures until we get to a certain number of successes
# imaging a string of coin toss results
# success = 2 H
# HH = 0 failure
# THH = 1 failure
# HTHH = 2 failures
# THTHH = 3 failures


#alternatively we can call mu 
#size = index of overdispersion
#small size leads to high dispersion
z <- rnbinom(n=1000, mu=1.1, size=0.7)
iHisto(z)

#special case where the number of trials = 1 and prob is low
z <- rnbinom(n=1000, size=1, prob=0.05)
iHisto(z)
#probability is high
z <- rnbinom(n=1000, size=1, prob=0.95)
iHisto(z)

#binomial distribution is a TRUE or FALS distribution

#----------------------------
#multinomial distribution (greater than two posibilities)
#"imagine balls in urns"
# size = number of balls 
# prob = is a vector who's length is equal to the number of urns, containing the probability of a ball landing in each urn
z <-rmultinom(n=1000, size=20,prob=c(0.2,0.7,0.1))
#don't print this out if larger than 10
rowSums(z)
rowMeans(z)

#creating a multinomial with sample
z <- sample(x=LETTERS[1:3], size=20, prob=c(0.2,0.7,0.1), replace=TRUE)
z
table(z) #


#CONTINOUS PROBABILITY DISTRIBUTIONS
#uniform distribution
z <- runif(n=1000, min=3, max=10.2)
Histo(z)

#normal distribution
z <- rnorm(n=1000, mean=2.2, sd=6)
Histo(z)
#problematic for simulation because it gives negative values which don't normally occur in real life (e.g. biomass)

#gamma distribution 
#distribution of waiting times for failure to occur
#can only generate positve values
#shape and scape parameters
# mean = shape*scale
# variance = shape*scale^2
z <- rgamma(n=1000, shape=1,scale=10) #exponential decay
Histo(z) 

z <- rgamma(n=1000, shape=10,scale=10) #moves towards bell with increase in shape
Histo(z)

z <- rgamma(n=1000, shape=0.1,scale=10) # power decay
Histo(z)

#beta distribution
#bounded between 0 and 1 
# change boundary by adding or multiplying final vector
# conjugate prior for a binomial distribution
# binomial begins with underlying probability
# generates a number of successes and failures
# p is ~ success/(success + failure)
# problem at small sample size
# parameters
# shape1 = number of successes + 1
# shape2 = number of failures + 1

#though experiment:
# start with no data
successes = 0
failures = 0
z <- rbeta(n=1000,shape1=(successes+1),shape2=(failures+1))
Histo(z)
# two coin tosses
successes = 1
failures = 1
z <- rbeta(n=1000,shape1=(successes+1),shape2=(failures+1))
Histo(z)

# 10 coin tosses
successes = 10
failures = 10
z <- rbeta(n=1000,shape1=(successes+1),shape2=(failures+1))
Histo(z)

# 100 coin tosses with a biassed coin
successes = 90
failures = 10
z <- rbeta(n=1000,shape1=(successes+1),shape2=(failures+1))
Histo(z)

# small values coin tosses with a biassed coin
z <- rbeta(n=1000,shape1=0.1,shape2=10)
Histo(z)

z <- rbeta(n=1000,shape1=0.1,shape2=0.1)
Histo(z)

#--------------------------------------------
# MAXIMUM LIKELIHOOD ESTIMATION IN R
x<-rnorm(1000,mean=92.5,sd=2.5)
Histo(x)
library(MASS)
#fit distribution function:
#fit to normal
zFit <- fitdistr(x,'normal')
str(zFit)
zFit$estimate # the dollar sign references a vector in a list
#now fit a gamma 
zFit <- fitdistr(x,'gamma')
zFit$estimate
zNew <- rgamma(n=1000, shape=1449, rate=15.7)
Histo(zNew)
#gamma distribution replicates normal quite nicely
summary(x)
z <- runif(n=1000,min=85,max=100)
Histo(z)
