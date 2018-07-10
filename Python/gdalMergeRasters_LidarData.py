#!/usr/bin/python3.6.3
##################METADATA#####################
# Name: gdalMergeRasters_dem_naipdata.py
#
# this script merges raster files using the gdal_merge.py program
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!!! IMPORTANT: make sure to put a copy of !!!!
# !!!! gdal_merge in the working directory   !!!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# Author: Adrian Wiegman
# Date: 20180515
###############################################

# PRELIMINARIES -----------------------------------------------------
#load modules
import glob
import os

# DEFINED FUNCTIONS -------------------------------------------------
# download_gdalMergePy ----------------------------------------------
# downloads gdal_merge.py into working directory from git hub 
def download_gdalMergePy(directory=None):
    import requests
    from os import getcwd
    url = "https://raw.githubusercontent.com/geobox-infrastructure/gbi-client/master/app/geobox/lib/gdal_merge.py"
    if directory == None: directory = getcwd()
    filename =  path + 'gdal_merge.py'
    r = requests.get(url)
    f = open(filename,'w')
    f.write(r.text)
    f.close
    glob.glob("gdal_merge.py")

#navigate to working directory
path = "D:\\GISdata\\VT_Hydroflattened_LIDAR_DEM\\warped"
os.chdir(path) 
download_gdalMergePy()
print(glob.glob("gdal_merge.py"))
#--------------------------------------------------------------------

# list all files in path
# files = [f for f in os.listdir(path) if os.path.isfile(f)]

# MEGE LIDAR DATA ---------------------------------------------------------
# select DEM .img files in path with glob
file_list = glob.glob("Elev*.img")

# create single string of file names separated by a space
files_string = " ".join(file_list)

# bounding box, upper left and lower right coordinate point: "ul_x ul_y lr_x lr_y"
bbox = "642482.7624 4872992.1269 659356.3624 4836734.526900001"

output = 'output_middleOtter_Elev_1p6mLidar'
#create string containing os comand to run gdal merg
command_list = ["gdal_merge.py",
				"-o "+output+".img", # name and path of output file 
			    "-ul_lr "+bbox,
				" -of HFA ",files_string] #
cmd = " ".join(file_list)

os.system(cmd)
