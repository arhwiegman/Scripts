require(raster)
require(rgdal)
data(
r <- raster('dem.tif')
lines <- readOGR(dsn='lines.shp', layer='lines')

elevations <- extract(r, lines)