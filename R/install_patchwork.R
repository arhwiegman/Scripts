#this script installs patchwork
#https://github.com/thomasp85/patchwork
#patchwork is a simple package for making figure pannels w/ ggplot

install.packages("devtools")
library(devtools)
install_github("thomasp85/patchwork")

#Examples of patchwork 
p1 <- ggplot(mtcars) + geom_point(aes(mpg, disp))
p2 <- ggplot(mtcars) + geom_boxplot(aes(gear, disp, group = gear))

p1 + p2

p3 <- ggplot(mtcars) + geom_smooth(aes(disp, qsec))
p4 <- ggplot(mtcars) + geom_bar(aes(carb))

p4 + {
  p1 + {
    p2 +
      p3 +
      plot_layout(ncol = 1)
  }
} +
  plot_layout(ncol = 1)
