# Create polygon from xy coordinate matrix
library(sp)
xym <- cbind(runif(10)*20,runif(10)*-50)
p = Polygon(xym)
ps = Polygons(list(p),1)
sps = SpatialPolygons(list(ps))
df <- data.frame(Value=99,Categ="value")
spdf <- SpatialPolygonsDataFrame(sps,df,crs=)
spdf

# read and write shapefiles with OGR
require(rgdal)
writeOGR(spdf, layer = 'testpolys', 'C:/tmp', driver="ESRI Shapefile")


#read a shapefile 
shp = 'C:/tmp/testpolys.shp'
myshp = readOGR(shp, layer = basename(strsplit(shp, "\\.")[[1]])[1])

# Read shapefile attributes
df = data.frame(myshp)

# require(rgeos)
# # Simplify geometry using rgeos
# simplified <- gSimplify(myshp, tol = 1000, topologyPreserve=FALSE)

# Create a spatial polygon data frame (includes shp attributes)
spdf = SpatialPolygonsDataFrame(myshp, df)
