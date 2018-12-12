#!/usr/bin/python3
def get_usgs_stage():
    from datetime import datetime, timedelta
    import requests 
    # get dates as strings in YYYY-MM-DD format
    TODAY= datetime.strftime(datetime.now(), '%Y-%m-%d')
    YESTERDAY= datetime.strftime(datetime.now() - timedelta(1), '%Y-%m-%d')
    # list of USGS stations
    STATIONS= {"OTTER_CREEK_RUTLAND":'https://waterdata.usgs.gov/nwis/uv?cb_00060=on&cb_00065=on&format=rdb&site_no=04282000',
          "OTTER_CREEK_MIDDLEBURY":'https://waterdata.usgs.gov/nwis/uv?cb_00060=on&cb_00065=on&format=rdb&site_no=04282500',
          "LAKE_CHAMPLAIN_ECHO":'https://waterdata.usgs.gov/nwis/uv?cb_00010=on&cb_00011=on&cb_00011=on&cb_00095=on&cb_62614=on&format=rdb&site_no=04294500'}
    print(STATIONS.keys())
    OUTDIR = '/home/adrian/Documents/GitHub/UVM-research/LCBP-Grant/Hydrology/USGS/'
    for S in STATIONS.keys():
        URL= STATIONS[S]+"&period=&begin_date="+YESTERDAY+"&end_date="+TODAY
        print(URL)
        HTML = requests.get(URL)
        DATA = HTML.text
        with open(OUTDIR+S+".dat","a") as f:
            print('saving '+S+".dat"+' in '+OUTDIR)
            f.write(DATA)
def main():
    get_usgs_stage()

if __name__=='__main__':
    main()
    


