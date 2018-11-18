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