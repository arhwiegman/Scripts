# using color in R graphics
# 20180417
# Adrian Wiegman

#load libraries
library(ggplot2); theme_set(theme_classic())
library(ggthemes)
library(wesanderson)
library(TeachingDemos)
char2seed("short capo")

d <- mpg
p1 <- ggplot(data=d,
             mapping=aes(x=fl,y=hwy,group=fl))
p1 + geom_boxplot()

p1 + geom_boxplot(fill='red')
#color doesnt add any value here

myColors <- c('red','green','pink','blue','orange')

p1 + geom_boxplot(fill=myColors)
myGray <- gray(0.7)

p1 + geom_boxplot(fill=myGray)
print(myGray)
#B3B3B3
#hexidecimal 0 1 2 3 4 5 6 7 8 9 A B C D E F  
# representation of a color RGB 256 levels of saturation options color
# we have non linear perception of RGB 
. <- col2rgb('red')
print(.)
. <- ./255 #make red a fractional scale
. <- rgb(t(.)) #turns 0-1 into hexadecimal
print(.) 

. <- col2rgb('red')
. <- ./255
. <- rgb(t(.),alpha = 0.5) #alpha controls transparency
myPaleRed <- . 
p1 + geom_boxplot(fill=myPaleRed)

#change saturation of grey function in sequence  
p1 + geom_boxplot(fill=gray(seq(from=0.1, to=0.9,length=5)))

# make a dataframe with control and treatment factors
x1 <- rnorm(n=100, mean=0)
x2 <- rnorm(n=100,mean=3)
df <- data.frame(v1=c(x1,x2))
lab <- rep(c("cntrl","trtmt"),each=100)
df <- cbind (df,lab)
str(df)

h1 <- ggplot(data=df,
             mapping=aes(x=v1,fill=lab))
h1 + geom_histogram(position='identity',#must specify position to prevent overlap
                    color='black', #outline 
                    alpha=0.5) # transparency

#color pallets
#ggthemes::
canva_pal() 
#wesanderson::
wes_palettes() #

p1 + geom_boxplot(fill=wes_palettes[['Royal2']])


p1 + geom_boxplot(fill=c(gray(0.5),canva_palettes[[1]]))

#alternative mapping to manually override default colors
p2 <- ggplot(data=d, mapping=aes(x=fl,y=hwy,fill=fl)) + geom_boxplot() + 
  scale_fill_manual(values=wes_palettes[["Darjeeling"]])
print(p2)

#great resource for color pallets with hexdecimal codes
#colorbrewer2.org

p1 + geom_boxplot() + scale_fill_brewer(palette="Blues")

p3 <- ggplot(data=d,mapping=aes(x=displ,y=hwy,color=fl)) + geom_point() + scale_color_brewer(palette="Spectral")
print(p3)

p3 <- ggplot(data=d,mapping=aes(x=displ,y=hwy,color=cty))+ geom_point() 
print(p3)

p3 + scale_color_gradient(low='red',high='blue')

z <- mean(d$cty)
p3 + scale_color_gradient2(midpoint=z,low='red',mid='seagreen',high='cyan',space='Lab')

p3 + scale_color_gradientn(colors=rainbow(5)) + theme_dark()

#heat map 
xVar <- 1:30
yVar <- 1:5
myData <- expand.grid(xVar=xVar,yVar=yVar)
head(myData)
zVar <- myData$xVar + myData$yVar + 2*rnorm(n=150)
myData <- cbind(myData)
head(myData)
p4 <- ggplot(data=myData, mapping=aes(x=xVar,y=yVar,fill=zVar))

p4 + geom_tile() #raster data

p4 + geom_tile() + scale_fill_gradient2(midpoint=19,low='brown',mid=gray(0.8),high='darkblue')
