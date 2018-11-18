# Randomization test for regression data
# 20180403
# NJG
#preliminary set up 
library(ggplot2)
library(TeachingDemos)
char2seed("Cruel April")

# parametric analysis
# - errors normally distributed
# - variance is constant
# - data points independent
# - p value - probability that the null hypothesis is true given the data
# - p(data|Ho)
# - p values are not very intuitive
# - and assumptions of normality and constant variance are burdensome 
# randomization test
# 1. define a metric X 
# - describes a pattern in the data
# - single number
# 2. Calculate X_obs - metric X for the observed data
# 3. Randomize or reshuffle existing data to generate null distribution
# - destroy the covariance between x and y while maintaining the variance of each
# 4. Calculate X_sim metric for the simulated data set
# 5. repeat steps 3 and 4 many times (n = 1000) 
# 6. plot distribution of X_sim against X_obs
# 7. caclulate the proportion of X_sim values that are greater than X_obs

##############################################################
# FUNCTION: readData
# read in or generate data frame
# input: file name (or nothing for demo)
# output: 3-column data frame of ovservaed data (ID,xVar,yVar)
#------------------------------------------------------------
readData <- function(z=NULL) {
  if(is.null(z)) {
    xVar <- 1:20
    yVar <- xVar + 10*rnorm(20)
    df <- data.frame(ID=seq_along(xVar),xVar,yVar)
    return(df)
  }
  #insert read function here
}
readData()
###########################################################
# FUNCTION: getMetric
# calculates a metric on a vector for randomization test
# input: 3-colunm data frame for regression (ID, xVar, yVar)
# output: regresion slope
#----------------------------------------------------------
getMetric <- function(z=NULL){
  if(is.null(z)){
    xVar <- 1:20
    yVar <- xVar + 10*rnorm(20)
    z <- data.frame(ID=seq_along(xVar),xVar,yVar)
  }
  . <- lm(z[,3]~z[,2])
  . <- summary(.)
  . <- .$coefficients[2,1]
  slope <- . 
  return(slope)
}
getMetric()

###########################################################
# FUNCTION: shuffleData
# randomize the position of y values in dataframe
# input: 3-colunm data frame for regression (ID, xVar, yVar)
# output: 3-column data frame 
#----------------------------------------------------------
shuffleData <- function(z=NULL){
  if(is.null(z)){
    xVar <- 1:20
    yVar <- xVar + 10*rnorm(20)
    z <- data.frame(ID=seq_along(xVar),xVar,yVar)
  }
  z[,3] <- sample(z[,3])
  return(z)
}
shuffleData()

###########################################################
# FUNCTION: getPVal
# calculate p value for observed, simulated data
# input: list containing observed metric and vector of simulated data
# output: lower, upper tail probability
#----------------------------------------------------------
getPVal <- function(z=NULL){
  if(is.null(z)){
    z <- list(xObs=runif(1),xSim=runif(1000))
  } #end if
  pLower <- mean(z[[2]]<=z[[1]]) #the mean of a boolean vector returns proportion true
  pUpper <- mean(z[[2]]>=z[[1]])
  return(c(pL=pLower,pU=pUpper))
}
getPVal()

###########################################################
# FUNCTION: plotRanTest
# ggplot graph 
# input: list containing observed metric and vector of simulated metrix 
# output: ggplot graph
#----------------------------------------------------------
plotRanTest<- function(z=NULL){
  if(is.null(z)){
    z <- list(xObs=runif(1),xSim=runif(1000))
  } #end if
  df <- data.frame(ID=seq_along(z[[2]]),simX=z[[2]])
  p1 <- ggplot(data=df,mapping=aes(x=simX))
  p1 + geom_histogram(mapping=aes(fill=I("goldenrod"),color=I("black"))) + geom_vline(aes(xintercept=z[[1]],col="blue"))
}
plotRanTest()


#MAIN PROGRAM************************************************

#global variables
nSim <- 1000
Xsim <- rep(NA,nSim) # will hold simulated slopes

df <- readData()

Xobs <- getMetric(df)

for (i in seq_len(nSim)){
  Xsim[i] <- getMetric(shuffleData(df))
}

slopes <- list(Xobs,Xsim)

getPVal(slopes)
plotRanTest(slopes)





  
  







