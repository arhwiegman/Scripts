
# gdal_calc_NDVI ------------------------------
# calculates NDVI from 4 band imagery R,G,B,NIR
# using gdal_calc.py command line tool
def gdal_calc_NDVI(inRaster):
	import os 
	cmdlist = ["gdal_calc.py",
			   "-A "+inRaster,
			   "--A_band=1",
			   "-B "+inRaster,
			   "--B_band=4",
			   "--outfile=NDVI_"+inRaster,
			   "--calc=\"((B-A)/(B+A))\""]
	cmd = " ".join(cmdlist)
	print ("running command... \n",cmd,"\n")
	os.system(cmd)

import os,glob 

wd = "C:\\workspace\\naip\\brandon"
files = glob.glob("*NAIP*")
infiles = [os.path.join(wd,f) for f in files]

for f in infiles:
	gdal_calc_NDVI(f)
	
	
gdal_calc.py -A brandon_NAIP2016.tif --A_band=1 -B brandon_NAIP2016.tif --B_band=4 --calc="((B-A)/(B+A))" --outfile=NDVIbrandon_NAIP2016.tif 