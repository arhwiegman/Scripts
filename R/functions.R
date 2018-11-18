# All about functions in R
# March 1 2018
# Adrian Wiegman

# everything is a function
sum(3,2) # a 'prefix' function
3 + 2 # also a function 
`+`(3,2) # 'infix function
#all of the above are equivalent

y<-3
`<-`(yy,3)
print(yy)
print(read.table) #look inside a function
sum # typing the name gives the contents of the function 
sum(3,2) #function call with inputs
sum() # most function will run without inputs

#anatomy of a user-defined function in R
functionName <- function (parX='defaultX', #list of parameters
                          parY='defaultY',
                          parZ='defaultZ'){ #function body
  #lines of R code and annotations
  #may call or create other functions 
  #may create local variables (contained within memory while function is running)
  #global variables can also used within the function
  z <- c('a list or a vector of data constructed by the function',
         parX,
         parY,
         parZ)
  return(z)
} #end of function 
functionName #prints the contents of the function
functionName()
functionName(parX=0,parY=c(1,1),parZ='balogna')

#style for functions
#1. fence of function with prominent comments
#2. give header + description of function input and output
#3. use simple names for local variables
#4. more than ~1 successful code

#####################################################
#FUNCTION: functionNAME
# breif description of what the function does
# input: allele frequency p(0,1)
# output: p and frequency of AA, AB, BB genotypes
#---------------------------------------------
hardyWeinberg <- function(p=runif(1)){
  q <- 1 - p
  fAA <- p^2 
  fAB <- 2*p*q
  fBB <- q^2
  vecOut <- signif(c(p=p,AA=fAA,AB=fAB,BB=fBB),digits=3)
  return(vecOut)
}
#END FUNCTION: functionNAME
#####################################################
hardyWeinberg()
hardyWeinberg(p=0.5)
#P is not a global variable so it is not stored in memory of main program

p <- 0.6 # p Global
hardyWeinberg(p=p)
# p(Local) = p(Global)

#####################################################
#FUNCTION: hardyWeinberg2
# demonstrates the use of logical control structures
# input: allele frequency p(0,1)
# output: p and frequency of AA, AB, BB genotypes
#---------------------------------------------
hardyWeinberg2 <- function(p=runif(1)){
  #if p is greater than 1 OR less than zero exit the function and write a failure message 
  if (p > 1.0 | p < 0.0) {
    return('function fails, p out of bounds')
  }
  
  q <- 1 - p
  fAA <- p^2 
  fAB <- 2*p*q
  fBB <- q^2
  vecOut <- signif(c(p=p,AA=fAA,AB=fAB,BB=fBB),digits=3)
  return(vecOut)
}
#END FUNCTION: functionNAME
#####################################################
hardyWeinberg2(1.1)
temp <- hardyWeinberg2(1.1) # passes error message with no warning to console
temp
#####################################################
#FUNCTION: hardyWeinberg3
# demonstrates the 'stop' control structure
# input: allele frequency p(0,1)
# output: p and frequency of AA, AB, BB genotypes
#---------------------------------------------
hardyWeinberg3 <- function(p=runif(1)){
  #if p is greater than 1 OR less than zero exit the function and write a failure message 
  if (p > 1.0 | p < 0.0) {
    stop('function fails, p out of bounds') #stop creates a warming message
  }
  
  q <- 1 - p
  fAA <- p^2 
  fAB <- 2*p*q
  fBB <- q^2
  vecOut <- signif(c(p=p,AA=fAA,AB=fAB,BB=fBB),digits=3)
  return(vecOut)
}
#END FUNCTION: functionNAME
#####################################################
hardyWeinberg3(1.1)
temp1 <- hardyWeinberg3(1.1) # passes error message with no warning to console
temp1

#understanding  scope of local and global variables
myFunc <- function (a=3,b=4){
  z <- a+b
  return(z)
}
myFunc()
myFuncBad <- function(a=3){
  z <- a + bbb
  return(z)
}
myFuncBad()
bbb <- 100
myFuncBad()
# FUNCTION LOOKS FOR VARIABLES IN LOCAL ENVIRONMENT FIRST THEN GLOBAL
# THIS IS BAD CODING FORM
# ALL VARIABLES USED IN THE FUNCTION SHOULD BE DEFINED LOCALLY AS INPUT PARAMETERS OR AS VARIABLES SPECIFIED WITHIN THE FUNCTION

##################################################
#FUNCTION: fitLinear
#fits a linear regression
#input: numeric vectors of x and y
#output: slope, inercept, and p value
#-------------------------------------------------
fitLinear <- function(x=runif(20),y=runif(20)){
  myMod <- lm(y~x) #fits model
  myOut <- c(slope=summary(myMod)$coefficients[2,1],intercept=summary(myMod)$coefficients[1,1],pVal=summary(myMod)$coefficients[2,4])
  plotVar <- qplot(x=x,y=y,geom=c('smooth','point'))
  print(plotVar)
  return(myOut)
}
##################################################
fitLinear()

# dealing with too many parameters
# by bundlin them up
z<-c(runif(99),NA)
mean(z) # need to account for NA
mean(x=z,na.rm=TRUE) #removes NA
mean(x=z,na.rm=TRUE,trim=0.05) # trim of the 2.5 and 97.5 percentile
l <- list(x=z,na.rm=TRUE,trim=0.05)
do.call(mean,l)
