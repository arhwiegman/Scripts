# Formulas
# A tutorial on using formulas in R is provided at this link:
# https://www.datacamp.com/community/tutorials/r-formula-tutorial

# a assigning an object as formula 
a <- ~ x*x2
typeof(a)
class(a)
length(a)
a[1]

#turn a string into a formula
as.formula("y~a*b")


# hold a system of equations in a vector
# Create variables
i <- y ~ x
j <- y ~ x + x1
k <- y ~ x + x1 + x2

# Concatentate
formulae <- list(as.formula(i),as.formula(j),as.formula(k))

# Double check the class of the list elements
class(formulae[[1]])

#example using lapply
# Join all with `c()`
l <- c(i, j, k)

# Apply `as.formula` to all elements of `f`
formulae <- lapply(l, as.formula)

# evaluate formulas using model.frame
# Set seed
set.seed(123)

# Data
x = rnorm(5)
x2 = rnorm(5)
y = rnorm(5)

# Model frame
model.frame(y ~ x * x2, data = data.frame(x = x, y = y, x2=x2))

# Formula                       Description
# A + B	                      | main effects of A and B
# A:B	                        |interaction of A with B
# A*B	                        |main effects and interactions = A + B + A:B
# A*B*C	                      |main effects and interactions A+B+C+A:B+A:C+B:C+A:B:C
# (A+B+C)^2                   |	A, B, and C crossed to level 2: A+B+C+A:B+A:C+B:C
# A*B*C-A:B:C                 |	same as above: main effects plus 2-way interactions
# 1 + state + state:county    |	nested ANOVA
# 1 + state + county%in%state	|nested ANOVA emphasizing county nested in state
# state / county	            | nested ANOVA
# (1 / subject)	              |fit random intercepts for subjects
# (1+time / subject)          |	fit both random intercepts and random subject-specific slopes

# https://rviews.rstudio.com/2017/02/01/the-r-formula-method-the-good-parts

#this evaluates text as an expression from list of column names
df <- data.frame(1:5, 2:6, 3:7,4:8)
names(df) <- c('a', 'b', 'c', 'd')
textExpr <- paste(names(df), collapse='+')
expr <- parse(text = textExpr)
eval(expr, envir = df)

#convert an expression into a formula and evaluate
form <- formula(paste("y~",textExpr))
form
df <- data.frame(ID=seq_along(df[,1]),df,y=rep(NA,length(df[,1])))
a <- model.frame(form,df)
a

#pull all variable names out of a formula
all.vars(form)

#creat a function to evaluate a string 
str_eval<-function(x) {return(eval(parse(text=x)))}
str_eval('1:10')


