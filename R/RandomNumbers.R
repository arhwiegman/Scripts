#Set random number generator using a phrase
install.packages("TeachingDemos")
library(TeachingDemos)
char2seed('espresso',set=FALSE)
char2seed('espresso')
runif(1)

