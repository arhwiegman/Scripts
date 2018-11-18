#Advanced features of ggplot2
library(ggplot2)
library(patchwork)
library(TeachingDemos)
char2seed("Sienna")
d <- mpg

#standard plot with all of data but data grouped
p1 <- ggplot(data=d,mapping=aes(x=displ,y=hwy,group=drv))+
  geom_point() + geom_smooth()
print(p1)

#standard plot with all of data but data mapped to color
p1 <- ggplot(data=d,mapping=aes(x=displ,y=hwy,color=drv))+
  geom_point() + geom_smooth()
#color maps to points and lines but not confidence bar
print(p1)

# map to fill for confidence interval
p1 <- ggplot(data=d,mapping=aes(x=displ,y=hwy,fill=drv))+
  geom_point() + geom_smooth()
#fill maps to only confidence bar
print(p1)

# map to fill for confidence interval
p1 <- ggplot(data=d,mapping=aes(x=displ,y=hwy,fill=drv,color=drv))+
  geom_point() + geom_smooth()
#fill maps to only confidence bar
print(p1)


#calling aesthetics within each group to override defaults

#subset data to get one group shown 
p1 <- ggplot(data=d,mapping=aes(x=displ,y=hwy,fill=drv))+
  geom_point(data=d[d$drv=='4',],color='black',pch=21,size=3) + geom_smooth()
#subseting dataframe on the drive variable for all values equal to 4
#fill maps to only confidence bar
#pch changes the type of shape, 21-25 are shapes with outlines
print(p1)

#set a new mapping on the point
p1 <- ggplot(data=d,mapping=aes(x=displ,y=hwy))+
  geom_point(mapping=aes(color=drv)) + geom_smooth()
print(p1)

#set a new mapping on smooth
p1 <- ggplot(data=d,mapping=aes(x=displ,y=hwy))+
  geom_point() + geom_smooth(mapping=aes(color=drv))
print(p1)

# subest in first layer to eliminate some data entirely
p1 <- ggplot(data=d[d$drv!="4",],mapping=aes(x=displ,y=hwy))+
  geom_point(mapping=aes(color=drv)) + geom_smooth()
print(p1)

#attributes that can be set in addition to any aesthetics
# subest in first layer to eliminate some data entirely
p1 <- ggplot(data=d[d$drv!="4",],mapping=aes(x=displ,y=hwy))+
  geom_point(mapping=aes(color=drv)) + geom_smooth(color="black",size=1,fill="steelblue",method="lm")
print(p1)


#BAR PLOTS

#attributes that can be set in addition to any aesthetics
# subest in first layer to eliminate some data entirely
table(d$drv) #prints nrow for each category in d
p1 <- ggplot(data=d,mapping=aes(x=drv))+
  geom_bar(color="black",fill="goldenrod")
print(p1)

#each geom has a default stat associated with it
#stat_count is equivalent to geom_bar
table(d$drv) #prints nrow for each category in d
p1 <- ggplot(data=d,mapping=aes(x=drv))+
  stat_count(color="black",fill="goldenrod")
print(p1)

#specify y variable to calculate proportion
p1 <- ggplot(data=d,mapping=aes(x=drv,y=..prop..,group=1))+
  stat_count(color="black",fill="goldenrod")
print(p1)

#display multiple groups of bars
p1 <- ggplot(data=d,mapping=aes(x=drv,fill=fl))+
  geom_bar()
print(p1)

#unstack bars
p1 <- ggplot(data=d,mapping=aes(x=drv,fill=fl))+
  geom_bar(position="identity")
print(p1)

#VERY USEFUL FOR HISTOGRAMS
#make change transparency alpha
p1 <- ggplot(data=d,mapping=aes(x=drv,fill=fl))+
  geom_bar(alpha=1/2,position="identity")

#make transparent alpha
p1 <- ggplot(data=d,mapping=aes(x=drv,color=fl))+
  geom_bar(fill=NA,position="identity")
print(p1)

# position the data on the fill color
p1 <- ggplot(data=d,mapping=aes(x=drv,fill=fl))+
  geom_bar(position="fill")
print(p1)

# position equals dodge creates multiple bars
p1 <- ggplot(data=d,mapping=aes(x=drv,fill=fl))+
  geom_bar(position="dodge",color='black')
print(p1)

#more typical 'bar plot for mean values of a continuous variable

dTiny <- tapply(X=d$hwy,INDEX=as.factor(d$fl),FUN=mean)
#calculate group means
#takes the mean highway mileage for each fuel type
dTiny <- data.frame(hwy=dTiny)
dTiny <- cbind(fl=row.names(dTiny),dTiny)

p2 <- ggplot(data=dTiny,mapping=aes(x=fl,y=hwy,fill=fl))+geom_bar(stat="identity")
print(p2)

#use the stats geom to create the classic bar plot
p1 <- ggplot(data=d,mapping=aes(x=fl,y=hwy))+stat_summary(fun.y=mean,fun.ymin=function(x)mean(x)-sd(x),fun.ymax=function(x)mean(x)+sd(x))
p1


#now put them together
p1 <- ggplot(data=d,mapping=aes(x=fl,y=hwy))+stat_summary(fun.y=mean,fun.ymin=function(x)mean(x)-sd(x),fun.ymax=function(x)mean(x)+sd(x)) + geom_bar(data=dTiny,mapping=aes(x=fl,fill=fl),stat=identity)


#JUST USE A DAMN BOXPLOT
#boxplot
p1 <- ggplot(data=d,mapping=aes(x=fl,y=hwy,fill=fl))+geom_boxplot()
print(p1)

#boxplot with data overlaid
p1 <- ggplot(data=d,mapping=aes(x=fl,y=hwy))+geom_boxplot(fill="thistle")+geom_point(position="jitter",color="grey60")
print(p1)

#jitter on height
p1 <- ggplot(data=d,mapping=aes(x=fl,y=hwy))+geom_boxplot(fill="thistle")+geom_point(position=position_jitter(width=0,height=0.7),color="grey60")
print(p1)

p1 <- ggplot(data=d,mapping=aes(x=fl,y=hwy))+geom_boxplot(fill="thistle")+geom_point(position=position_jitter(width=0.2),color="grey60")
print(p1)

#outliers are separate elements. 






