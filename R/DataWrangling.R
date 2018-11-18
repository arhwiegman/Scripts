# Data Wrangling 

#premilinaries
library(reshape2)
library(tidyr)
library(dplyr)
library(ggplot2)
library(TeachingDemos)
char2seed("Sharpei")

species <- 5
sites <- 8
abundanceRange <- 1:10
mFill <- 0.4

vec <- rep(0,species*sites) # set up empty vector factorial length
abun <- sample(x=abundanceRange, size=round(mFill*length(vec)),replace=TRUE)
vec[seq_along(abun)] <- abun
vec <- sample(vec)
vec
aMat <- matrix(vec,nrow=species)
aMat
rownames(aMat) <- rownames(aMat,
                           do.NULL = FALSE,
                           prefix="Species")
colnames(aMat) <- colnames(aMat,
                           do.NULL = FALSE,
                           prefix="Sites")
aMat #wide format

# use melt from reshape2 packages to get a matrix into long form
. <- melt(aMat)
print(.)
. <- melt(aMat, varnames=c("Species","Site"),value.name="Abundance")
print(.)

aFrame <- data.frame(cbind(Species=rownames(aMat),aMat))
print(aFrame)

# tidyr for manapulate data frame
. <- gather(aFrame,Sites1:Sites8,key="Sites",value="Abundance")
print(.)
str(.)
.$Abundance <- as.numeric(.$Abundance)
aFrameL <- .

# now able to do a bar plot with this
ggplot(aFrameL,aes(x=Sites,y=Abundance,fill=Species))+geom_bar(position='dodge',stat="identity",color='Black')


#Build a subject x time eperimental matrix
Treatment <- rep(c("Ctrl","Trtmt"),each=5)
Subject <- 1:10
T1 <- rnorm(10)
T2 <- rnorm(10)
T3 <- rnorm(10)

eFrame <- data.frame(Treatment=Treatment,
                     Subject=Subject,
                     T1=T1,
                     T2=T2,
                     T3=T3)

str(eFrame)
print(eFrame)

# gather from tidyr
. <- gather(eFrame,T1:T3,key="Time",value="Response")
print(.)
.$Time <- as.factor(.$Time)
eFrameL <- .

#boxplot
ggplot(eFrameL,aes(x=Treatment,y=Response,fill=Time)) + geom_boxplot()

# now change from long to wide format
. <- dcast(aFrameL,Species~Sites,value="Abundance")
str(.)
print(.)

. <- spread(aFrameL, key=Sites, value=Abundance)
print(.)
. <- spread(aFrameL, key=Species, value=Abundance)

. <- spread(eFrameL, key=Time,value=Response)
print(.)

# summarize
summarize(mpg,ctyM=mean(cty),ctySD=sd(cty)) # produces tibble

as.data.frame(summarize(mpg,ctyM=mean(cty),ctySD=sd(cty)))

#group_by
. <- group_by(mpg,fl)
str(.)
summarize(.,ctyM=mean(cty),ctySD=sd(cty))

summarize(.,ctyM=mean(cty),ctySD=sd(cty),n=length(cty))

. <- group_by(mpg,fl,class)
summarize(.,ctyM=mean(cty),ctySD=sd(cty),n=length(cty))

#filter returns TRUE values for a bolean on the dataset
.<- filter(mpg,class!="suv")
. <- group_by(.,fl,class)
summarize(.,ctyM=mean(cty),ctySD=sd(cty),n=length(cty))

# apply functions

# replicate(n,epxression,simplify)
# n - number of replications
# expression is any R expression of function call
# simplify default="array", with 1 more dimession than original output, simplify = TRUE gives vector or matrix, simplify = FALSE gives a list

myOut <- matrix(data=0,nrow=3,ncol=5)
myOut

# fill with for loop: inneffient code in R because of R vector operations
for (i in 1:nrow(myOut)){
  for (j in 1:ncol(myOut)){ 
    myOut[i,j] <- runif(1)
  }
}

# efficient R code
myOut <- matrix(data=runif(15),nrow=3)

mO <- replicate(n=5,
                100 + runif(3),
                simplify=TRUE)
mO

# create three dimensional array
m1 <- replicate(n=5,
                matrix(runif(6),3,2),
                simplify="array")
m1

print(m1[,,3])

