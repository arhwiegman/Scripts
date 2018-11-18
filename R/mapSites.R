#Map Data
#SET WORKING DIRECTORY AND OPEN FILES
wdPath <- "C:/users/adria/documents/R/Projects/CRMS/"
setwd(wdPath)
inPath <- paste0(wdPath,"data/")
dir(inPath)
outPath <- paste0(wdPath,"data_site/")
dir.exists(outPath)
datatype <- "Continuous_Hydrographic"
ext <- ".csv"
require(readr)

#IMPORT X Y coordinates for each site
site_coords <- read_csv(paste0(inPath,"SiteCoordinates",ext),comment ="#")
df <- data.frame(X=site_coords$si_Long,
                     Y=site_coords$si_Lat,
                     value=site_coords$CRMS_Site)
#raster
require(raster)
coordinates(df) <- ~X+Y
class(df)
View(df)
projection(df) = "+proj=utm +zone=15 +datum=WGS84 +units=m +no_defs +ellps=WGS84
+towgs84=0,0,0"
require(rgdal)
ogrDrivers() #pick an ogr driver e.g. shape file  and set file extention and driver 
shapefile(df, "CRMS_sites.shp", overwrite=TRUE)
#sp and rgdal
proj4string(df) = crs("+proj=utm +zone=15 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")
writeOGR(df, ".","data", driver="ESRI Shapefile")
plot(df)
extent(df)

#plot points onto map with ggmap
require(ggmap)
# https://www.google.com/maps/@29.7065974,-91.3660381,8.5z
CoastalLouisiana <- get_map(location = c(lon = -91.4668734, lat = 30.0183171),
        color = "color",
        source = "google",
        maptype = "satellite",
        zoom = 7)

map <- ggmap(CoastalLouisiana,
             extent="panel",
             ylab = "Latitude",
             xlab = "Longitude")+
  geom_point(data=site_coords,aes(x=si_Long,y=si_Lat))
map 
#http://www.datacarpentry.org/R-spatial-raster-vector-lesson/10-vector-csv-to-shapefile-in-r/
utm18nCRS <- st_crs("+proj=utm +zone=15 +datum=WGS84 +units=m +no_defs 
                    +ellps=WGS84 +towgs84=0,0,0")
shapedata <- st_as_sf(df,coords = c("X","Y"), crs=utm18nCRS)
st_crs(shapedata)
View(shapedata)
plot(shapedata$geometry,
     main = "Map of Plot Locations")
