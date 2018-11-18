# define a function to take a linear regression
#  (anything that supports coef() and terms() should work)
expr.from.lm <- function (fit) {
  # the terms we're interested in
  con <- names(coef(fit))
  # current expression (built from the inside out)
  expr <- quote(epsilon)
  # prepend expressions, working from the last symbol backwards
  for (i in length(con):1) {
    if (con[[i]] == '(Intercept)')
      expr <- bquote(beta[.(i-1)] + .(expr))
    else
      expr <- bquote(beta[.(i-1)] * .(as.symbol(con[[i]])) + .(expr))
  }
  # add in response
  expr <- bquote(.(terms(fit)[[2]]) == .(expr))
  # convert to expression (for easy plotting)
  as.expression(expr)
}

# generate and fit dummy data
df <- data.frame(y=rnorm(10), x1=runif(10) < 0.5, x2=rnorm(10), x3=rnorm(10))
f <- lm(iq ~ sex + weight + height, df)
# plot with our expression as the title
plot(resid(f), main=expr.from.lm(f))
expr <- quote(epsilon)
coef(f)
order
