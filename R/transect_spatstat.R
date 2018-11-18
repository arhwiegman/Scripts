# https://stat.ethz.ch/pipermail/r-sig-geo/2009-February/005033.html
# [R-sig-Geo] Generating Random Transects of Same Length
library(spatstat)
# Define polygon, length of transect and number of (points)transects
data(letterR)
mywindow <- letterR
ltransect <- 0.3 #length of transect
npoints <- 10
s <- 1:npoints
# Generate random points from origin
RP <- runifpoint(npoints, win=mywindow)
plot(RP)
# save points to dataframe
RPxy <- data.frame(RP$x,RP$y)

# compute circle around points w/ radius = transect length 
RPdisc <- apply(RPxy,1, function(x) disc(r=ltransect, x))

# test if points are inside polygon boundary 
RPdisc.df <- lapply(RPdisc, function(W){
  inside.owin(W$bdry[[1]]$x,W$bdry[[1]]$y 
              ,w=mywindow)})

#function to sample circle points within window
sampleRP <- function(DFxy=NULL,# dataframe of x and y points
                     l1=NULL,
                     l2=NULL){
  result <- c(0,0)
  for (i in seq_along(l1)){
    truinside <-sum(l2[[i]])
    # inefficient code structure cbind and rbind inside for loop
    inside <- cbind(l1[[i]]$bdry[[1]]$x,l1[[i]]$bdry[[1]]$y)[l2[[i]],]
    result <-rbind(result,  inside[sample(1:truinside, size=1),])
  }
  result<-result[-1,]
  result<-cbind(DFxy,result)
  return(result)
}
sampleRP(DFxy=RPxy,l1=RPdisc,l2=RPdisc.df)

#the result is a matrix with x0,y0, x1, y1 for each transect
#Plot the random transects:
segments <-sampleRP(DFxy=RPxy,l1=RPdisc,l2=RPdisc.df)
segments(segments[,1][s], segments[,2][s],segments[,3][s], segments[,4][s])
