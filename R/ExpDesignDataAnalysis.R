# # Archchetype experimental designs, data entry, analysis, and graphing in R
# data <- read.table(file='filename.csv',rownames=1,header=TRUE,sep=',',stringsAsFactors = FALSE) 
# # read.table ignores '#' allowing for metadata
# # rownames=1 says that the first row designates rownames

# # Omit NA values to allow for R to complete statistical tests
# dataClean <- data[complete.cases(data),] #entire dataset
# # complete.cases(data) returns all row names that have no missing values
# dataClean <- data[complete.cases(data[,5:6]),] # all rows with no NAs in and 5:6 
# # good for regression

#Set random number generator using a phrase
#install.packages("TeachingDemos")
library(TeachingDemos)
library(ggplot2)
char2seed('espresso',set=FALSE)
char2seed('espresso')
runif(1)

# create reggression data frame
n <- 50 #number of observations
# its good practice to introduce global variables
varA<- runif(n)
varB<- 5.5 + 10*varA + 10*runif(n)
# y = b0 + b1*x + error
ID <- seq_len(n)
regData <- data.frame(ID,varA,varB)
str(regData)
head(regData)


#/// SIMPLE LINEAR REGRESSION 
# basic regression analysi in R
regModel <- lm(varB~varA,data=regData) #linear model function make sure to specify data frame, this helps with updates and automation
print(regModel)
str(regModel)
head(regModel$residuals)
# most of the usefull informatio is contained in the summary function
z <- summary(regModel)
z$coefficients # we are calling the coefficients item from the list summary(regModel)
#Output
# Estimate Std. Error  t value     Pr(>|t|)
# (Intercept) 5.995923 0.08596044 69.75211 6.573747e-50
# varA        9.906425 0.15267511 64.88566 2.041316e-48

# call the slope
mySlope <- z$coefficients[2,1]

zUnlisted <- unlist(z) #unlist turns a complex dataframe into an atomic vector
zUnlisted
zUnlisted$r.squared

#create a list with your useful output using the names of the unlisted variables
regOutputs <-list(intercept=zUnlisted$coefficients1,
                  slope=zUnlisted$coefficients2,
                  interceptP=zUnlisted$coefficients7,
                  slopeP=zUnlisted$coefficients8,
                  r2=zUnlisted$r.squared)
str(regOutputs) #use structure frequently and check for errors as you code
regOutputs$slope

#Basic ggplot of regression
regPlot <- ggplot(data=regData,aes(x=varA,y=varB)) + geom_point() + theme_classic() + stat_smooth(method=lm,se=0.99) #se is the 0.99 confidence interval
#most basic ggplot
print(regPlot)

#/// ANALYSIS OF VARIANCE
# data set up for ANOVA
nGroup <- 3
nName <-c('control','treat1','treat2')
nSize <-c(12,17,9)
nMean <-c(40,41,60) # mean response in each group
nSD <- c(5,5,5) # standard deviation within group
ID <- 1:(sum(nSize)) # unique ID for each observation

#proper data structure for response variable or y
yVar <- c(rnorm(n=nSize[1],mean=nMean[1],sd=nSD[1]),
             rnorm(n=nSize[2],mean=nMean[2],sd=nSD[2]),
             rnorm(n=nSize[3],mean=nMean[3],sd=nSD[3])) 
#typing this is a little repetitive and could be shortened with a for loop
str(yVar)
sum(nSize)
TGroup <- rep(nName,nSize) #repeat nName[] nSize[] times
table(TGroup)

ANOdata <- data.frame(ID,TGroup,yVar)
str(ANOdata)

#basic ANOVA in R
ANOmodel <- aov(yVar~TGroup,data=ANOdata) 
print(ANOmodel)
summary(ANOmodel)

# basic ggplot of ANOVA data
ANOplot <- ggplot(data=ANOdata,
                  aes(x=TGroup, y=yVar, fill=TGroup)) + 
                  geom_boxplot() + 
                  theme_classic()
# change fill color based on group
# you need to specify a geom for ggplot
print(ANOplot)
ggsave(filename='myBoxPlot.pdf',plot=ANOplot,device='pdf')


#create data frame for logistic regression
xVar <- sort(rgamma(n=200,shape=5,scale=5))
yVar <- sample(rep(c(1,0),each=100),prob=seq_len(200))
qplot(x=xVar, y=yVar)               
lRegData <- data.frame(ID=1:200,xVar,yVar)
str(lgRegData)

#logistic regression analysis in R
lRegModel <- glm(yVar~xVar,data=lRegData,family=binomial(link=logit))
summary(lRegModel)
summary(lRegModel)$coefficients

#basic ggplot of logistic regression
lRegPlot <- ggplot(data=lRegData, aes(x=xVar,y=yVar)) + 
  geom_point() + 
  stat_smooth(method=glm, method.args = list(family=binomial)) +
  theme_classic()
print(lRegPlot)

#basic contigency table analysis in R

vec1 <- c(50,66,22) #counts of occurances
vec2 <- c(120,22,30) #
dataMatrix <- rbind(vec1,vec2) #row bind creates a matrix from two vectors
rownames(dataMatrix) <- c('Cold','Warm')
colnames(dataMatrix) <- c('Aphaenog aster', 'Camponotus', 'Crematogaster')
dataMatrix

#contingency table analysis
print(chisq.test(dataMatrix))

mosaicplot(x=dataMatrix, col=c('green','red','blue'), shade=FALSE)
