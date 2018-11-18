library(maptools)  ## For wrld_simpl
library(raster)

## Example SpatialPolygonsDataFrame
data(wrld_simpl)
SPDF <- wrld_simpl[wrld_simpl$NAME==wrld_simpl$NAME[1:4]]
SPDF <- subset(wrld_simpl, NAME=="Brazil")
head(SPDF)
plot(SPDF)

## Example RasterLayer
r <- raster(nrow=1e3, ncol=1e3, crs=proj4string(SPDF))
r[] <- 1:length(r)

## crop and mask
r2 <- crop(r, extent(SPDF))
r3 <- mask(r2, SPDF)

## Check that it worked
plot(r3)
plot(SPDF, add=TRUE, lwd=2)
