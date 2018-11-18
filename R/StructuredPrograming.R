# Program Description---------------------------
# Example of sturctured programming in R
# Adrian Wiegman
# 20180308

# Preliminary Set Up----------------------------

library(ggplot2)
library(TeachingDemos)
char2seed("espresso")

# Function Definitions---------------------------
# Aim for an intermedian level of complexity of functions
# between 5 and 15 lines of code, 20 lines MAX
#################################################
# FUNCTION: GetData
# obtain data needed to run program
# input: x
# output: y
#-----------------------------------------------
GetData <- function(fileName=NULL){
  if(is.null(fileName)){
    df <- data.frame(ID=101:110,
                     varA=runif(10),
                     varB=runif(10))
    message('message: no filename provided, producing data from 10 random numbers') 
  }else{
    df <- read.table(file=fileName,
                     header=TRUE,
                     sep=",",
                     stringsAsFactors=FALSE,
                     comment.char = "#")
  }
  return(df)
}
#GetData()
#################################################
# FUNCTION: CalculateStuff
# fits an OLS least squares regression
# input: x and y vectors, numeric of the same length
# output: entire model summary 
#-----------------------------------------------
CalculateStuff <- function(x=runif(10),y=runif(10)){
  df <- data.frame(x,y)
  regModel <- lm(y~x,data=df)
  return(summary(regModel))
}
#CalculateStuff()
#################################################
# FUNCTION: SummarizeOutputs
# return residuals from a linear model object
# input: z, a linear model object
# output: residuals of z
#-----------------------------------------------
SummarizeOutputs <- function(z=NULL){ #this will slow down code if used iteratively
  if (is.null(z)){
    z <- summary(lm(runif(10)~runif(10)))
  }
  return(z$residuals)
}
#SummarizeOutputs()
#################################################
# FUNCTION: GraphResults
# scatterplot x and y variables with smoothed line
# input: x
# output: y
# debug status:
# date of revision:
#-----------------------------------------------
GraphResults <- function(x=runif(10),y=runif(10)){
  df <- data.frame(x,y)
  p <- qplot(data=df,x=x,y=y,geom=c('smooth','point'))
  print(p)
  message('message:regression graph created')
}
#GraphResults()
# Main Program Code-----------------------------------
GetData()
CalculateStuff()
SummarizeOutputs()
GraphResults()
# END PROGRAM
