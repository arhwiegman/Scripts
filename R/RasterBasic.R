# Raster Basics in R
# Adrian Wiegman

# PART 1
# http://neondataskills.org/R/Raster-Data-In-R/

# load raster, sp, and rgdal packages
library(raster)
library(rgdal)
library(sp)

# set working directory to where the data is
path <- "C:/Users/Adria/Documents/R/Projects/SpatialTools/ExampleSpatialData/SJER/DigitalTerrainModel"
setwd(path)
DEM <-raster("SJER2013_DTM.tif")

# look at the raster attributes
DEM

# calculate and save the min and max values of the raster to the raster object
DEM <- setMinMax(DEM)

# view raster attributes
DEM
# class       : RasterLayer 
# dimensions  : 5060, 4299, 21752940  (nrow, ncol, ncell)
# resolution  : 1, 1  (x, y)
# extent      : 254570, 258869, 4107302, 4112362  (xmin, xmax, ymin, ymax)
# coord. ref. : +proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
# data source : C:\Users\Adria\Documents\R\Projects\SpatialTools\ExampleSpatialData\SJER\DigitalTerrainModel\SJER2013_DTM.tif 
# names       : SJER2013_DTM 
# values      : 228.1, 518.66  (min, max)
#Get min and max cell values from raster
#NOTE: this code may fail if the raster is too large
cellStats(DEM, min)
## [1] 228.1
cellStats(DEM, max)
## [1] 518.66
cellStats(DEM, range)
## [1] 228.10 518.66
#view coordinate reference system
DEM@crs
## CRS arguments:
##  +proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84
## +towgs84=0,0,0

# view raster extent
DEM@extent

## class       : Extent 
## xmin        : 254570 
## xmax        : 258869 
## ymin        : 4107302 
## ymax        : 4112362

# the distribution of values in the raster
hist(DEM, main="Distribution of elevation values", 
     col= "purple", 
     maxpixels=22000000)

# plot the raster
# note that this raster represents a small region of the NEON SJER field site
plot(DEM, main="Digital Elevation Model, SJER") # add title with main

# create a plot of the raster, this command has many options
image(DEM)

# specify the range of values that you want to plot in the DEM
# just plot pixels between 250 and 300 m in elevation
image(DEM, zlim=c(250,300))

# add a color map with 5 colors
col=terrain.colors(5)

# add breaks to the colormap (6 breaks = 5 segments)
brk <- c(250, 300, 350, 400,450,500)

plot(DEM, col=col, breaks=brk, main="DEM with more breaks")

#BASIC RASTER MATH
#multiple each pixel in the raster by 2
DEM2 <- DEM * 2 

DEM2

#Cropping Rasters in R
plot(DEM)

#drawExtent() allows one to define extent of crop by clicking on the plot
#first click in upperleft corner
#then click on lower right corner
cropbox1 <- drawExtent()
#crop the raster, then plot the new cropped raster
DEMcrop1 <- crop(DEM, cropbox1)
plot(DEMcrop1)

#define the crop extent with a vector
#like a rectangular shapefile vector
cropbox2 <-c(255077.3,257158.6,4109614,4110934)
#crop the raster
DEMcrop2 <- crop(DEM, cropbox2)
#plot cropped DEM
plot(DEMcrop2)

#PART 2 
# http://neondataskills.org/GIS-spatial-data/Working-With-Rasters/

# create a raster from the matrix - a "blank" raster of 4x4
myRaster1 <- raster(nrow=4, ncol=4)

# assign "data" to raster: 1 to n based on the number of cells in the raster
myRaster1[]<- 1:ncell(myRaster1)

# view attributes of the raster
myRaster1

# is the CRS defined?
myRaster1@crs

# what is the raster extent?
myRaster1@extent

## class       : Extent 
## xmin        : -180 
## xmax        : 180 
## ymin        : -90 
## ymax        : 90

# plot raster
plot(myRaster1, main="Raster with 16 pixels")

## HIGHER RESOLUTION
# Create 32 pixel raster
myRaster2 <- raster(nrow=8, ncol=8)

# resample 16 pix raster with 32 pix raster
# use bilinear interpolation with our numeric data
myRaster2 <- resample(myRaster1, myRaster2, method='bilinear')

# notice new dimensions, resolution, & min/max 
myRaster2

## class       : RasterLayer 
## dimensions  : 8, 8, 64  (nrow, ncol, ncell)
## resolution  : 45, 22.5  (x, y)
## extent      : -180, 180, -90, 90  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0 
## data source : in memory
## names       : layer 
## values      : -0.25, 17.25  (min, max)

# plot 
plot(myRaster2, main="Raster with 32 pixels")

## LOWER RESOLUTION
myRaster3 <- raster(nrow=2, ncol=2)
myRaster3 <- resample(myRaster1, myRaster3, method='bilinear')
myRaster3

## class       : RasterLayer 
## dimensions  : 2, 2, 4  (nrow, ncol, ncell)
## resolution  : 180, 90  (x, y)
## extent      : -180, 180, -90, 90  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0 
## data source : in memory
## names       : layer 
## values      : 3.5, 13.5  (min, max)

plot(myRaster3, main="Raster with 4 pixels")

