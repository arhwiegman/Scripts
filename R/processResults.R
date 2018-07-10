# Process Gen5 plate reader colorimetric PO4P (malachite green) results
# Nutrient Cycling and Ecological Design Lab 
# University of 
# Author: Adrian Wiegman (adrian.wiegman@uvm.edu)
# Date Created: 20180320


#PRELIMINARY SETUP----------------------------------------
#load required packages
require(stringr)
require(readr)
require(installr)
#load functions
source("functions.R")

#USER INPUT SECTION--------------------------------------
#make sure your file is in the working directory
dir()
#set working directory to folder containing PO4-Gen5 results
setwd(getwd())
#enter filename of .xslx or .csv outputs exported from Gen5 P04 procedure
filename = "exampleData.xlsx"
# Are labels present on the plate layout in filename? 
# if there are 3 rows between STD1 (in Col C row 23 in filename) and STD2 
# then set labeledlayout = TRUE
# if there are only 2 rows between STD1 (in Col C row 23 in filename) and STD2 
# then set labeledLayout = FALSE
labeledLayout = FALSE

#MAIN PROGRAM--------------------------------------------
#convert file to csv
csvfile <- convert2csv(filename)
#read plate layout
layout <- readLayout(csvfile,labeledLayout)
#read raw absorbance values
absRaw <- readRawAbsorbance(csvfile,labeledLayout)
#read absorbance values adjusted for blank
absAdj <- readAdjustedAbsorbance(csvfile,labeledLayout)
#fit standard curve

#write sample Phosphorus values to new file