#Analyze continuous hydrographic data
#Adrian Wiegman
#20180318

#USER DEFINED FUNCTIONS
########################################################
#turns vector of column names to dataframe with names abbreviations and units
#input colnames(x)
colNameAbbrUnits <- function (colNames = c("c1","c2","c3")){
  require(stringr)
  #Extract the first three words from the column names
  RGX <- "^\\w+\\s*\\w*\\s*\\w*" #regular expression
  cNames <- str_extract(colNames,RGX)
  #Extract the units from the column names
  RGX <- "\\(.*\\)" #regular expression
  cUnits <- str_extract(colNames,RGX)
  names(cUnits) <- cNames
  #abbreviate column names
  abbrCNames<- abbreviate(cNames)
  #set column names to abbreviations
  df <- data.frame(cNames,abbrCNames,cUnits)
  return(df)
}

######################################################
# FUNCTION: plotTimeSeries
# plots a data series observed over time
# inputs:
#   t - time and x - observation
#   savePDF - logical TRUE or FALSE
#   path - file path save the pdf in
#   name - name of the saved plot
plotTimeSeries <- function(t=1:50,
                           x=runif(50),
                           savePDF=FALSE,
                           name=NULL,
                           path=NULL){
  #require(ggplot2)
  df <- data.frame(t,x)
  p <-qplot(x=t,y=x,geom="line",color=I('blue')) + theme_classic()
    if(savePDF==TRUE) {
      if (is.null(name))name <- "timeseriesplot"
      if (is.null(path))path <- getwd()
      pathname <- paste0(getwd(),"/",name,".pdf")
      ggsave(filename=pathname,plot=ANOplot,device='pdf')
    }
  print(p)
}
plotTimeSeries()


#SET WORKING DIRECTORY AND OPEN FILES
wdPath <- "C:/users/adria/documents/R/Projects/CRMS/"
setwd(wdPath)
inPath <- paste0(wdPath,"data/")
dir(inPath)
outPath <- paste0(wdPath,"data_site/")
dir.create(outPath)
datatype <- "Continuous_Hydrographic"
ext <- ".csv"

require(readr)
#IMPORT GIS INFORMATION ON SITES
site_coords <- read_csv(paste0(inPath,"SiteCoordinates",ext),comment ="#")

for (i in length(site_coords)){
site <- site_coords[i,1]

#READ IN DATA FRAME
df <- read_csv(paste0(outPath,site,"_",datatype,ext),comment ="#")

#PREPARE DATA FRAME FOR TIME SERIES ANALYSIS AND STATISTICS
#get column names units and abreviations
colDF <- colNameAbbrUnits(colnames(df))
colnames(df) <- colDF$abbrCNames
# Make a date-time POSIXCT object (seconds)
datetime <- paste(df$Date,df$Time)
datetimezone <- as.POSIXct(x=datetime,format="%m/%d/%Y %H:%M:%S",tz='EST')
# CST is not recognized
# convert CST to EST by substracting 3600 seconds
datetimezone <- datetimezone-3600
#append the POSIXct object to the end of the data with name dtz
df <- data.frame(df,dtz = datetimezone)
#add year to the end of the data
year <- as.numeric(str_extract(df$Date,"[:digit:]{4}"))
df <- data.frame(df,year = year)
#remove columns with only NA values
df <- df[ , ! apply( df , 2 , function(x) all(is.na(x)) ) ]
#remove rows with NA values in specific columns
library(tidyr) 
df <- df %>% drop_na(AdWL, AdjS) #using a pipe
#delete.na <- function(DF, n=0) {
# DF[rowSums(is.na(DF)) <= n,]
#}
write_csv(df,paste0(outPath,'processed_',site,"_",datatype,ext))
}

#SELECT VARIABLE AND PLOT TIME SERIES
require(ggplot2);theme_classic()
x <- df$AdWL
treatment <- factor(df$year)
str(treatment)
plotTimeSeries(t=df$dtz, x=df$AdWL) # adjusted water level, ft
p1 <- ggplot(df,aes(x=dtz, y=AdWL,ylab="adjusted water level (ft)"))+geom_line()+geom_smooth()
p2 <- ggplot(df,aes(x=factor(year), y=AdWL,ylab="adjusted water level (ft)"))+geom_boxplot() # adjusted water level, ft
table(x)["TRUE"]
summary(x)