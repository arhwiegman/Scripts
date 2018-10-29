# Structural Equation Modeling
#install.packages("sem")

#latent variable is indirectly observed 
#observed variable is directly observed


library(sem)
data(Klein)
View(Klein)
Klein$P.lag <- c(NA,Klein$P[-22])
Klein$X.lag <- c(NA,Klein$X[-22])

# tsls two-stage least squares
# I() identify function, I(Wp+Wg), sums Wp+Wg into a single regressor
# “Regress C on P, P.lag, and the sum ofWpandWc.”
Klein.eqn1 <- tsls(C~P+P.lag+I(Wp+Wg),instruments=~G+T+Wg+I(Year-1931)+K.lag+P.lag+X.lag, data=Klein)

Klein.eqn2 <- tsls(I ~ P + P.lag + K.lag, instruments=~G+T+Wg+ I(Year - 1931) + K.lag + P.lag + X.lag, data=Klein)

Klein.eqn3 <- tsls(Wp ~ X + X.lag + I(Year - 1931), instruments=~G+T+Wg+ I(Year - 1931) + K.lag + P.lag + X.lag,data=Klein)


            