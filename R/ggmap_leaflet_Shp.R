# Map NRCS wetland shape files
# Adrian Wiegman
# 20180425

# Useful documentation and links--------------------------------------------
# http://eriqande.github.io/rep-res-web/lectures/making-maps-with-R.html

# Preliminaries ---------------------------------------------------------
library(ggmap); theme_set(theme_classic()) # automatically loads ggplot
library(rgdal) # rgdal: geospatial data analysis library for R
# rgdal automatically loads sp which is used for plotting spatial information
#Cheat sheet for sp : http://rspatial.r-forge.r-project.org/gallery/
# `raster` package can also be used for metadata/attributes- vectors or rasters
library(foreign)

# B - BASEMAP: google satellite imagery----------------------------------------------------------------
# Get a raster object, overset it with a shapefile, and add GPS coordinates
# 1. Get the map of VT as a dataframe
basemap <- get_map("Salisbury,Vermont",zoom=8,maptype = "satellite",source="google")
# plot basemap with ggmap 
ggmap(basemap,extent = "normal")



# L1 - LAYER 1: vermont counties --------------------------------------------------------------------
# Using the read.dbf function which part of the "foreign" package.  Turn a data base file (.dbf) into a dataframe for ggplot.
dbf.1 <- read.dbf(file = 'ggmap/CountyBoundaries/VTCountyBoundaries.dbf')
meta.1 <- ogrInfo('ggmap/CountyBoundaries/VTCountyBoundaries.dbf')
# readOGR is from rgdal package--turns your data in a usable spatial vector object.
. <- readOGR(dsn = 'ggmap/CountyBoundaries/VTCountyBoundaries.dbf')
#plot(.)

# Reproject your data from one projection/ datum to another. Check your metadata.
. <- spTransform(., CRS("+proj=longlat +datum=WGS84"))
#fortify command (from the package ggplot2).  Converts spatial data into a data frame.
geodf.1 <- fortify(.)
str(geodf.1)


# Plot the shape file on raster object!
layer1 <- ggplot() + geom_path(data=geodf.1, 
            mapping = aes(x=long, y=lat, group=group), 
            size=.2, 
            color='yellow',
            alpha=0.5) + coord_fixed(ratio=1)
layer1

L1 <- "geom_path(data=geodf.1, 
                 mapping = aes(x=long, y=lat, group=group), 
                 size=.2, 
                 color='yellow',
                 alpha=0.5)"

# L2 - LAYER 2: NRCS wetland easements -------------------------------------------------

# Using the read.dbf function which part of the "foreign" package.  Turn a data base file (.dbf) into a dataframe for ggplot.
dbf.2 <- read.dbf(file = "C:/Users/Adria/Documents/UVM-research/LCB-Geospatial/NRCS-analysis/nrcs_wetland_easemts_041618.dbf")
# this reads everything but the polygon or geometry object 
head(dbf.2)
str(dbf.2)
meta.data
writeLines()
write.csv()
# store meta data on the file (this includes column names and projeciton information
meta.2 <- ogrInfo("C:/Users/Adria/Documents/UVM-research/LCB-Geospatial/NRCS-analysis/nrcs_wetland_easemts_041618.dbf")
cat('#',sep='\n')
. <- toString(meta.2)

# capture.output takes stores ecah line of console output in a vector 
. <- capture.output(meta.2)

. <- paste0(rep('#  ',length(.)),.)

. <- names(.)
# readOGR is from rgdal package--turns your data in a usable spatial vector object.
shp.2 <- readOGR(dsn = "C:/Users/Adria/Documents/UVM-research/LCB-Geospatial/NRCS-analysis/nrcs_wetland_easemts_041618.dbf")

# Reproject your data from one projection/ datum to another.
shp.2 <- spTransform(shp.2, CRS("+proj=longlat +datum=WGS84"))

#fortify command (from the package ggplot2).  Converts spatial data into a data frame.
#geodf.2 <- fortify(.)
require(stringr)

# Add additional metrics to the data attribute table 
shp.2@data$yr_rst <- as.numeric(str_extract(shp.2@data$NEST_C_CLO,'[:digit:]{4}'))

