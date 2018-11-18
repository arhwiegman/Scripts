# Determine proper experimental design for a set of data
# Adrian Wiegman
# 20180308

# START PROGRAM---------------------------------------

# Preliminary Setup-----------------------------------
#load packages
library(ggplot2);theme_set(theme_classic())
library(plyr)
library(multcompView)
# set working directory
setwd("C:/Users/Adria/Documents/R/Projects/BIO381/HW7")
# set random number seed
set.seed(100)
# Define Functions------------------------------------
#########################################################################
#FUNCTION: simulateData
# function to simulate random normal data for a specified experimental setup
#inputs: 
# number of factors, blocks, treatments, replications in experiment
# sample mean and standard deviation of all samples
# the effect of factors, blocks, treatments, replications
#outputs:
#-------------------------------------------------------------------------
simulateData <- function(nFactors = 1, #number of treatment factors
                         nBlocks = 1, #number of study blocks or sites
                         nTreats = 3, #number of treatment levels for each factor
                         nReps = 10, #number of observations or reps per treatment level per block
                         AVG = 20, #average accross all samples 
                         SD = 5, #standard deviation across all samples
                         fE = 0, #factor effect
                         bE = 0, #block effect
                         tE = 5, #treatment effect
                         rE = 0 #observation effect if time series trend
){
  ID <- NULL
  factor <- NULL
  block <- NULL
  treatment <- NULL
  observation <- NULL
  response <- NULL
  i <- 0
  for (f in seq(1,nFactors)){
    for (b in seq(1,nBlocks)){
      for (t in seq(1,nTreats)){
        for (r in seq(1,nReps)){
          i <- i + 1
          ID <- c(ID,i)
          factor <- c(factor,f)
          block <- c(block,b)
          treatment <- c(treatment,t)
          observation <- c(observation,r)
          response[i] <- AVG + f*fE* + b*bE + t*tE + r*rE + 5*rnorm(n=1)
        } # end o loop
      } # end t loop
    } # end b loop
  } # end f loop
  Data <- data.frame(ID,
                     factor,
                     block,
                     treatment,
                     observation,
                     response)
  return(Data)
} 
#simulateData()
#######################################################
#FUNCTION: AOVtest
# function to conduct Analysis of Variance, produce a vector of outputs and plot a graph
#inputs:
#y - continuous response variable
#x - categorical x variable
#alpha - significance level e.g. 0.05 or 0.01 or 0.001
#postHoc - T/F if TRUE function runs TukeyHSD
#outputs: returns a list with p value and TukeyHSD results
AOVtest <- function(x=rep(letters[1:3],each=10),
                    y=runif(30)*rep(1:3,each=10),
                    alpha=0.05,
                    postHoc = TRUE){
  if (length(y)!=length(x)){
    stop('x and y vectors are not the same lenght')
  }
  # make sure treatment var, x, a factor
  if (!is.factor(x)){x<-factor(x)}
  df <- data.frame(ID=1:length(y),y=y,x=x)
  test <- aov(y~x, data=df) #analysis of variance function
  pvalue <- as.numeric(unlist(summary(test))[9])
  if (pvalue <= alpha && postHoc == TRUE){
    tuk <- TukeyHSD(test, ordered = FALSE, conf.level = (1 - alpha))
    results <- c('pvalue'= pvalue, #p-value for h0 means are not different
                 'tukey.table'=tuk) #results of tukey table
    return(results)
  }
  results <- c('pvalue'=pvalue, test)
  return(results)
}
#AOVtest()

