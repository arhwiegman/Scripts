# skewedNormalSample ------------------------------------------------
def skewedNormalSample(n=100,F=None,skew=0,mean=0,sdev=1):
  from scipy.stats import skewnorm
  # probability density function
  if F == None:
  	F = skewnorm(a=skew,loc=mean,scale=sdev)
  # random variate sample
  S = F.rvs(size=n)
  return(S)
  
  
# fitGammaDist ---------------------------------------------
def fitGammaDist(data=None):
  import scipy.stats as ss
  if data==None: 
    data=[-1000,1,1,2,3,4,5,5,5,6,7,8,9,10,10,10,10,0,8,6,15,10,23,12,45,50]
  fit_a, fit_loc, fit_b = ss.gamma.fit(data)
  print("alpha=",fit_a,"\nloc=",fit_loc,"\nbeta=",fit_b)
  F = ss.gamma(a=fit_a,loc=fit_loc,scale=fit_b)
  return(F)
 
# fitProbabilityDist ---------------------------------------------
# returns parameters fit to data from the specified probability distribution function
# inputs: data - an numeric array type object  
#         dist - the name of a scipy.stats function listed here:https://docs.scipy.org/doc/scipy/reference/stats.html
#               "norm", "skewnorm","gamma", "poisson" 
def fitScipyStatDist(data=None,dist="norm"):
  import scipy.stats as ss
  if data==None: 
    data=[-1000,1,1,2,3,4,5,5,5,6,7,8,9,10,10,10,10,0,8,6,15,10,23,12,45,50]
  fit = eval("ss."+dist+".fit(data)")
  return(fit)

# fitSkewNormDist ---------------------------------------------
def fitSkewNormDist(data=None):
  if data==None: 
    data=[1,1,2,3,4,5,5,5,6,7,8,9,10,10,10,10,0,8,6,15,10,23,12,45,50]
  fit_alpha, fit_loc, fit_scale = ss.skewnorm.fit(data)
  print("alpha=",fit_alpha,"\nloc=",fit_loc,"\nscale=",fit_scale)
  F = ss.skewnorm(a=fit_alpha,loc=fit_loc,scale=fit_scale)
  return(F)

# plotDistribution ---------------------------------------------
def plotDistribution(data=None,dist="gamma",n=None):
  import scipy.stats as ss
  import numpy as np
  from matplotlib import pyplot as plt
  if n == None: n=100
  if data==None: 
    data=[1,1,2,3,4,5,5,5,6,7,8,9,10,10,10,10,0,8,6,15,10,23,12,45,50]
  fit = eval("ss."+dist+".fit(data)")
  F = eval("ss."+dist+"(fit)")
  # create 100 evenly spaced x values within 99% CI
  x = np.linspace(F.ppf(0.01),F.ppf(0.99), n)
  #Create a figure to plot data
  fig, ax = plt.subplots(1, 1)
  ax.plot(x, F.pdf(x), 'k-', lw=2, label='pobability density function')
  ax.hist(F.rvs(n), density=True, histtype='stepfilled', alpha=0.2, label="randomly generated data n="+str(n))
  ax.hist(F.rvs(n), density=True, histtype='stepfilled', alpha=0.2, label="observed data n="+str(len(data)))
  ax.legend(loc='best', frameon=False)
  plt.show()