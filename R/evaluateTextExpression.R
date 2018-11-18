#this evaluate text as an expression from list of column names
df <- data.frame(1:5, 2:6, 3:7,4:8)
names(df) <- c('a', 'b', 'c', 'd')
paste(names(df), collapse='+')
parse(text = paste(names(df), collapse='+')) -> expr
eval(expr, envir = df)