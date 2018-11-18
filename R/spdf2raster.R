#################################################
# spdf.2.raster
# converts sp spatial dataframe to raster of same extent
# input: spdf - spatial points,lines,polygon dataframe 
#        rsl - cell resolution in meters
# ------------------------------------------------ 
spdf.2.raster <- function(spdf=NULL,rsl=10,graph=TRUE){
  require(raster)
  # DEFAULTS
  if(is.null(spdf)){
    # formal spatial dataframe object
    library(maptools)  ## For wrld_simpl
    data(wrld_simpl)
    spdf <- subset(wrld_simpl, NAME==c("Brazil","Argentina"))
  }
  . <- raster() # create empty raster
  extent(.) <- extent(spdf) # set extent equal to spdf
  res(.) <- rsl # set resolution
  . <- rasterize(spdf,.)
  if(graph==TRUE){
    plot(spdf)
    plot(.,add=TRUE)}
  return(.) # return raster
}
system.time(spdf.2.raster(rsl=0.5))
spdf.2.raster(rsl=10)

#################################################
# sfo.2.raster
# converts sf simple feature object to raster of same extent
# uses fasterize written in rcpp and is 10-100x faster than
# the function above
# input: sfo - spatial feature object
#        rsl - cell resolution in meters
# ------------------------------------------------ 
sfo.2.raster <- function(sfo=NULL,rsl=10,graph=TRUE){
  require(fasterize)
  require(sf)
  # DEFAULTS
  if(is.null(sfo)){
    # formal spatial dataframe object
    library(maptools)  ## For wrld_simpl
    data(wrld_simpl)
    spdf <- subset(wrld_simpl, NAME==c("Brazil","Argentina"))
    sfo <- st_as_sf(spdf)
  }
  . <- raster() # create empty raster
  extent(.) <- extent(sfo) # set extent equal to spdf
  res(.) <- rsl # set resolution
  . <- fasterize(sf,.)
  if(graph==TRUE){
    plot(sfo$geometry)
    plot(.,add=TRUE)}
  return(.) # return raster
}
system.time(sfo.2.raster(rsl=0.5)) # 10-100x faster than spdf.2.raster
sfo.2.raster(rsl=10)
st_read