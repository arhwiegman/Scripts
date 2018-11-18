# MATRICES LISTS AND DATAFRAMES
# More basic coding tools for matrices and lists
# ARHW 

library(ggplot2)

# 8 February 2018 
# MATRICES----------------------------
#create a matrix from an atomic vector
#matrix function needs data, nrow and ncol
#in this way it is really an atomic vector
#just wrapped up nicely
m <- matrix(data=1:12,nrow=4,byrow=TRUE)
m
#m <- matrix(data=1:12,nrow=4,byrow=FALSE) #byrow changes the element sorting
#m
dim(m) #returns number of rows and columns in matrix, or dimension
dim(m) <- c(6,2) #we can change the dimensions as long as the product of dimensions are the same
nrow(m)
ncol(m)
dim(m) <- c(4,3)
m
length(m) #total number of elements in the matrix (treating it like atomic vector, or the product of the dimensions
# add names to rows and columns 
rownames(m) <- c('a','b','c','d')
m
colnames(m) <- LETTERS[1:ncol(m)] #a vector of capital letters A-Z
m

#subsetting matrix values
#m[row,col]
print(m[2,3]) # reference an element by row and column #
print(m['b','C']) # reference an element by row and column name
print(m[2,]) # references all elements in a row
print(m[,2]) # returns all elements in a column
print(m[,]) # returns the entire matrix
print(m[1,-(2:3)]) # returns first row and everything but column 2 and three

#more practical naming 
rownames(m) <- paste('species',LETTERS[1:nrow(m)],sep='')
m
colnames(m) <- paste('site',1:ncol(m),sep='')
m

# add names through the dim cpmmand with a list
dimnames(m) <- list(paste('site',1:nrow(m),sep=''),paste('species',ncol(m):1,sep=''))
m
# a list can contain atomic vectors of multiple types an lengths 

#use t function to transpose
t(m) #t() transpose matrix, rows become columns and columns become rows

# add a row to m with rbind 
m2 <- t(m) 
#m2 <- m2[-nrow(m2),] #remove the last row
m2 <- rbind(m2,c(10,20,30,40))
# use "cbind" to add a column
m3 <- cbind(m2,c(10,20,30,40))
rownames(m2)[4] <- 'species4'  #references the 4th row
m2['species4',c('site3','site4')] #returns values for species4 at site3 and site4

# convert back to atomic vector 
myVec <- as.vector(m)
myVec

# LISTS--------------------------------
#lists can hold things of diferent sizes and different types
myList <- list(1:10,matrix(1:8,nrow=4,byrow=TRUE),letters[1:3],pi)
print(myList)
str(myList)

#You can't operate on lists, 
# lists dont behave as you think they should
myList[4] - 3
# the list is like a railcars on a train
myList[4] #this is still a list
#use double or more brackets to pull data out of lists
myList[[4]] #retuns an atomic vector

myList[[2]] #returns entire matrix
myList[[2]][4,1]
#acces [[list item data]][return these specific values]

# We must name list items as variables not caracters
myList2 <- list(Tester=FALSE, littleM=matrix(1:9,nrow=3))
myList2$littleM[2,3] # get row 2, column 3
myList2[["littleM"]][1,2:3]

#referencing a matrix as a an atomic vector
m[1]  #traverses the matrix by column starting in row 1 col1, then row 2 col 1
m[13]
m[3,10]

#_________________ end 8 Feb 2018 class

