# Install packages
#library(data.table)
library(stringr)
library(readr)
#library(parallel) #if you have more than two cores use this
library(sqldf)
library(RMySQL)
library(DBI)
#dplyrTuttorial https://statkclee.github.io/R-ecology-lesson/04-dplyr.html
library(dplyr)
library(dbplyr)
library(RSQLite)

require("RSQLite")

#Define Functions

###########################################
#FUNCTION: countCharInString
#Input:
#  char - a single character or sequence of characters including regex
#  string - a string containing multiple characters
#Output:
#  out - a numeric value for the number of c in b
# countCharInString <- function(char=",",string="data,data,data") {
#   string_wo_char <- gsub(char,"",string)
#   out <- nchar(string) - nchar(string_wo_char)
#   return (out)
# }
# countCharInString()

#########################################
#FUNCTION: readMetaData
# identifies comment characters at the top of a document
# input:
#     a string with containing a file path
# output:
#     a vector of strings starting with the comment character
#-------------------------------------------------
readMetaData <- function(filename=NULL,clist=NULL){
  require("readr")
  require("stringr")
  if(is.null(clist)){
  clist <- c('#','%%','//','!')
  }
  if(is.null(filename)){
    filename <- "testmeta.csv"
    write_lines(clist,filename)
  }
  #determine if there is a comment symbol e.g. "#" in first char of line
  m <- "..." #metadata
  l = 0 #line number 
  a <- read_lines(filename,n_max=1, skip=l)
  b <- clist %in% str_sub(a,1,2)
    #TRUE if comment found at first char of line
  while (TRUE %in% b){
    #set line contents (a) to metadata (m)
    m <- c(m,a)
    l <- l + 1 # advance to the next line 
    a <- read_lines(filename,n_max=1, skip=l)
    b <- clist %in% str_sub(a,1,2)
  } # end while
commentChar <- matrix(c(clist,b),nrow=4)
return(list(line=l,commentChar,metaData=m))
}
system.time(readMetaData())
##########################################
# FUNCTION: matchColNumber
# this function adds or removes commas from data lines
# that do not conform to the number of commas in a header of .csv
# input: 
#    dataSt - a string object w/ single line of .csv data 
#    headSt- a string object w/ a single .csv column names 
# outputs:
#    vector string w/ (1) edited data and (2) a log of edits
matchColNumber <- function(dataSt="asdfjkasbeuuedmmm,,.assdgs,s.",
                           headSt="sdfsdfs,,ssdg,,"){
  require("stringr")
  ncD <- str_count(string=dataSt,pattern=",") #number of columns data
  ncH <- str_count(string=headSt,pattern=",") #number of columns header
  dNC <- ncH - ncD # difference in number of columns b.w. header and row
  if(dNC>0){ #if more columns in header
    #add dNC more separators 
    dataSt <- paste0(dataSt,strrep(" , ",dNC))
    #remove the last n commas}
    return(c(dataSt,paste("added ",dNC,"','to line")))
  }else if(dNC<0){ 
    #if more commas in data than header...
    #remove commas from data
    # find all commas in string
    d <- str_locate_all(dataSt,",")
    # loop for the last 5 commas
    for (k in seq(ncD+dNC,ncD,1)){ 
      cPos <- d[[1]][k,1] #gives the start position of commas
      str_sub(dataSt, start = cPos, end = cPos) <- "[comma]"
    } # end for
    return(c(dataSt,paste("replaced",dNC,"',' with [comma]")))
  } # end if
  return(c(dataSt,"no changes"))
} #end function 
system.time(matchColNumber("butt,sex,sb,s","butt,sexs,s,s,s,s,s,"))

##########################################
#FUNCTION: removeBadChars()
# removes unkown characters from s string of text
#Input: a string of text
#Output: a string of text with no unidentified characters
#Dependancies: 
#-----------------------------------------
removeBadChars <- function(z){
  z <- str_replace_all(z,"�","[unknown char. removed]")
  return(z)
}
removeBadChars("�")

######################################################
# FUNCTION: firstCol
# returns a string of first column text with no spaces
# input:
#   datastring - a single line string of data separater by delimiters
#   delim - a string containing the delimiter of the file
# ------------------------------------------------------
firstCol <- function(datastring="  c1 , c2,c3",delim=","){
  require("stringr") 
  #https://www.rstudio.com/wp-content/uploads/2016/09/RegExCheatsheet.pdf
  #http://www.gastonsanchez.com/Handling_and_Processing_Strings_in_R.pdf
  #find the starting pos of first separater in line
  n <- str_locate(pattern=delim,
                  datastring)[1,'start']
  c1 <- str_sub(datastring,1,n-1) #the first n-1 chars of string
  c1text <- str_trim(c1, side = "both")
  if (is.na(c1text)) stop("ERROR in function firstCol: no delimiters found")
  # doesnt require stringr substr(datastring,1,(n-1))
  return(c1text)
}
system.time(firstCol())


#-----------------------------
# MAIN PROGRAM 
#-----------------------------




