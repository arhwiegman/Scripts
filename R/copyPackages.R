# Copy packages from win-library to new version of R and update
# C:\Users\Adria\Documents\R\win-library
setwd("C:/Users/Adria/Documents/R/win-library")
file.copy("3.4", "3.5", recursive=TRUE)
# update all packages
update.packages(ask = FALSE)