# add a colunmm called id and convert data into longform geometry
shp.2@data$id <- rownames(shp.2@data)
head(shp.2)
shp.2.points <- fortify(shp.2)
geodf.2 <- plyr::join(shp.2.points, shp.2@data, by="id")
str(geodf.2)
head(geodf.2)
tail(geodf.2)

# Plot the shape file on raster object!
layer2 <- ggplot() + geom_polygon(data=geodf.2,
                                  aes(x=long, y=lat, group=group),
                                  size=.1,
                                  color='black',
                                  alpha=0.3) + coord_fixed(ratio=1)

layer2 #+ scale_color_brewer(aes(fill=yr_rst, group=group),palette='OrRd')


# Save the geom_polygon function call in a string
L2 <- "geom_polygon(aes(x=long, y=lat, group=group), 
                   fill='green', size=.2, 
                   color='black', 
                   data=geodf.2, 
                   alpha=0.3)"

# ADD BASE MAP AND LAYERS ------------------------------------------
MAP <- ggmap(basemap) + eval(parse(text=L1)) + eval(parse(text=L2))

# PLOT MAP-----------------------------------------------------------
MAP
outpath = "C:/Users/Adria/Documents/UVM-research/LCB-Geospatial/NRCS-analysis/"
ggsave(paste0(outfile,"myMap",'.pdf'),device=pdf)

#zoom in with a bounding box
bbox <- c(left=-73.5,right=-72.75,top=44.0,bottom=43.5)
ggmap(get_map(location = bbox,maptype='satellite')) +
  eval(parse(text=L1)) + 
  eval(parse(text=L2)) +
  coord_fixed(ratio=1,xlim=bbox[1:2],ylim=bbox[3:4]) # ratio=1 locks aspect ratio
ggsave(paste0(outfile,"myZoomedMap",'.pdf'),device=pdf)


# MAKE LEAFLET MAP OF LAYERS -----------------------------------------
#https://rstudio.github.io/leaflet/
#http://leaflet-extras.github.io/leaflet-providers/preview/index.html
library("leaflet")
bbox <- c(left=-74.0,right=-72.5,top=45.0,bottom=42.5)
#Basic leaflet command with `pipe` %>% structure 
leaflet() %>% 
  setView(lng =-73.186164,lat=44.467857, zoom = 12) %>%
  addTiles() %>%
  addMarkers(lng =-73.186164,lat=44.467857,popup="UVM") 

leaflet(shp.2) %>%
  #addProviderTiles(providers$OpenStreetMap.DE) %>%
  addProviderTiles(providers$Esri.WorldImagery) %>%
  #addProviderTiles(providers$NASAGIBS.ModisTerraBands367CR) %>%
  setView(lng =-73.186164,lat=44.467857, zoom = 12) %>%
  #fitBounds(lng1=bbox[1], lat1=bbox[1], lng2=bbox[1], lat2=bbox[1]) %>%
  #addPolygons(data=geodf.1,weight=5,col = 'red') %>%
  addPolygons(weight=1, color = shp.2$yr_rst, popup=shp.2$id) %>%
  addMarkers(lng =-73.186164,lat=44.467857,popup="UVM")
#leaf

# myURL <- 'https://map1.vis.earthdata.nasa.gov/wmts-webmerc/MODIS_Terra_CorrectedReflectance_Bands367/default/{time}/{tilematrixset}{maxZoom}/{z}/{y}/{x}.{format}'
# myAtt <- 'Imagery provided by services from the Global Imagery Browse Services (GIBS), operated by the NASA/GSFC/Earth Science Data and Information System (<a href="https://earthdata.nasa.gov">ESDIS</a>) with funding provided by NASA/HQ.'
# bbox <- c(left=-74.0,right=-72.5,top=45.0,bottom=42.5)
# leaf <- leaflet() %>%
#   setView(lng =-73.186164,lat=44.467857, zoom = 12) %>%
#   addWMSTiles(baseUrl = myURL, layers = "ModisTerraBands367CR", attribution = myAtt) %>%
#   #fitBounds(lng1=bbox[1], lat1=bbox[1], lng2=bbox[1], lat2=bbox[1]) %>% 
#   addPolygons(data=geodf.1,weight=5,col = 'red') %>% 
#   #addPolygons(data=geodf.2,weight=5,col = 'blue') %>%
#   addMarkers(lng =-73.186164,lat=44.467857,popup="UVM") 
# leaf