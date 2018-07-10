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
#Specify the url for desired website to be scrapped
urls <- ask.4.URL.popbox()
print(urls)
# http://maps.vcgi.vermont.gov/gisdata/vcgi
# http://maps.vcgi.vermont.gov/gisdata/vcgi/lidar/0_7M/2013/DEMHF/
#next step is to download lidar from bbox
#https://nrcs.app.box.com/v/elevation/folder/37789008189

#Specify the destination folders of downloaded data
# dst <- c('D:/GISdata/VTgeodata/NAIP/2016/',
#          'D:/GISdata/VTgeodata/NAIP/2014/',
#          'D:/GISdata/VTgeodata/NAIP/2011/')
# remove forward slashes

# MAIN PROGRAM -----------------------------
#Read the HTML code from the website

for (URL in urls){
  webpage <- read_html(URL)
  print(webpage)
  dst <- choose.dir(default = "", caption = "Select folder to save files")
  if(!dir.exists(dst)) dir.create(dst)
# select text elements for file paths using function %>% pipes
  files <- webpage %>%
    html_nodes("a") %>%   # find all links <a </a>
    html_attr("href") %>% # get the url
    str_extract("^.*\\.img$") %>% # inlcude only thoese ending with file extension '.jp2' '.img' or '.*' for all files
    unlist %>% # convert results to vector form
    na.omit # omit na values
  
# look at head of files vector
  head(files)
  files <- str_sub(files,2) # remove first '/'
  names <- str_extract(files,"[^/]+$") %>% unlist # extract only the file name 
  head(names)

#loop for batch download
  for (j in seq_along(files)){
    cat('downloading file: \n',files[j])
    fileurl <- paste0(URL,names[j])
    dstname <- paste(dst,names[j],sep="\\")
    download.2.disk(fileurl,dstname)
    cat('batch is %',(j/length(files))*100," complete \n")
  }# end for loop for j along files
Yes.2.continue.popbox()
}# end URL loop
cat('congradulations batch download is complete!')
beepr::beep(sound='mario')