#######################################################
# FUNCTION: plotAOV
# produces a boxplot labeled with analysis of variance results 
# Inputs: 
# treatment - catagorical x independant variable 
# response - continuous y dependant variable
# statsOnPlot - T/F if TRUE graph p value and post hoc test on plot
# postHoc - T/F if TRUE graph significant difference labels on plot
#Outputs: 
#p - ggplot object with boxplot and results
#Dependancies:
# tukeylabel_df()
# ggplot2
#-----------------------------------------------------------
plotAOV <- function(treatment=rep(1:3,each=10),
                    response=runif(30),
                    statsOnPlot=FALSE,
                    postHoc=FALSE,
                    alpha=0.05){
  #create data frame for analysis
  if(is.integer(treatment)){x <- factor(treatment)
  }else{stop('function failed: treatment must be an integer')}
  df <- data.frame(ID = 1:length(treatment),
                   x=x, #converting to numeric factor
                   y=response)
  
  if(statsOnPlot==TRUE){
    #generate significant diference labels for postHOC tests
    if (postHoc == TRUE){
      stats <- tukeyLabels(treatment=treatment,response=response)
      p <- ggplot(data=df,aes(x=x,y=y))+geom_boxplot()+ 
           geom_text(data=stats, 
                     aes(x=plot.labels,
                         y=V1,
                         label=labels,
                         hjust=c(2,2,2),
                         fontface='bold'))
    } else {
      t <- unlist(summary(aov(y~x,data=df)))
      pvalue <- toString(t[9]) 
      p <- ggplot(data=df,aes(x=x,y=y,fill=x))+
        geom_boxplot()+
        geom_text(aes(x=Inf,y=Inf,hjust=1.1,
                      vjust=1.5,label=paste("p =",pvalue)))
    } #end if postHoc
  } else {#if stats on plot not equal TRUE
  p <- ggplot(data=df,aes(x=x,y=y,fill=x))+geom_boxplot()
  } #end if stats on plot
  return(p) # return ggplot object
}
#plotAOV(statsOnPlot=TRUE,postHoc=TRUE)


#########################
#FUNCTION: tukeylabel_df
#generates labels indicating significant differences from tukey post-hoc
#for use in ggplot2 boxplots
#inputs: 
#x and y - vectors of same length, 
#alpha - a numeric value indicating significance level (e.g. 0.05)
#outputs: a dataframe of labels for the tukey test
#------------------------------------------------
tukeyLabels <- function(treatment=rep(1:3,each=10), # treatment levels
                        response=runif(30), # responses to treatments
                        alpha=0.05){
  # Extract labels and factor levels from Tukey post-hoc
  if(is.factor(treatment)){}else{treatment <- factor(treatment)}
  df <- data.frame(x=treatment,y=response)
  HSD <- TukeyHSD(aov(y~x,data=df), 
                  ordered = FALSE, 
                  conf.level = (1-alpha))
  Tukey.levels <- HSD[['x']][,4]
  Tukey.labels <- multcompLetters(Tukey.levels)['Letters']
  plot.labels <- names(Tukey.labels[['Letters']])
  # Get highest quantile for Tukey's 5 number summary and add a bit of space to buffer between    
  # upper quantile and label placement
  boxplot.df <- ddply(df, 'x', function (z) max(fivenum(z$y)) + 0.2)
  
  # Create a data frame out of the factor levels and Tukey's homogenous group letters
  plot.levels <- data.frame(plot.labels, 
                            labels = Tukey.labels[['Letters']],
                            stringsAsFactors = FALSE)
  
  # Merge it with the labels
  labels.df <- merge(plot.levels, 
                     boxplot.df, 
                     by.x = 'plot.labels', 
                     by.y = 'x',
                     sort = FALSE)
  
  return(labels.df)
}
#tukeyLabels()

# Main Program----------------------------------------

# set default parameters
nFactors = 1 #number of treatment factors
nBlocks = 1 #number of study blocks or sites
nTreats = 3 #number of treatment levels for each factor
nReps = 10 #number of observations or reps per treatment level per block
AVG = 20 #average accross all samples 
SD = 5 #standard deviation across all samples
fE = 0 #factor effect
bE = 0 #block effect
tE = 0 #treatment effect
rE = 0
alpha <- 0.05 #significance level - 95% confidence
p <- 1 #p value of statistical test


# Objective 1:
# determine the effect size needed to have significant result
# with 
count <- 0
while (p >= alpha){
  tE <- tE + 0.1
  for (i in seq(1,100)){
    count <- count + 1
    myData <- simulateData(nFactors,nBlocks,nTreats,nReps,AVG, SD,fE,bE,tE,rE)
    myAOV <- AOVtest(y=myData$response,
                     x=myData$treatment,
                     alpha=alpha,
                     postHoc=TRUE)
    if (i == 1){
      pVal<-unlist(myAOV[1])
    }else {
      pVal <- c(pVal,unlist(myAOV[1]))
    }
  }
  p <- mean(pVal)
}
print(c("Effect Size"=tE))

plotAOV(response=myData$response,
        treatment=myData$treatment,
        statsOnPlot=TRUE,
        postHoc=TRUE,
        alpha=alpha) 
# END PROGRAM-----------------------------------------