# illustrate break function with a program
# program for a random walk
# a(t) is a function of a(t-1)
# Adrian Wiegman 
# March 22 2018


####################################################
#FUNCTION: RanWalk
#stochastic random walk 
#input:
#    times - number of time steps
#    n1 - initial population size n at time=1 or n[1]
#    lambda - finite rate of increase % per time step 
#    noiseSD - sd of normal distribution w/ mean of zero
#output:
#    n - a vector with population sizes > 0 
#--------------------------------------------------
library(ggplot2)

RanWalk <- function(times=100,
                     n1=50,
                     lambda=1.0,
                     noiseSD=10){
  require(tcltk)
  n <- rep(NA,times) #create vector lenght=times
  n[1] <- n1
  noise <- rnorm(n=times,mean=0,sd=noiseSD)
  for (i in 1:(times-1)){
    n[i+1] <- n[i]*lambda + noise[i] # random walk
    #n[i+1] <- n[1] + noise[i] #white noise
    if(n[i+1] <= 0){
      n[i+1]<- NA
      cat("Population extinction at time",i,"\n")
      # tkbell() makes a bell sound when population goes extinct
      break #terminate for loop
    } #end if 
  } #end for loop
  return(n[complete.cases(n)])
} #end function 
z <- RanWalk(lambda=1.03,noiseSD=10)
length(z)
summary(z)
qplot(x=seq_along(z),y=z,geom=c("line"))+theme_classic()
