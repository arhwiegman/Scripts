# Plotting mathematical functions in R
# 20180403
# Adrian Wiegman

# create a simple random growth population model function
##################################################
# FUNCTION: RanWalk
# stochastic random walk 
# input: times = number of time steps
#        n1 = initial population size (= n[1])
#        lambda = finite rate of increase
#        noiseSD = sd of a normal distribution with mean 0
# output: vector n with population sizes > 0 
#         until extinction, then NA 
#------------------------------------------------- 
library(tcltk)
RanWalk <- function(times=100,n1=50,lambda=1.00,noiseSD=10) {
  n <- rep(NA,times)  # create output vector
  n[1] <- n1 # initialize with starting population size
  noise <- rnorm(n=times,mean=0,sd=noiseSD) # create noise vector
  for(i in 1:(times-1)) {
    n[i + 1] <- lambda*n[i] + noise[i]
    if(n[i + 1] <=0) {
      n[i + 1] <- NA
      cat("Population extinction at time",i-1,"\n")
      # tkbell()
      break}
  }
  
  return(n)
}
# explore paramaters in plot function
plot(RanWalk(),type="o")
plot(RanWalk(lambda=0.99,noiseSD=4),type="o")

# a tip for working with matrices
# create test matrices of differen rown and column numbers
z <- matrix(runif(9),nrow=3)
z[3,3]
z <- matrix(runif(20),nrow=5)
z[5,4]

# for loops on matrices
#loop over rows
m <- matrix(round(runif(20),digits=2),nrow=5)
for (i in 1:nrow(m)){# could also use 'for (i in seq_len(nrow(m)))
  m[i,] <- m[i,] + i
}
print(m)

#loop over columns
m <- matrix(round(runif(20),digits=2),nrow=5)
for (i in 1:ncol(m)){# could also use 'for (i in seq_len(nrow(m)))
  m[,i] <- m[,i] + i
}
print(m)

#nested for loop (rows and cols)
m <- matrix(round(runif(20),digits=2),nrow=5)
for (i in 1:nrow(m)){# could also use 'for (i in seq_len(nrow(m)))
  for (j in 1:ncol(m)){# could also use 'for (i in seq_len(nrow(m)))
    m[i,j] <- m[i,j] + i + j
  } # end j loop 
} # end i loop 
print(m)

#Writing functions for equations and sweeping over parameters
# S = cA^z species area function, but what does it look like
# from island biogeography
#########################################################
# FUNCTION: SpeciesAreaCurve
# creates a power function relationship for S and A
# INPUT: A - vector of island areas
#        c - intercept constant
#        z - slope constant
# OUTPUT: S - vector of species richness values
#-------------------------------------------------------
SpeciesAreaCurve <- function(A=1:5000,c=0.5,z=0.26){
  S <- c*(A^z)
return(S)
}
head(SpeciesAreaCurve())

###################################################
# FUNCTION: SpeciesAreaPlot
# plot species area curves with parameter values
# input: A = vector of areas
#        c = single value for c parameter
#        z = single value for z parameter
# output: smoothed curve with parameters in graph
#-------------------------------------------------
SpeciesAreaPlot <- function(A=1:5000,c= 0.5,z=0.26) {
  plot(x=A,y=SpeciesAreaCurve(A,c,z),type="l",xlab="Island Area",ylab="S",ylim=c(0,2500))
  mtext(paste("c =", c,"  z =",z),cex=0.7) 
  return()
}
SpeciesAreaPlot()


#now build a grid of plots
cPars <- c(100,150,175)
zPars <- c(0.1,0.16,0.26,0.3)
par(mfrow=c(length(cPars),length(zPars)))
for (i in seq_along(cPars)){
  for (j in seq_along(zPars)){
    SpeciesAreaPlot(c=cPars[i],z=zPars[j])
  }
}
par(mfrow=c(1,1))

#looping with while or repeat
cutPoint <- 0.1
z <- NA
ranData <- runif(100)
for (i in seq_along(ranData)){
  z <- ranData[i]
  if (z < cutPoint) break
}
cat("i = ",i," z = ",z)

#looping with while
z <- NA
cycleNumber <- 0
while (is.na(z) | z >= cutPoint){
  z <- runif(1)
  cycleNumber <- cycleNumber + 1
}
print(z)
print(cycleNumber)

# looping with repeat 
z <- NA
cycleNumber <- 0
repeat{
  z <- runif(1)
  cycleNumber <- cycleNumber + 1
  if (z <= cutPoint) break
}
print(z)


#use expand grid to create a data frame with parameter combinations
expand.grid(cPars,zPars)
##############################################
# FUNCTION: SA_output
# Summary stats for spieces-area power function
# INPUT: vector of predicted species richness
# OUTPUT: list of max-min, coefficient of variation
#--------------------------------------------------
SA_output <- function(S=runif(1:10)){
  sumStats <- list(SGain=max(S)-min(S), SCV=sd(S)/mean(S))
  return(sumStats)
}
SA_output()

#----------------------------------------------------------
# Build program body with a single loop through 
# the parameters in modelFrame

#Global Variables
Area <- 1:5000
cPars <- c(100,150,175)
zPars <- c(0.1,0.16,0.26,0.3)

#set up model frame 
modelFrame <- expand.grid(c=cPars,z=zPars)
modelFrame$SGain <- NA
modelFrame$SCV <- NA
print(modelFrame)

#cycle through model calculations
for (i in 1:nrow(modelFrame)){ 
  #generate S vector
  . <- SpeciesAreaCurve(A=Area,
                        c=modelFrame[i,1],
                        z=modelFrame[i,2])
  #calculate output stats
  . <- SA_output(.)
  #pass results to columns in data frame
  modelFrame[i,3] <- .[1] 
  modelFrame[i,4] <- .[2] 
}
print(modelFrame)

#use cex expansion to show a third variable with symbol size
plot(x=modelFrame$c,y=modelFrame$SGain,cex=10*modelFrame$z)


#---------------------------------------
#parameter sweeping redux with ggplot
library(ggplot2)

#Global Variables
Area <- 1:5
cPars <- c(100,150,175)
zPars <- c(0.1,0.16,0.26,0.3)

# set up model frame
modelFrame <- expand.grid(c=cPars,z=zPars,A=Area)
modelFrame$S <- NA

#loop through parameters and fill with SA function
for (i in seq_along(cPars)){
  for (j in seq_along(zPars)){
    modelFrame[modelFrame$c==cPars[i] & modelFrame$z==zPars[j],"S"] <-   SpeciesAreaCurve(A=Area,c=cPars[i],z=zPars[j])
  }
}
#print(modelFrame) #check by printing a dataframe with limited parameter values
p1 <- ggplot(data=modelFrame)
p1 + geom_line(mapping= aes(x=A,y=S)) + facet_grid(c~z)    
p2 <- p1
p2 + geom_line(mapping=aes(x=A,y=S,group=z)) + facet_grid(.~c)
p3 <- p1
p3 + geom_line(mapping=aes(x=A,y=S,group=c)) + facet_grid(z~.)
p4 <- p1
p4 + geom_line(mapping=aes(x=A,y=S,group=c,color=c)) + facet_grid(z~.)


