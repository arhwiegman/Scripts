# read line by line and break after EOF record
require(readr)

#PREPARE MATRIX OF FAKE DATA
m <- matrix("site1 , data",nrow=17)
m2 <- matrix("site2 , data",nrow=18)
f <- "dump.csv"
write("header,header",f,append=FALSE)
write(m,f,append=TRUE)
write("",f,append=TRUE) #blank line
write(m2,f,append=TRUE)

j <- 0
linecount <- 0
c <- "*"
EOF = 0
repeat {
  dataline <- read_lines(filenames[i],
                         n_max = chunk,
                         skip=count)
  j <- j + chunk
  k <- 0
  repeat {
    k <- k + 1
    linecount <- linecount + 1
    print(c(linecount,k))
    
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
      newfilepath <- "dump2.txt"
      c <- ID
      #newfilepath = paste0(outPath,c,fname)
      write(header,newfilepath,append = FALSE)
    } # end if column
    write(dataline,newfilepath,append = TRUE)
    
    if (k==length(dataline)) break("Completed reading chunk")
  } # end repeat
  if (EOF==1) break #if End of File record detected end repeat
}# end repeat

