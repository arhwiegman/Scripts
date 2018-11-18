# Demonstrates sourcing of a file for
# execution of functions
# Adrian Wiegman
# 20180308

# START PROGRAM-------------------------
# Preliminary Set Up-------------------- 

# set working directory
getwd()
setwd(paste0(getwd(),"/Rcodes"))

#load packages
library(ggplot2)
# Define Functions----------------------
source("MyFunctions.R")
# Main Program--------------------------
CalculateStuff()
GetData()
CalculateStuff()
SummarizeOutputs()
# END PROGRAM---------------------------

