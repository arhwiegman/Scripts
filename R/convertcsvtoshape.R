Mydata = read.csv(file = "points_xy.csv",header = TRUE, sep = ",")
coordinates(Mydata) <- ~X + Y
class(Mydata)
View(Mydata)
#raster 
require(raster)
projection(Mydata) = "+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
+towgs84=0,0,0"
shapefile(Mydata, "LCBP_sites.shp", overwrite=TRUE)
#sp and rgdal
proj4string(Mydata) = crs("+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs 
                    +ellps=WGS84 +towgs84=0,0,0")
writeOGR(Mydata, ".","data", "ESRI Shapefile")
plot(Mydata)
extent(Mydata)

#http://www.datacarpentry.org/R-spatial-raster-vector-lesson/10-vector-csv-to-shapefile-in-r/
utm18nCRS <- st_crs("+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs 
                    +ellps=WGS84 +towgs84=0,0,0")
shapedata <- st_as_sf(data,coords = c("X","Y"), crs=utm18nCRS)
st_crs(shapedata)
View(shapedata)
plot(shapedata$geometry,
     main = "Map of Plot Locations")