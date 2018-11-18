# gridExtra
# for nice tables
# 20180426

library(ggplot2)
install.packages('gridExtra')
library(gridExtra)
library(gtable)
library(lattice)
library(gtable)

# Make a dataset
myData <- matrix(1:15,
                 nrow=5,
                 ncol=3)
colnames(myData) <- c("Group A", "Group B", "Group C")
rownames(myData) <- c('a','b','c','d','e')
print(myData)

# quick plot 
grid.table(myData)

# line breaks and cells with allot of contents
myData[3,2] <- "writing a lot inside the cell"
myData[2,1] <- "Use \n line \n breaks"
grid.table(myData)

# you can use latex inside of boxes

# Premade themes
Tdef <- ttheme_default()
Tmin <- ttheme_minimal()

# Build your own theme by changing options for minimal theme
Tspec <- ttheme_minimal(
  core=list(bg_params=list(fill=blues9[1:4],col=NA),
            fg_params=list(fontface=3)),
  colhead=list(fg_params=list(col='olivedrab',fontface=4L)),
  rowhead=list(fg_params=list(col='orangered4',fontface=3L)))

#Compare different themes for 1 dataset
grid.arrange(tableGrob(myData[1:5,1:3],theme=Tdef),
             tableGrob(myData[1:5,1:3],theme=Tmin),
             tableGrob(myData[1:5,1:3],theme=Tspec), nrow=2)

p <- qplot(0,0)
p2 <- plot(1~1)
r <- rectGrob(gp=gpar(fill='white'))
t <- tableGrob(myData[1:3,1:2], theme=Tspec)
grid.arrange(p,p2,r,t, ncol=2)


g <- lapply(1:11, function(i) grobTree(rectGrob(gp=gpar(fill=i,alpha=0.5)), textGrob))
pattern <- rbind(c(1,1,2,2,3),
                 c(1,1,2,2,4),
                 c(1,1,5,5,6),
                 c(7,8,9,10,11))
grid.arrange(grobs=g, layout_matrix=pattern)

# putting boarders on your table
g <- tableGrob(myData[1:5,1:3],
               rows=NULL)#remove row labels
g <- gtable_add_grob(g,
                     grobs=rectGrob(gp=gpar(fill=NA, lwb=2)),
                     t=2, b=nrow(g), l=1, r=ncol(g))
g <- gtable_add_grob(g,
                     grobs=rectGrob(gp=gpar(fill=NA, lwb=2)),
                     t=1, l=1, r=ncol(g))


                                  