library(ggplot2)
p1<-qplot(runif(100))
p1
p2<-qplot(rnorm(100))
p2
library(patchwork)
p1 + p2
