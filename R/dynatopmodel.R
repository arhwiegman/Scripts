##############################################
# elev.2.uca.twi
# returns raster containing three layers
# 1 elevation, 2 upslope contributing area 3 topographic wetness index
# input:
# z <- a 1 layer raster::RasterLayer DEM with rectangular grid cells
# recommended size is less than 100mb
elev.2.uca.twi <- function(z=NULL){
  require(dynatopmodel)
  if (is.null(z)){
    data('brompton')
    z <- brompton$dem}
    layers <- build_layers(z)
    sp::plot(layers,main=c("Elevation AMSL (m)", "Upslope Area log(m^2)", "Topographic Wetness Index"))
    return(layers)
}
elev.2.uca.twi()



