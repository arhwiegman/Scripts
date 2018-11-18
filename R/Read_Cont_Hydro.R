# This script reads a large (6.6 Gb) continuous hydrographic data file from
# the Louisiana Coastwide Reference Monitoring System and writes outputs 
# to smaller file
# Adrian Wiegman
# usefull links:
# https://stat.ethz.ch/pipermail/r-help/2005-April/070203.html
# 

# Install packages
#library(data.table)
library(stringr)
library(readr)
#library(parallel) #if you have more than two cores use this
library(sqldf)

#define functions
##########################################
#FUNCTION: removeUnknownChars()
# removes unkown characters from s string of text
#Input: a string of text
#Output: a string of text with no unidentified characters
#Dependancies: 
#-----------------------------------------
removeBadChars <- function(z){
  z <- str_replace_all(z,"�","[unknown char. removed]")
  return(z)
}
removeBadChars(textline)



# Manage file connections
inPath <- "D:/AW_backups/AW_GoogleArchive_Pre20170829/BPMG - Biophysical Modeling Group (1)/CRMS/"
outPath <- "C:/users/Adria/Documents/R/projects/CRMS/data/"
setwd("C:/users/Adria/Documents/R/projects/CRMS/")
inFileName <- "Continuous_Hydrographic"
#inFileName <- "Soil_Properties"
inFilePath <- paste0(inPath,inFileName,'.csv')
dataPeak <- read.csv(file=inFilePath,nrows=10,stringsAsFactors = FALSE)
View(dataPeak)

#Function subestCRMSdataBySite
# reads a datafile from the louisiana coastwide reference monitoring system and writes new file with data for individual sites
# inputs:
#   inFileName -
#   inPath
#   outPath
# outputs:
#   writes new
subsetCRMSdataBySite <- function(inFileName,inPath,outPath,inFilePath){
  
  MetaData <- c("# METADATA------------------------------------",
                "# Data from Louisiana Coastwide Reference Monitoring System",
                "# Data location: https://www.lacoast.gov/new/Default.aspx",
                "# Obtained on: April 28 2017",
                "# Manipulated on:",
                paste("# Date:",Sys.Date()),
                "# DATA--------------------------------------")
  
  
  # Initialize parameters
  siteID <- "empty"
  site <- "nothing"
  textline <- "blank"
  count <- 0
  nsites <- 0
  sites <- NULL
  header <- read_lines(inFilePath,n_max=1,skip=0)
  
  #Loop to read and write data until end of file
  while (nchar(textline)>=0){
    #read_lines from readr
    count <- count + 1
    if(count>=100)break()
    #if (count == nlines){break("1000 lines read")}
    textline <- read_lines(inFilePath,n_max=1,skip=count)
    textline <- removeBadChars(textline)
    # Extract site name with regular expressions regex() from readr
    siteID <- str_extract(textline, regex("(CRMS[:digit:]{4})[^,]*,"))
    siteID <- str_extract(siteID, regex("(CRMS[:digit:]{4})[^,]*"))
    if(site==siteID){
      write(textline,outFilePath,append=TRUE)
    }else{
      nsites <- nsites + 1
      sites <- c(sites,siteID) #write
      site <- siteID
      outFilePath <- paste0(outPath,siteID,'_',inFileName,'.csv')
      write(MetaData,outFilePath,append=FALSE)
      write(header,outFilePath,append=FALSE)
      write(textline,outFilePath,append=TRUE)
      print(c("New site:",siteID,"new file created"))
      if(count>=2)break()
    }
  }
  print(read_lines(inFilePath,n_max=1,skip=count+10)>=0)
  print(c("REACHED END OF FILE!!!! number of lines =",count))
  
} #end function subestCRMSdataBySite


system.time(fread(inFilePath,nrows=100))
system.time(read_csv(inFilePath,n_max=100))

###############################
#FUNCTION selectiveReadCSV
#reads a selection of data from a csv file based on criteria for a column
#input:
# f - string containing file pathway 
# column - double quoted string 
# operator - a logical operator
# value - value to for conditional statement to conpare
# dependancies - sqldf 
# more on sql https://www.w3schools.com/sql/sql_syntax.asp
# https://stackoverflow.com/questions/29443694/r-read-csv-sql-from-sqldf-is-able-to-successfully-read-one-csv-but-not-another
selectiveReadCSV <- function(f="test.csv",column='"Station"', operator="LIKE", value='"A%"'){
  if(f=='test.csv'){
  DF <- data.frame(Number=1:26,Station=c("A-1","A",LETTERS[3:26]))
  write.csv(DF,f)}
  print(f)
  selection <- read.csv.sql(file=f, 
                      sql = paste('SELECT * FROM file WHERE',column,operator,value), 
                      eol = "\n",  stringsAsFactors=FALSE,
                      dbname = "test.sqlite")
  return(selection)
}
selectiveReadCSV()


selectiveReadCSV <- function(f="test.csv",column='"Station"', operator="LIKE", value='"A%"'){
  if(f=='test.csv'){
    DF <- data.frame(Number=1:26,Station=c("A-1","A",LETTERS[3:26]))
    write.csv(DF,f)}
  print(f)
  selection <- read.csv.sql(f, sql = paste('CREATE TABLE d1 AS SELECT * FROM file'), dbname="Test1.sqlite", eol = "\n",  stringsAsFactors=FALSE)
  sqldf(paste('SELECT * FROM d1 WHERE',column,operator,value),dbname="Test1.sqlite")
  return(selection)
}
selectiveReadCSV()

###############################
#FUNCTION pipeReadCSV
#reads a selection of data from a csv file based on criteria for a column
#input:
# f - string containing file pathway 
# column - either string or index integer index
# criteria - a logical operator
# dependancies - sqldf 
awkReadCSV <- function(f="test.csv",
                       cNum="2", 
                       operator="==", 
                       value="'A'"){
  DF <- data.frame(n=1:26, l=LETTERS)
  write.csv(DF,f)
  read.csv(pipe(paste0("awk 'BEGIN {FS=\",\"} {if ($",cNum,operator,value,") print $0}'",f)))
}

siteDF <- read.csv("SiteCoordinates.csv") 
site <- siteDF[,1]
df <- selectiveReadCSV(f="SiteCoordinates.csv",column='"CRMS_Site"', operator= "=",value='"CRMS0002"')
df

system.time(subsetCRMSdataBySite(inFileName,inPath,outPath,inFilePath))[3]

closeAllConnections()
