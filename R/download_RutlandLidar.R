#downloadFiles
# downloads files from links on websites

# DEFINE FUNCTIONS ----------------------------------------  

# download.2.mem ###########################################
# downloads a file to a path using memory in R
download.2.mem <- function(url,path){
  download.file(url=url,
                destfile=path, method='curl')
  cat(url,'\n downloaded to local disk at: \n',path)
}

# download.2.disk ###########################################
# dowloads web file directly to path doesn't store in memory
download.2.disk <- function(url, path){
  library('RCurl')
  f = CFILE(path, mode="wb")
  a = curlPerform(url = url, writedata = f@ref, noprogress=FALSE)
  close(f)
  return(a)
}

# find.links.in.html ##########################################
# returns a list website links from an html page 
# inputs: http - a string with a webpage url
find.links.in.html <- function (http='https://www.google.com/'){
  require(rvest)
  links <- http %>% 
    read_html %>% 
    html_nodes("a") %>% # find all links <a </a>
    html_attr("href")  # get the url
  return(links)
}
find.links.in.html()

# ask.2.continue.popbox #########################################
# makes a sound and asks user to type yes or no to continue script
Yes.2.continue.popbox <- function(){
  beepr::beep(sound='coin')
  question <- paste("Type 'Yes' to continue")
  . <- svDialogs::dlgInput(question, Sys.info()["user"])$res
  if(.!='Yes')stop('...loop aborted')
}

# ask.4.URLs.popbox ######################################()
ask.4.URLs.popbox <- function(){
  proceed <- 0
  URLs <- NULL
  while (proceed == 0){
    . <- "Copy URL with download links here:"
    . <- svDialogs::dlgInput(., Sys.info()["user"])$res
    URLs <- c(URLs,.)
    . <- "To add another URL enter 0 to proceed with file download enter 1"
    proceed <- svDialogs::dlgInput(., Sys.info()["user"])$res
  }
  return(URLs)
}

# ask.4.URL.popbox ######################################
ask.4.URL.popbox <- function(){
  . <- "Copy URL with download links here:"
  URL <- svDialogs::dlgInput(.)$res
  return(URL)
}

# ask.4.destpath.popbox ############################################
ask.4.destpath.popbox <- function(npaths=1){
  destpath <- vector(mode="character", length=npaths) # initialize destination paths
  
  #loop to ask user to enter destination folders
  for (i in seq_len(npaths)){
    . <- "Enter destination path (format: 'C:/parent/folder/')"
    . <- svDialogs::dlgInput(.)$res
    destpath[i] <- .
    while (!dir.exists(destpath[i])){
      . <- paste(destpath[i],"does not exist, please enter a valid destination path")
      . <- svDialogs::dlgInput(.)$res
      destpath[i] <- .
    }#end while loop
    return(destpath)
  }#end for loop
}#end function definition


# PRELIMINARIES -----------------------------------------
#Loading packages
library('rvest')
library('stringr')
if (file.exists("functions.R")) source("functions.R")
# http://maps.vcgi.vermont.gov/gisdata/vcgi
# http://maps.vcgi.vermont.gov/gisdata/vcgi/lidar/0_7M/2013/DEMHF/ 


sites <- c(0982,0994,
           1018,1030,
           1055,1067,
           1092,1104,
           1129,1141,
           1165,1178,
           1201,1215,
           1236,1250,
           1271,1285,
           1307,1321,
           1343,1357,
           1381,1396,
           1422,1438,
           1465,1481,
           1509,1525,
           1553,1569,
           1596,1612,
           1639,1655,
           1680,1696,
           1718,1734)
M <- matrix(sites,nrow=2,ncol=20)
M <- t(M)
v <- NA
for (r in seq_len(nrow(M))){
  v <- c(v,seq(M[r,1],M[r,2]))
}
v <- v[!is.na(v)]
s <- str_pad(v, 4, pad = "0") # convert to string and pad with zeros
names <- paste0("Elevation_DEMHF0p7M2013_RVT",s,".img")
URL <- "http://maps.vcgi.vermont.gov/gisdata/vcgi/lidar/0_7M/2013/DEMHF/"
dst <- choose.dir(default = "", caption = "Select folder to save files")
#loop for batch download
for (j in seq_along(names)){
  cat('downloading file: \n',names[j])
  fileurl <- paste0(URL,names[j])
  dstname <- paste(dst,names[j],sep="\\")
  download.2.disk(fileurl,dstname)
  cat('batch is %',(j/length(names))*100," complete \n")
}# end for loop for j along names
cat('congradulations batch download is complete!')
beepr::beep(sound='mario')

