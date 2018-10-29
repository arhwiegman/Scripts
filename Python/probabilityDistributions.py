# skewedNormalSample ------------------------------------------------
def skewedNormalSample(n=100,seed=100,data=None):
  from scipy.stats import ss
  # probability density function
  if data == None: data = [10,10,12,10,5,9,9,4,2,1,15,20]
  fit = skewnorm.fit(data)
  params = ",".join([str(p) for p in fit])
  print(params)
  F = eval("skewnorm("+params+")")
  # random variate sample
  S = F.rvs(n,seed)
  return(S)
  
# fitSkewNormDist ---------------------------------------------
def fitSkewNormDist(data=None):
  if data==None: 
    data=[1,1,2,3,4,5,5,5,6,7,8,9,10,10,10,10,0,8,6,15,10,23,12,45,50]
  fit_alpha, fit_loc, fit_scale = ss.skewnorm.fit(data)
  print("alpha=",fit_alpha,"\nloc=",fit_loc,"\nscale=",fit_scale)
  F = ss.skewnorm(a=fit_alpha,loc=fit_loc,scale=fit_scale)
  return(F)
  
# fitGammaDist ---------------------------------------------
def fitGammaDist(data=None):
  import scipy.stats as ss
  if data==None: 
    data=[-1000,1,1,2,3,4,5,5,5,6,7,8,9,10,10,10,10,0,8,6,15,10,23,12,45,50]
  fit_a, fit_loc, fit_b = ss.gamma.fit(data)
  print("alpha=",fit_a,"\nloc=",fit_loc,"\nbeta=",fit_b)
  F = ss.gamma(a=fit_a,loc=fit_loc,scale=fit_b)
  return(F)
 
# fittedDistParams ---------------------------------------------
# returns parameters fit to data from the specified probability distribution function
# inputs: data - an numeric array type object  
#         dist - the name of a scipy.stats function listed here:https://docs.scipy.org/doc/scipy/reference/stats.html
#               "skewnorm","gamma", "poisson" 
def fittedDistParams(data=None,dist="norm"):
  import scipy.stats as ss
  if data==None: 
    data=[-1000,1,1,2,3,4,5,5,5,6,7,8,9,10,10,10,10,0,8,6,15,10,23,12,45,50]
  fit = eval("ss."+dist+".fit(data)")
  return(fit)
  
# ramdomSampleFromFittedDistribution---------------------------------------------
# returns n random samples from the specifcied probability distribution fit to input data 
# inputs: data - an numeric array type object  
#		  n - the number of samples to return
#         seed - the random seed generator
#         dist - a string containing the name of a scipy.stats function listed here:https://docs.scipy.org/doc/scipy/reference/stats.html
#               "norm", "skewnorm","gengamma", "beta", "gompertz"
def randomSampleFromFittedDistribution(data=None,dist="norm",n=100,seed=100):
  import scipy.stats as ss
  if data == None: 
    data=[-1000,1,1,2,3,4,5,5,5,6,7,8,9,10,10,10,10,0,8,6,15,10,23,12,45,50]
  fit = eval("ss."+dist+".fit(data)")
  params = ",".join([str(p) for p in fit])
  F = eval("ss."+dist+"("+params+")")
  return(F.rvs(n,seed))

# ramdomSampleFromFittedDistribution---------------------------------------------
# returns froszen random distribution object from the specifcied probability distribution fit to input data 
def fitRandomDistribution(data=None,dist="gamma",n=100,seed=100):
  import scipy.stats as ss
  if data == None: 
    data=[-1000,1,1,2,3,4,5,5,5,6,7,8,9,10,10,10,10,0,8,6,15,10,23,12,45,50]
  fit = eval("ss."+dist+".fit(data)")
  params = ",".join([str(p) for p in fit])
  F = eval("ss."+dist+"("+params+")")
  return(F)

# plotDistribution ---------------------------------------------
def plotDistributionFit(data=None,dist="gamma",n=100,seed=100):
  import scipy.stats as ss
  import numpy as np
  from matplotlib import pyplot as plt
  if data==None: 
    data=[-150,-300,-10,-75,-24,0,1,1,2,3,4,5,5,5,6,7,8,9,10,10,10,10,0,8,6,15,10,23,12,45,50]
  fit = eval("ss."+dist+".fit(data)")
  params = ",".join([str(p) for p in fit])
  F = eval("ss."+dist+"("+params+")")
  # create n evenly spaced x values within 99% CI
  x = np.linspace(F.ppf(0.01),F.ppf(0.99), n)
  #Create a figure to plot data
  fig, ax = plt.subplots(1, 1)
  ax.hist(F.rvs(n,seed), density=True, histtype='stepfilled', alpha=0.3, label="data \n(n="+str(len(data))+")")
  ax.plot(x, F.pdf(x), 'k-', lw=2, label=dist+" fit \n"+"\n".join([str(p) for p in fit]))
  ax.hist(F.rvs(n), density=True, histtype='stepfilled', alpha=0.3, label="random sample from fit \n(n="+str(n)+")")
  ax.legend(loc='best', frameon=False)
  plt.show()
  

if name == __main__:
	# LOAD MODULES
	import numpy as np
	import pandas as pd
	np.set_printoptions(precision=3)
	# MAIN PROGRAM
	path = "C:\\Users\\Adria\\Documents\\UVM-research\\Wetland P Retention\\Review\\SI_forLandetal2016\\"
	df = pd.read_csv(13750_2016_60_MOESM5_ESM_editedAW.csv")
	# drop missing values (NaN) from data 
	data = [l for l in df.R_TP if str(l) != 'nan']
	dist = input("select a probability distribution: \n")
	# convert data to numpy array
	data = np.array(data)
	#normalizedData = data/np.amax(data)-1
	normalizedData = 1-data/np.amax(data)
	print(normalizedData)
	#convert from numpy array to list
	normalizedData = normalizedData.tolist() 
	plotDistributionFit(normalizedData,dist,n=1000)
	random = randomSampleFromFittedDistribution(normalizedData,dist,n=100,seed=100)
	print(random)
	rand1000 = (1-random)*np.amax(data)
	print("\nmax",np.amax(data2),"\nmin",np.amin(data2))
	print(rand1000)
	for i in range(rand100):
		landcover = str(90)+"{:0>5}".format(str(i))
	output = pd.data.frame(landcover,rand1000)
	output.to_csv(path+"Landetal2016_NDR_TP_"+dist+"fit.csv")
		


