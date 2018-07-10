#Functions for processing Gen5 plate reader colorometric PO4P results
# Nutrient Cycling and Ecological Design Lab 
# University of 
# Author: Adrian Wiegman (adrian.wiegman@uvm.edu)
# Date Created: 20180320

##################################################################
#FUNCTION: convert2csv
#converts "[name].xlsx" to "[name].csv" and prevents from overwriting 
#existing files named "[name].csv" 
# input: 
# xlsxname - a character string "[name].xlsx" with an ms excel filename
# output: 
# csvname - a character string "[name].csv" with a csv file name 
# --------------------------------------------------------------------------
convert2csv <- function(xlsxname = "exampleData.xlsx"){
  require(stringr)
  require(installr)
  ext <- str_extract(xlsxname,"\\..+")
  if(ext==".xlsx"){
    name <- str_sub(xlsxname,start=1,end=nchar(xlsxname)-nchar(ext))
    csvname <- paste0(name,'.csv')
    #prevent from overwriting other files while csvname already exists
    n <- 0
    while (file.exists(csvname)){
      n <- n + 1
      csvname <- paste0(name,'_',n,'.csv')}
    xlsx2csv(xlsxname,csvname)
  }else{stop("ERROR: file is not of type '.xlsx'")}
  return(csvname)
}
#convert2csv()
#########################################################
#FUNCTION: readPlateLayout
#input a filename string for .csv outputs from Gen5 plate reader
# PO4 procedure from the University of Vermont NCED Labratory
# contacts: Adrian.Wiegman@uvm.edu
readLayout <- function(filename="exampleData.csv"){
  require(readr)
  textlines <-read_lines(file=filename,skip=20,n_max=17)
  require(stringr)
  rowNames <- str_sub(textlines[seq(2,length(textlines),2)],start=2,end=2)
  colNames <- str_extract_all(textlines[1],"[:digit:]+") #REGEX >=1 digit
  layouttext <- str_sub(textlines[seq(2,length(textlines),2)],
                    start=4,
                    end=nchar(textlines[seq(2,length(textlines),2)])
                    -nchar(',Well ID'))
  write(layouttext,"data")
  layout <- read.table("data",sep=',',na.strings = "")
}

#########################################################
#FUNCTION: readLayout
#desciption:
#  Reads plate layout for synergy HT 96 well plate 
#  for the P04P procedure of the nutrient cycling and 
#  ecological design laboratory
#inputs:
#  filename - a character string for a file "[name].csv"
#             containing Gen5 plate reader outputs 
#  labeledLayout - TRUE or FALSE, if TRUE the number of rows (rowskp) in filename between "STD1", "STD2" would is set to 3, if FALSE rowskp = 2
#outputs: 
#  layout - a an 8x12 data frame object with plot layout
#----------------------------------------------------------
readLayout <- function(filename="exampleData.csv",labeledLayout=FALSE){
  require(readr)
  require(stringr)
  if(labeledLayout==FALSE)rowskp=2 
  if(labeledLayout==TRUE)rowskp=3 
  textlines <-read_lines(file=filename,skip=20,n_max=1+8*rowskp)
  print(textlines)
  rowNames <- str_sub(textlines[seq(2,length(textlines),rowskp)],start=2,end=2)
  if(',' %in% rowNames)
    {stop('ERROR: unable to find layout matrix in file please check if labels are present in Gen5 output file and examine your input to the readLayout function')}
  colNames <- str_extract_all(textlines[1],"[:digit:]+") #REGEX >=1 digit
  layouttext <- str_sub(textlines[seq(2,length(textlines),rowskp)],
                        start=4,
                        end=nchar(textlines[seq(2,length(textlines),rowskp)])
                        -nchar(',Well ID'))
  write(layouttext,"data")
  layout <- read.table("data",sep=',',na.strings = "")
  return(layout)
}
#layout <- readLayout(labeledLayout=TRUE)
#########################################################
#FUNCTION: readAdjustedAbsorbance
#input a filename string for .csv outputs from Gen5 plate reader
# PO4 procedure from the University of Vermont NCED Labratory
# contacts: Adrian.Wiegman@uvm.edu
readAdjustedAbsorbance <- function(filename="exampleData.csv",labeledLayout=FALSE){
  require(readr)
  textlines <-read_lines(file=filename,skip=20,n_max=17)
  require(stringr)
  rowNames <- str_sub(textlines[seq(2,length(textlines),2)],start=2,end=2)
  colNames <- str_extract_all(textlines[1],"[:digit:]+") #REGEX >=1 digit
  layouttext <- str_sub(textlines[seq(2,length(textlines),2)],
                        start=4,
                        end=nchar(textlines[seq(2,length(textlines),2)])
                        -nchar(',Well ID'))
  write(layouttext,"data")
  layout <- read.table("data",sep=',',na.strings = "")
} 

#########################################################
#FUNCTION: readRawAbsorbance
#input a filename string for .csv outputs from Gen5 plate reader
# PO4 procedure from the University of Vermont NCED Labratory
# contacts: Adrian.Wiegman@uvm.edu
readRawAbsorbance <- function(filename="exampleData.csv",labeledLayout=FALSE){
  require(readr)
  textlines <-read_lines(file=filename,skip=20,n_max=17)
  require(stringr)
  rowNames <- str_sub(textlines[seq(2,length(textlines),2)],start=2,end=2)
  colNames <- str_extract_all(textlines[1],"[:digit:]+") #REGEX >=1 digit
  layouttext <- str_sub(textlines[seq(2,length(textlines),2)],
                        start=4,
                        end=nchar(textlines[seq(2,length(textlines),2)])
                        -nchar(',Well ID'))
  write(layouttext,"data")
  layout <- read.table("data",sep=',',na.strings = "")
} 
  


