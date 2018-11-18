# https://gis.stackexchange.com/questions/130522/increasing-speed-of-crop-mask-extract-raster-by-many-polygons-in-r
##########################################
# fasterRasterExtract
# extracts data from raster cliped from polygon 
#fasterRasterExtract <- function


# SOLUTION 1 -----------------------------
library(maptools)  ## For wrld_simpl
library(raster)
library(rgdal)
## Example SpatialPolygonsDataFrame
data(wrld_simpl) #polygon of world countries
spdf <- wrld_simpl[1:25,] #name it this to subset to 25 countries and because my loop is set up with that variable  
class(spdf)
str(spdf@polygons)
proj4string(spdf)
spdf
sp <- SpatialPolygons(spdf@polygons, proj4string=CRS(proj4string(spdf)))
## Example RasterLayer
c <- raster(nrow=2e3, ncol=2e3, crs=proj4string(wrld_simpl), xmn=-180, xmx=180, ymn=-90, ymx=90)
c[] <- 1:length(c)

#plot, so you can see it
plot(c)    
plot(bound, add=TRUE) 

result <- data.frame() #empty result dataframe 

system.time(
  for (i in 1:nrow(bound)) { #this is the number of polygons to iterate through
    cat("processing polygon ",i,"...","\n")
    . <- Sys.time()
    single <- spdf[i,] #selects a single polygon
    s <- sp[i,]
    clip1 <- crop(c, extent(single)) #crops the raster to the extent of the polygon, I do this first because it speeds the mask up
    cat("cropped ",i,"... time elapsed (s)",Sys.time()-.,"\n")
    
    . <- Sys.time()
    clip2 <- mask(clip1,single) #crops the raster to the polygon boundary
    cat("masked ",i,"... time elapsed (s)",Sys.time()-.,"\n")
    
    . <- Sys.time()
    ext <-extract(clip2,single) #extracts data from the raster based on the polygon bound
    cat("extracted ",i,"... time elapsed (s)",Sys.time()-.,"\n")
    
    . <- Sys.time()
    cl2 <-rasterize(spdf,clip1,mask=TRUE) #extracts data from the raster based on the polygon bound
    cat("rasterized ",i,"... time elapsed (s)",Sys.time()-.,"\n")
    
    . <- Sys.time()
    rst <-getValues(cl2)
    cat("getValues ",i,"... time elapsed (s)",Sys.time()-.,"\n")
    #tab <-lapply(ext,table) #makes a table of the extract output
    #s<-sum(tab[[1]])  #sums the table for percentage calculation
    #mat<- as.data.frame(tab) 
    #mat2<- as.data.frame(tab[[1]]/s) #calculates percent
    #final<-cbind(single@data$NAME,mat,mat2$Freq) #combines into single dataframe
    #result<-rbind(final,result)
  })

# user  system elapsed 
# 39.39    0.11   39.52 

# OPTION 2 -----------------------------------------
#initiate multicore cluster and load packages
library(foreach)
library(doParallel)
library(tcltk)
library(sp)
library(raster)

cores<- detectCores() - 1
cl <- makeCluster(cores, output="") #output should make it spit errors
registerDoParallel(cl)
###################################################
# multicore.tabulate.intersect
# 
multicore.tabulate.intersect<- function(cores, polygonlist, rasterlayer){ 
  foreach(i=1:cores, .packages= c("raster","tcltk","foreach"), .combine = rbind) %dopar% {
    
    mypb <- tkProgressBar(title = "R progress bar", label = "", min = 0, max = length(polygonlist[[i]]), initial = 0, width = 300) 
    
    foreach(j = 1:length(polygonlist[[i]]), .combine = rbind) %do% {
      final<-data.frame()
      tryCatch({ #not sure if this is necessary now that I'm using foreach, but it is useful for loops.
        
        single <- polygonlist[[i]][j,] #pull out individual polygon to be tabulated
        
        dir.create (file.path("c:/rtemp",i,j,single@data$OWNER), showWarnings = FALSE) #creates unique filepath for temp directory
        rasterOptions(tmpdir=file.path("c:/rtemp",i,j, single@data$OWNER))  #sets temp directory - this is important b/c it can fill up a hard drive if you're doing a lot of polygons
        
        clip1 <- crop(rasterlayer, extent(single)) #crop to extent of polygon
        clip2 <- rasterize(single, clip1, mask=TRUE) #crops to polygon edge & converts to raster
        ext <- getValues(clip2) #much faster than extract
        tab<-table(ext) #tabulates the values of the raster in the polygon
        
        mat<- as.data.frame(tab)
        final<-cbind(single@data$OWNER,mat) #combines it with the name of the polygon
        unlink(file.path("c:/rtemp",i,j,single@data$OWNER), recursive = TRUE,force = TRUE) #delete temporary files
        setTkProgressBar(mypb, j, title = "number complete", label = j)
        
      }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")}) #trycatch error so it doesn't kill the loop
      
      return(final)
    }  
    #close(mypb) #not sure why but closing the pb while operating causes it to return an empty final dataset... dunno why. 
  }
}


