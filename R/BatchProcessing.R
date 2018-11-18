# Batch Processing in R

#DEFINE FUNCTIONS---------------------------------
#####################################
# FUNCITON: FileBuilder
# create a set of random files for regression
# input: fileN - number of files to create
#      : fileFolder - name of folder for files
#      : fileSize - c(min,max) number of rows in file
#      : fileNA - number on average of NA per column
# output: set of random files
#-----------------------------------
FileBuilder <- function(fileN=10,
                        fileFolder="RandomFiles",
                        fileName = "randomXY",
                        fileSize=c(15,100),
                        fileNA=3){
  for (i in seq_len(fileN)){
    if(dir.exists(fileFolder)){}else{dir.create(fileFolder)}
    fileLength <- sample(fileSize[1]:fileSize[2],size=1)
    varX <- runif(fileLength) #random x values
    varY <- runif(fileLength) #random y values
    df <- data.frame(varX,varY) #bind to dataframe
    badVals <- rpois(n=1,lambda=fileNA) #random poisson gives an integer
    df[sample(nrow(df),size=badVals),1]<-NA# random sample of a vector in x col
    df[sample(nrow(df),size=badVals),2]<-NA# y column
    fileLabel <- paste0(fileFolder,"/",fileName,
                        formatC(i,width=3,format="d",flag="0"), 
                        # adds padding of zeros infront of i
                        ".csv")
    #set up data file and incorporate time stamp
    # METADATA using cat()
    write.table(cat("# Simulated random data file for batch processing \n",
                    "# timestamp: ", as.character(Sys.time()),"\n",
                    "# Adrian Wiegman \n",
                    "# ------------------------------- \n",
                    file=fileLabel,
                    row.names="",
                    col.names="",
                    sep=""))
    write.table(x=df,
                file=fileLabel,
                sep=",",
                row.names=FALSE,
                append=TRUE)
  }# end for loop 
  
}# end function FileBuilder
#FileBuilder() 

#############################################
# FUNCTION: regStats
# fit linear regression model, get stats
# input: 2 column data frame
# output: slope,p-value,r2
#------------------------
regStats <- function(d=NULL){
  if(is.null(d)){
    xVar <- runif(10)
    yVar <- runif(10)
    d <- data.frame(xVar,yVar)
  }
  . <- lm(data=d,d[,2]~d[,1]) # column y 
  . <- summary(.)
  statsList <- list(Slope=.$coefficients[2,1],
                    pVal=.$coefficients[2,4],
                    r2=.$r.squared)
  return(statsList)
} #end function regStats
#regStats()

#MAIN PROGRAM-----------------
#load libaries
library(TeachingDemos)
char2seed("Freezing March")

#Manage File Directories
if(dir.exists("BatchOutput")){
  #delete all files
  unlink(paste0(fileFolder,"/",list.files(fileFolder)))
}else{
  batcdir.create("BatchOutput")
} # end if 
#---------------------------
#Global Variables
fileFolder <- "RandomFiles"
nFiles <- 100
j <- 3 #average number of NAs
errorFlag <- 0
fileOut <- "StatsSummary.csv"

# PARAMETER MANIPULATION LOOP
#for loop to change parameters in FileBuilder
for (j in seq(3,30)){
  cat("for loop... j =",j,"\n")
  #delete files in randnom files folder
  #DANGER THESE COMMANDS DELETE ALL FILES IN A SPECIFIED PATH
  #file.remove(paste0(fileFolder,"/",list.files(fileFolder)))
  unlink(paste0(fileFolder,"/",list.files(fileFolder)))
  
  #create new file for summary stats
  n <- formatC(j,format="d",width=2,flag="0")
  fileOut <- paste0("BatchOutput/","StatsSummary",n,".csv")
  # set up the output file and incorperate time stamp and minimal   emtadata
  write.table(cat("# Summary stats for ",
                  "batch processing of regression models","\n",
                  "# timestamp: ",as.character(Sys.time()),"\n",
                  "# Adrian Wiegman","\n",
                  "# ------------------------", "\n",
                  "\n",
                  file=fileOut,
                  row.names="",
                  col.names="",
                  sep=""))
  
  
  # create 100 files with j number of NA values on average
  FileBuilder(fileN=nFiles,fileNA=j)
  
  fileNames <- list.files(path=fileFolder)
  
  # Create data frame to hold file summary statistics
  ID <- seq_along(fileNames)
  fileName <- fileNames
  slope <- rep(NA,nFiles)
  pVal <- rep(NA,nFiles)
  r2 <- rep(NA,nFiles)
  RAWnrow <- rep(NA,nFiles)
  CLEANnrow <- rep(NA,nFiles)
  
  statsOut <- data.frame(ID,fileName,slope,pVal,r2,RAWnrow,CLEANnrow)
  # BATCH PROCESSING LOOP
  # batch process by looping through individual files
  for (i in seq_along(fileNames)) {
    cat("for loop... i =",i,"\n")
    data <- read.csv(file=paste0(fileFolder,"/",fileNames[i]),
                     comment.char="#") # read in next data file
    dClean <- data[complete.cases(data),] # get clean cases
    statsOut[i,"RAWnrow"] <- nrow(data)
    statsOut[i,"CLEANnrow"] <- nrow(dClean)
    if (nrow(dClean)==1){
      cat("# length of cleaned data = 1... \n")
      err <- paste("# ERRORS \n",
                   "# unable to perform regression on file",fileName[i],"\n",
                   "# ------------------------------------\n",sep="")
      write(err,
            file=fileOut,
            append=TRUE)
      cat("writing outputs to",fileOut,"\n")
      # now add the data frame
      write.table(x=statsOut,
                  file=fileOut,
                  row.names=FALSE,
                  col.names=TRUE,
                  sep=",",
                  append=TRUE)
      errorFlag <- 1
      break("Error in .$coefficients[2, 1] : subscript out of bounds")
    }# end if
    . <- regStats(dClean) # pull regression stats from clean 
    # write output before error stops execution
    statsOut[i,3:5] <- unlist(.) # unlist, copy into last 3 column
  } # end for loop for i 
  cat("writing outputs to",fileOut,"\n")
  # now add the data frame
  write.table(x=statsOut,
              file=fileOut,
              row.names=FALSE,
              col.names=TRUE,
              sep=",",
              append=TRUE)
} # end for loop for j 



