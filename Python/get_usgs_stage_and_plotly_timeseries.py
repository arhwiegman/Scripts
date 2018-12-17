#!/usr/bin/python3
def plotly_timeseries(df,outname,title,xlabel='observation'):
    '''two row pandas dataframe with time as first (index = 0)
       column and observation as second column'''
    import plotly.plotly as pl
    import plotly.graph_objs as go
    layout=go.Layout(title=title, xaxis={'title':'time'}, yaxis={'title':xlabel})
    data = [go.Scatter( x=df[df.columns[0]],y=df[df.columns[1]])]
    pl.iplot(data,filename=outname,layout=layout)
def subset_dataframe(df):
    '''removes extra rows and columns from data'''
    df = df[['datetime','feet']]
    df = df.iloc[1:]
    return(df)
def get_usgs_stage():
    '''pulls the last 24 hours of data from the USGS guage and appends it to a local data file'''
    from datetime import datetime, timedelta
    import requests 
    # get dates as strings in YYYY-MM-DD format
    OUTDIR = '/home/adrian/Documents/GitHub/UVM-research/LCBP-Grant/Hydrology/USGS/'
    TODAY= datetime.strftime(datetime.now(), '%Y-%m-%d')
    YESTERDAY = datetime.strftime(datetime.now() - timedelta(1), '%Y-%m-%d')
    with open(OUTDIR+"date_of_last_pull_from_usgs","r") as F:
        LASTPULL=F.read()
        if LASTPULL == TODAY:
            print("data already pulled today... exiting program")
            exit()
    END=TODAY
    START=LASTPULL
    print ("date of last pull from usgs: "+LASTPULL)
    # list of USGS stations
    URL_1 = 'https://nwis.waterdata.usgs.gov/usa/nwis/uv/?'
    STATIONS= {"OTTER_CREEK_RUTLAND":URL_1+'cb_00060=on&cb_00065=on&format=rdb&site_no=04282000',
          "OTTER_CREEK_MIDDLEBURY":URL_1+'cb_00060=on&cb_00065=on&format=rdb&site_no=04282500',
          "LAKE_CHAMPLAIN_ECHO":URL_1+'cb_00010=on&cb_00011=on&cb_00011=on&cb_00095=on&cb_62614=on&format=rdb&site_no=04294500'}
    print(STATIONS.keys())
    for S in STATIONS.keys():
        URL= STATIONS[S]+"&period=&begin_date="+START+"&end_date="+END
        print(URL)
        HTML = requests.get(URL)
        DATA = HTML.text
        with open(OUTDIR+S+".dat","a") as f:
            print('saving '+S+".dat"+' in '+OUTDIR)
            f.write(DATA)
    # save today's date to output file 
    with open(OUTDIR+"date_of_last_pull_from_usgs","w") as F:
        F.write(TODAY)
def main(): 
    import pandas
    get_usgs_stage()
    PATH = "/home/adrian/Documents/GitHub/UVM-research/LCBP-Grant/Hydrology/USGS/"
    STATIONS = ["LAKE_CHAMPLAIN_ECHO","OTTER_CREEK_RUTLAND","OTTER_CREEK_MIDDLEBURY"]
    FILENAMES = [S+".dat" for S in STATIONS]
    for N in FILENAMES:
        with open(PATH+N,'r') as F:
            df = pandas.read_table(F,sep="\t",comment="#")
            print(df.head())
            print(list(df))
            df = subset_dataframe(df)
            print(df[df.columns[0]])
            title=N[:len(N)-4] # name of guage without dat extension
            plotly_timeseries(df=df,outname=N[:len(N)-4],title=title,xlabel='stage (ft)')

if __name__ == '__main__':
    main()