## SINGLE PIXEL RASTER
myRaster4 <- raster(nrow=1, ncol=1)
myRaster4 <- resample(myRaster1, myRaster4, method='bilinear')
myRaster4

## class       : RasterLayer 
## dimensions  : 1, 1, 1  (nrow, ncol, ncell)
## resolution  : 360, 180  (x, y)
## extent      : -180, 180, -90, 90  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0 
## data source : in memory
## names       : layer 
## values      : 7.666667, 7.666667  (min, max)

plot(myRaster4, main="Raster with 1 pixel")


#VIEW ALL PLOTS
# change graphical parameter to 2x2 grid
par(mfrow=c(2,2))

# arrange plots in order you wish to see them
plot(myRaster2, main="Raster with 32 pixels")
plot(myRaster1, main="Raster with 16 pixels")
plot(myRaster3, main="Raster with 4 pixels")
plot(myRaster4, main="Raster with 2 pixels")

#Coordinate Reference System & Projection Information
# http://spatialreference.org/ref/epsg/
# The rgdal package has all the common ESPG codes with proj4string built in. We can see them by creating an object of the function make_ESPG().
# make sure you loaded rgdal package at the top of your script

# create an object with all ESPG codes
epsg <- make_EPSG()

head(epsg, 5)

# Define the extent of new raster
# create the base matrix
newMatrix  <- (matrix(1:8, nrow = 10, ncol = 20))

# create a raster from the matrix
rasterNoProj <- raster(newMatrix)

rasterNoProj

## Define the xmin and y min (the lower left hand corner of the raster)

# 1. define xMin & yMin objects.
xMin = 254570
yMin = 4107302

# 2. grab the cols and rows for the raster using @ncols and @nrows
rasterNoProj@ncols
## [1] 20
rasterNoProj@nrows
## [1] 10

# 3. define the resolution
res <- 1.0 #1 meter

# 4. add the numbers of cols and rows to the x,y corner location, 
# result = we get the bounds of our raster extent. 
xMax <- xMin + (rasterNoProj@ncols * res)
yMax <- yMin + (rasterNoProj@nrows * res)

# 5.create a raster extent class
rasExt <- extent(xMin,xMax,yMin,yMax)
rasExt

# 6. apply the extent to our raster
rasterNoProj@extent <- rasExt
# Did it work? 
rasterNoProj
## class       : RasterLayer 
## dimensions  : 10, 20, 200  (nrow, ncol, ncell)
## resolution  : 1, 1  (x, y)
## extent      : 254570, 254590, 4107302, 4107312  (xmin, xmax, ymin, ymax)
## coord. ref. : NA 
## data source : in memory
## names       : layer 
## values      : 1, 8  (min, max)

# or view extent only
rasterNoProj@extent

par(mfrow=c(1,1))
# plot new raster
plot(rasterNoProj, main="Raster in UTM coordinates, 1 m resolution")

# Resample rasterNoProj from 1 meter to 10 meter resolution. Plot it next to the 1 m resolution raster.
# create the base matrix
newMatrix  <- (matrix(1:8, nrow = 10, ncol = 20))
# create a raster from the matrix
rasterNoProj <- raster(newMatrix)
rasterNoProj
rst1 <- rasterNoProj

for (i in 1:1){
  res <- i #10 meter 
  rst10 <- raster(nrow=rst1@nrows/res,ncol=rst1@ncols/res)
  rst10
  # resample with nearest neighbor method
  rst10ngb <- resample(rst1,rst10,method="ngb")
  # resample with bilinear method
  rst10bln <- resample(rst1,rst10,method="bilinear",filename="raster10m.tif")
  par(mfrow=c(1,3))
  plot(rst1,main="1m resolution raster")
  plot(rst10ngb,main="10m nearest neighbor method resample of 1m raster")
  plot(rst10bln,main="10m bilinear method resample of 1m raster")
}


# Define Projection of a Raster
# view CRS from raster of interest
rasterNoProj@crs

# view the CRS of our DEM object.
DEM@crs

## CRS arguments:
##  +proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84
## +towgs84=0,0,0

# define the CRS using a CRS of another raster
rasterNoProj@crs <- DEM@crs

# look at the attributes
rasterNoProj

## class       : RasterLayer 
## dimensions  : 10, 20, 200  (nrow, ncol, ncell)
## resolution  : 0.2, 0.4  (x, y)
## extent      : 254570, 254574, 4107302, 4107306  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
## data source : in memory
## names       : layer 
## values      : 1, 8  (min, max)

# view just the crs
rasterNoProj@crs

## CRS arguments:
##  +proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84
## +towgs84=0,0,0



#You can set the CRS and extent of a raster using the syntax 
#rasterWithoutReference@crs <- rasterWithReference@crs 
#rasterWithoutReference@extent <- rasterWithReference@extent. 
par(mfrow=c(1,1))
setwd("C:/Users/Adria/Documents/R/Projects/SpatialTools/ExampleSpatialData/SJER/RGB/")
colorband <- raster("band90.tif")
#does the color image extent line up with the DEM
colorband@extent == DEM@extent
colorband@extent # colorband extent not defined
# class       : Extent
# xmin        : 0
# xmax        : 1
# ymin        : 0
# ymax        : 1

# examine color images attribute
colorband
plot(colorband)
