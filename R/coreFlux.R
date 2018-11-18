# fit a segmented regression to core flux data to find time of equilibrium 
# A - is the lm object from X_min to lamda
# B - is the lm object from lamda to X_max
# alpha is the test value e.g. 0.01, 0.05 
# lambda is the X value at which b1B is not significantly different from 0
# Y - is the concentration
# 
fitFluxModel <- function(X,Y,alpha=0.05){
df <- data.frame(X,Y)
Result <- list(A=NA,B=NA,b0A=NA,b0B=NA,b1A=NA,bAB=NA,lamda=NA)
for(i in seq_along(X)){
dfA <- df[:(i-1),]
dfB <- df[i:,]

# get
Result$A <- lm(Y~X,dfA)
Result$B <- lm(Y~X,dfB)
Result$b0A <- 
b0B <-
b1A <- 
b1B <-

if (p_b1B > alpha){
return(Result)
	