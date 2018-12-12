#!/usr/bin/python3
def plotly_timeseries(df,outname):
    '''two row pandas dataframe with time as first (index = 0)
       column and observation as second column'''
    import plotly.plotly as pl
    import plotly.graph_objs as go
    data = [go.Scatter( x=df[df.columns[0]],y=df[df.columns[1]])]
    pl.iplot(data,filename=outname)
def subset_dataframe(df):
    df = df[['datetime','feet']]
    df = df.iloc[1:]
    return(df)
def clean_up_dataframe(df):
    df
def main(): 
    import pandas
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
            plotly_timeseries(df,N[:len(N)-4])

if __name__ == '__main__':
    main()
