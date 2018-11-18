#########################################################################
#FUNCTION: defineX
# creates a vector describing an x variable to be used in a statistical model 
# input:
#    name - name of the variable
#    n - number of treatment levels, if continuous == TRUE then nLev is the number of observations
#    continuous - TRUE if values are numeric, FALSE if values are categorical factor
#    Bh - Beta, hypothesized effect size on y
#    name - string containing a descriptive one word name or abbreviation
#    notes - string describing the variable and its units
#    units - 
#-------------------------------------------------------------------------
defineX <- function(n=2,
                    continuous=FALSE,
                    hBeta=0,
                    name="myX",
                    notes="categorical variable",
                    units="(no units)"){
 X <- c(n=n,
        continuous=continuous,
        hBeta=hBeta,
        name=name,
        notes=notes,
        units=units)
 return(X)
}
defineX()
#########################################################################
#FUNCTION: creatExperiment
# function to simulate random normal data for a specified balanced experimental setup
#inputs: 
# number of factors, blocks, levels, replications in experiment
# sample mean and standard deviation of all samples
# the effect size of factors, blocks, treatments, replications

#outputs:
# a datafram containing random data and treatment factors
#notes on updates:
# - This is a revised version of simulateData, which operated very slowly
# because the function called c() to build vectors within a for loop. This version pre-assigns the mode and length of vectors based on the number of factors, blocks, levels and replications. 
# - The response variable model can now be specified in a string using the same notation as lm() 
#   y~x1+x2 --> y = b0 + b1*x1 + b2*x2 + E
    
#-------------------------------------------------------------------------
makeXdf <- function(nFactors = 1, #number of treatment factors
                      nBlocks = 1, #number of study blocks or sites
                      nLevels = 3, #number of treatment levels for each factor
                      nReps = 10 #number of replications f(b(l(r))))
                      ){
  nTotal <- nFactors*nBlocks*nLevels*nReps
  ID <- vector(mode = "numeric", length = nTotal)
  fact <- vector(mode = "numeric", length = nTotal)
  block <- vector(mode = "numeric", length = nTotal)
  level <- vector(mode = "numeric", length = nTotal)
  rep <- vector(mode = "numeric", length = nTotal)
  response <- vector(mode = "numeric", length = nTotal)
  i <- 0
  for (f in seq(1,nFactors)){
    for (b in seq(1,nBlocks)){
      for (l in seq(1,nLevels)){
        for (r in seq(1,nReps)){
          i <- i + 1
          ID[i] <- i
          fact[i] <- f
          block[i] <- b
          level[i] <- l
          rep[i] <- r
          cat(i,"f",f,"b",b,"l",l,"r",r,"\n")
        }# end o loop
      } # end t loop
    } # end b loop
  } # end f loop
  df <- data.frame(ID,
                   fact,
                   block,
                   level,
                   rep,
                   response)
  return(df)
} 
df <- makeXdf()
#########################################################
#simulateData()
# function to simulate random normal data for a specified balanced experimental setup
#inputs: 
# number of factors, blocks, levels, replications in experiment
# sample mean and standard deviation of all samples
# the effect size of factors, blocks, treatments, replications

#outputs:
# a datafram containing random data and treatment factors
#notes on updates:
# - This is a revised version of simulateData, which operated very slowly
# because the function called c() to build vectors within a for loop. This version pre-assigns the mode and length of vectors based on the number of factors, blocks, levels and replications. 
# - The response variable model can now be specified in a string using the same notation as lm() 
#   y~x1+x2 --> y = b0 + b1*x1 + b2*x2 + E

#-------------------------------------------------------------------------
B0 = 20 #average accross all samples 
SD = 5
epsilon = SD*rnorm(n=length(df$response)) #standard deviation across all samples
Bf = 0 #factor effect or Beta factor
Bb = 0 #block effect or Beta block
Bl = 5 #treatment effect or Beta block
Br = 0 #observation effect if time series treatment
"y~x1+x2+x3+x4"
"1*B0 + x1*B1 + x2*B2 + x3*B3 + x4*B4 + epsilon"
eqn =
  "sum(args)"


response <- eval(parse(text=paste(eqn))
                  

