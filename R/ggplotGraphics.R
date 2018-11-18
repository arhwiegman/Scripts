#ggplotGraphics
library(ggplot2); theme_set(theme_classic())
library(patchwork)
library(TeachingDemos)
char2seed("10th Avenue Freeze-Out")
d <- mpg # use built in mpg data frame
str(d)

g1 <- ggplot(data=d,
             mapping=aes(x=displ,y=cty)) + geom_point() + geom_smooth(method='lm')
g1
#
g2 <- ggplot(data=d,
             mapping=aes(x=drv,y=hwy,fill=I('cyan'))) + geom_boxplot()
print(g2)

#
g3 <- ggplot(data=d,
             mapping=aes(x=displ,fill=I('royalblue'),color=I('black'))) + geom_histogram()
print(g3)

g4 <- ggplot(data=d, mapping=aes(x=fl,y=cty,fill=fl))+geom_boxplot()+theme(legend.position='none')
print(g4)

# patchwork for awesome multipanel graphs

# place two plots together side by side
g1 + g2 

# place 3 plots vetically
g1 + g2 + g3 + plot_layout(ncol=1)

# change relative area of each plot
g1 + g2 + plot_layout(ncol=1,heights=c(2,1))

# change relative area of each plot
g1 + g2 + plot_layout(ncol=2,widths=c(2,1))

# add a space plot (under construction)
g3 + plot_spacer() + g4
g3 + (plot_spacer()+theme_classic()) + g4

#set up nested plots
g1 + {
  g2 + {
    g3 + 
      g4 + 
      plot_layout(ncol=1)
  }
} + plot_layout(ncol=1)

# operator to subtract placement 
# places g1 and g2 over g3
g1 + g2 - g3 + plot_layout(ncol=1)

# / | for intuitive layouts
(g1|g2|g3)/g4

(g1|g2)/(g3|g4)

# swap axis orientation

g3a <- g3 + scale_x_reverse()
g3b <- g3 + scale_y_reverse()
g3c <- g3 + scale_x_reverse() + scale_y_reverse()

(g3|g3a)/(g3b|g3c)

# switch orientation of coordinates

(g3 + coord_flip() | g3a + coord_flip())/
  (g3b + coord_flip() | g3c + coord_flip())

# ggsave for creating and saving plots
ggsave(filename="myplot.pdf",plot=g3, device="pdf",width=20,height=20,units='cm', dpi =300)
# produces raster outputs

# mapping of variables to aesthetics

m1 <- ggplot(data=mpg,
             mapping=aes(x=displ,y=cty,color=class)) + geom_point() + theme_classic()
print(m1)
#ggplot has about 30 geoms 

#limited to six shapes
m2 <- ggplot(data=mpg,
             mapping=aes(x=displ,y=cty,shape=class)) + geom_point() + theme_classic()
print(m2)


#map a discrete variable to point size
m3 <- ggplot(data=mpg,
             mapping=aes(x=displ,y=cty,size=class)) + geom_point() + theme_classic()
print(m3)

#map a continuous variable to point size
m3 <- ggplot(data=mpg,
             mapping=aes(x=displ,y=cty,size=hwy)) + geom_point() + theme_classic()
print(m3)

#map a continuous variable to color
m3 <- ggplot(data=mpg,
             mapping=aes(x=displ,y=cty,color=hwy)) + geom_point() + theme_dark()
print(m3)

#map two variables to two different aesthetics
m3 <- ggplot(data=mpg,
             mapping=aes(x=displ,y=cty,shape=class,color=hwy)) + geom_point() + theme_grey()
print(m3)

#map three variables to three different aesthetics
m3 <- ggplot(data=mpg,
             mapping=aes(x=displ,y=cty,shape=drv,color=fl,size=hwy)) + geom_point() + theme_grey()
print(m3)

#mapping a varaible to the same aesthetic for two different geoms
m1 <- ggplot(data=mpg,
             mapping=aes(x=displ,y=cty,color=drv)) + geom_point() + geom_smooth(method='lm') + theme_classic()
print(m1)


# faceting for excellent visualization in a set of related plots
# ggplot makes this easy to 
m1 <- ggplot(data=mpg, mapping=aes(x=displ,y=cty)) + 
  geom_point() + theme_bw()
m1 + facet_grid(class~fl) #subsets data 
# this allows for direct comparison accross elements
m1 + facet_grid(class~fl,scales="free_y")
m1 + facet_grid(class~fl,scales="free") #maximizes spread of data
#facet on a single variable
m1 + facet_grid(.~class,scales="free")
#facet on a single variable
m1 + facet_grid(class~.,scales="free")

#facet wrap for unorderd graphs
m1 + facet_wrap(~class)

#combine variables in a facet wrap
m1 + facet_wrap(~class + fl) + theme_classic()
#throws out empty combinations as default

#combine variables in a facet wrap
m1 + facet_wrap(~class + fl,drop=FALSE) + theme_classic()
#includes empty combinations

#use facet incombination with aesthetics
m1 <- ggplot(data=mpg,mapping=aes(x=displ,y=cty,color=drv))+geom_smooth(method='lm')
m1 + facet_grid(.~class)

#fitting a boxplots over a continuous variable 
m1 <- ggplot(data=mpg,mapping=aes(x=displ,y=cty,group=drv,fill=drv))+geom_boxplot()
m1 + facet_grid(.~class)