siteDF <- read.csv("SiteCoordinates.csv",sep=",", header=TRUE, fileEncoding="latin1", stringsAsFactors=FALSE)
write.csv(siteDF,"testData.csv",row.names = FALSE)
site <- siteDF[,1]
str(siteDF)

# #set parameters
# f="test.csv"
# column='"Station"'
# operator="LIKE"
# value='"A%"'

# # data <- read.csv.sql("testData.csv", stringsAsFactors = FALSE)
# # str(data)
# data <- read.csv.sql("testData.csv",sql="SELECT * FROM file WHERE 'si_Long'LIKE -92.%", stringsAsFactors = FALSE)
# closeAllConnections()
# print(data)

# #select data
# sites <- select(siteDF,CRMS_Site)
# # %>% is a pipe, which passes all outputs to the next functin
# sites <- siteDF %>%
#   filter(CRMS_Site == "CRMS0002") %>%
#   select(CRMS_Site) #find out how to use reg exp here
# sites


#set a database containing all files in a working directory
# Manage file connections
wdPath <- "C:/users/adria/documents/R/Projects/CRMS/"
setwd(wdPath)
inPath <- paste0(wdPath,"data/")
dir(inPath)
outPath <- paste0(wdPath,"data_site/")
dir.create(outPath)
dir(outPath)

setwd(inPath)
filenames <- list.files(pattern="\\w*.csv", full.names=TRUE)
filenames <- str_replace(filenames,pattern="^./","")
filepaths <- paste0(inPath,str_replace(filenames,pattern="^./",""))
print(filenames)
i=1
 

#loop for each file in the folder, or for each chunk of the data file
#for (i in seq(1,length(filenames))){
for (i in seq(1,1)){
  lineLengthbyRow <- NULL 
  numColsbyRow <- NULL
  metaData <- NULL
  editLog <- NULL
  require("readr")
  require("stringr")
  #determine if first lines of data are metaData
  metaData <- readMetaData(filenames[i])
  header   <- read_lines(filenames[i],n_max = 1, skip=0)
  #set number of columns and maximum number of characters on a line
  numColsHeader <- str_count(string=header,pattern=",")
  maxLineLength <- nchar(header)
  chunk <- 1000
  j <- 0
  count <- metaData[[1]] # l - current line in file
  firstColList <- NULL #list of data in first column
  newfiles <- 1
  j <- 0
  linecount <- 0
  c <- "*"
  EOF = 0
  repeat {
    dataline <- read_lines(filenames[i],
                           n_max = chunk,
                           skip=linecount)
    j <- j + chunk
    k <- 0
    print(c(linecount,c))
    repeat {
      k <- k + 1
      linecount <- linecount + 1
      #EXIT AT END OF FILE 
      if (is.na(dataline[k])){
        read_lines(f,n_max=chunk,skip=j+k+2)
        # make sure no data is present
        print("End of File Detected")
        EOF<-1
        break
      }
      #CLEAN UP THE DATA
      #SET NCOLS IN ROW = NCOL IN HEADER
      editedLine <- matchColNumber(dataSt=dataline[k],headSt=header)
      if (editedLine[1]!=dataline[k]){
        dataline[k] <- editedLine[1]
        editLog <- c(editLog,editedLine[2])
      } #end if
      #REMOVE UNKNOWN CHARACTERS
      dataline[k] <- removeBadChars(dataline[k]) #update edit log
      
      #Verify ID column matches previous
      ID <- firstCol(dataline[k],",")
      if (c!=ID){
        c <- ID
        newfilepath <- paste0(outPath,c,'_',filenames[i])
        if (linecount>1) write(header,newfilepath,append = FALSE)
      } # end if column
      write(dataline,newfilepath,append = TRUE)
      
      if (k==length(dataline)) break("Completed reading chunk")
    } # end repeat
    if (EOF==1) break #if End of File record detected end repeat
  }# end repeat
  info <- c(file=filenames[i],
             maxlinewidth=maxlinelength,
             numCols=numCols,
             metaData=metaData,
             editLog=editLog)
   write(info,file="fileinfo.txt",append=TRUE)
   write("----------------------------------",
         file="fileinfo.txt",append=TRUE)
}


# 
# dfnames <- str_replace(filenames,pattern=".csv","")
# dbPath <- "C:/users/Adria/Documents/R/projects/CRMS/"
# setwd(dbPath)
# #myDB <- src_sqlite("database.sqlite",create=TRUE) # requires dbplyr
# # without dbplyr use this: tbl(con, sql('select * from my_database.db'))
# myDB <- dbConnect(SQLite(), dbname='database.sqlite')
# #  sqldf(“attach ‘Test1.sqlite’ as new”)
# 
# 
# #FUCKY FUCKY FUCKY ERRORS
# i=7
# dbWriteTable(conn = myDB, name = dfnames[i], value = filepaths[i],row.names = FALSE, header = TRUE, append=TRUE)
# #http://www.starkingdom.co.uk/creating-an-sqlite-database-with-r/
# 

