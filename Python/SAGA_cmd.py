#! /usr/bin/env python
# ----------------------------------------------------------------------
# Create hillshades for all ESRI ASCII grids in a folder
# Author: V. Wichmann
# ----------------------------------------------------------------------

import os, sys, subprocess, time


# ----------------------------------------------------------------------
# function definitions
# runCommand_logged ---------------------------------------
def runCommand_logged (cmd, logstd, logerr):
    p = subprocess.call(cmd, stdout=logstd, stderr=logerr)
# ----------------------------------------------------------------------


# ----------------------------------------------------------------------
# environmental variables/paths
if (os.name == "posix"):
    os.environ["PATH"] += os.pathsep + "/usr/local/bin"
else:
    os.environ["PATH"] += os.pathsep + "C:\SAGA"
# ----------------------------------------------------------------------


# ----------------------------------------------------------------------
# global variables
WORKDIR    = "../data"
STDLOG     = WORKDIR + os.sep + "processing.log"
ERRLOG     = WORKDIR + os.sep + "processing.error.log"
# ----------------------------------------------------------------------


# ----------------------------------------------------------------------
# open logfiles (append in case files are already existing)
logstd = open(STDLOG, "a")
logerr = open(ERRLOG, "a")
# ----------------------------------------------------------------------


# ----------------------------------------------------------------------
# initialize
dirlist = os.listdir(WORKDIR)
t0      = time.time()
# ----------------------------------------------------------------------


# ----------------------------------------------------------------------
# loop over files, import them and calculate hillshading
for file in dirlist:
    filename, fileext = os.path.splitext(file)
    if fileext == ".asc":
        
        # --------------------------------------------------------------
        cmd = ['saga_cmd', '-f=q', 'io_grid', 'Import ESRI Arc/Info Grid',
               '-FILE', WORKDIR + os.sep + file,
               '-GRID', WORKDIR + os.sep + filename + ".sgrd",
               '-GRID_TYPE', '2',
               '-NODATA', '0'
              ]
        try:
            runCommand_logged(cmd, logstd, logerr)

        except Exception, e:
            logerr.write("Exception thrown while processing file: " + file + "\n")
            logerr.write("ERROR: %s\n" % e)


        # --------------------------------------------------------------
        cmd = ['saga_cmd', '-f=q', 'ta_lighting', 'Analytical Hillshading',
               '-ELEVATION', WORKDIR + os.sep + filename + ".sgrd",
               '-SHADE', WORKDIR + os.sep + filename + "_shade.sgrd",
               '-METHOD', '0',
               '-AZIMUTH', '315',
               '-DECLINATION', '45',
               '-EXAGGERATION', '4'
              ]
        try:
            runCommand_logged(cmd, logstd, logerr)

        except Exception, e:
            logerr.write("Exception thrown while processing file: " + file + "\n")
            logerr.write("ERROR: %s\n" % e)
# ----------------------------------------------------------------------


# ----------------------------------------------------------------------
# finalize
logstd.write("\n\nProcessing finished in " + str(int(time.time() - t0)) + " seconds.\n")
logstd.close
logerr.close
# ----------------------------------------------------------------------
