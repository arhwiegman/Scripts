# plotCrossSection
library(raster)
library(rgdal)

writeOGR(
# create array of xy coordinates
P1 <- cbind(c(-100, -90, -70), c(60 ,80, 90))
P2 <- cbind(c(-10,-40,-60),runif(3)*100)
# convert to sp::Line class objects
L1 <- Line(P1)
L2 <- Line(P2)
# create list of Lines
myLines <- list(Lines(list(L1,L2),ID="Transect"))
# define projection 
crs <- sp::CRS("+init=epsg:4326")

# turn list of lines into 
transect <- sp::SpatialLines(myLines, proj4string = crs)

# create empty 1 band raster and specify x y location
r <- raster(nrows = 10, ncols = 10, ymn = -80, ymx = 80, crs = crs)
# name the raster band 1
names(r)[1] <- "band 1 value"

# fill transect with random data
set.seed(0)
r[] <- runif(ncell(r))
r[4, 6] <- NA # insert a missing value

# plot the raster 
plot(r, xlab = "x", ylab = "y")

# plot transect (SpatialLInes object)
lines(transect)
# put red points on the plot
points(rbind(P1,P2), pch = 21, bg = "red")

# see ?raster::extract 
seg1 <- spLines(r,P1,crs=crs)
seg2 <- extract(r,P2,crs=crs)
for (i in seq_along(segs)) points(segs[[i]], col = "blue")
dev.new()
xlab <- "Distance along transect"
ylab <- "Raster value"
xlim <- range(vapply(segs, function(seg) range(seg@data[, "dist"]), c(0, 0)))
ylim <- range(vapply(segs, function(seg) range(seg@data[, "value"], na.rm = TRUE),
                     c(0, 0)))
plot(NA, type = "n", xlab = xlab, ylab = ylab, xlim = xlim, ylim = ylim)
for (i in 1:length(segs))
  lines(segs[[i]]@data[, c("dist", "value")], col = rainbow(length(segs))[i])
coords <- sp::coordinates(transect)
n <- length(transect)
d <- cumsum(c(0, as.matrix(dist((coords)))[cbind(1:(n - 1), 2:n)]))
abline(v = d, col = "grey", lty = 2)
mtext(paste0("(", paste(head(coords, 1), collapse = ", "), ")"), adj = 0)
mtext(paste0("(", paste(tail(coords, 1), collapse = ", "), ")"), adj = 1)