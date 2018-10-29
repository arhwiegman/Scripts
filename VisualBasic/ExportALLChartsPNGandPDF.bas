'Export each chart object as .png file in a folder called figures
'   use alt+F11 to open visual basic editor
'   select insert -> module and copy this script into the module text box
'   add a button to run the script by using developer -> insert -> button
'author: Adrian Wiegman
'date updated: 2018-10-18
'------------------------------

Public Sub ExportALLCharts()
    ActiveWorkbook.Save
    Dim outFldr As String
    Dim Ws As Worksheet
    Dim co As ChartObject
    Dim x As Integer
    
    Set fsoFSO = CreateObject("Scripting.FileSystemObject")
    outFldr = ActiveWorkbook.Path & "\" & "figures"
    MsgBox "saving charts to " & outFldr
    'Check to see if output folder exists if not then create it
    If fsoFSO.FolderExists(outFldr) Then
        'Do nothing
    Else
        MkDir (outFldr)
    End If
    'Start looping over worksheets and chart objects
    For Each Ws In ActiveWorkbook.Worksheets
        x = 1
        For Each co In Ws.ChartObjects
            'export png
            'co.Chart.Export outFldr & "\xlsx_figure_" & Ws.Name & x & ".png", "PNG"
            'export pdf
            co.Activate
            co.Chart.ExportAsFixedFormat Type:=xlTypePDF, Filename:=outFldr & "\xlsx_figure_" & Ws.Name & x & ".pdf"
            x = x + 1
        Next co
    Next Ws
End Sub