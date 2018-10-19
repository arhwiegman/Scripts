'Export each chart object as .png file in a folder called figures
'   use alt+F11 to open visual basic editor
'   select insert -> module and copy this script into the module text box
'   add a button to run the script by using developer -> insert -> button
'author: Adrian Wiegman
'date updated: 2018-10-18
'------------------------------
Public Sub ExportALLCharts()
    Dim outFldr As String
    Dim ws As Worksheet
    Dim co As ChartObject
    Dim x As Integer
    outFldr = ActiveWorkbook.Path & "\" & "figures"
	MsgBox "saving files to " & outFldr
	'Check to see if output folder exists if not then create it
	If fsoFSO.FolderExists(outFldr) Then
    	'Do nothing
	Else
    	MkDir (outFldr)
	End If
    If outFldr = "" Then
        MsgBox "Export Cancelled"
    Else
        For Each ws In ActiveWorkbook.Worksheets
            x = 1
            For Each co In ss.ChartObjects
                co.Export outFldr & "\xlsx_figure_" & wc.Name & x & ".png", "PNG"
                x = x + 1
            Next co
        Next ws
    End If
End Sub

'This function not currently used 
Function GetFolder(strPath As String) As String
    Dim fldr As FileDialog
    Dim sItem As String
    Set fldr = Application.FileDialog(msoFileDialogFolderPicker)
    With fldr
        .Title = "Select folder to export all of the Figures to"
        .AllowMultiSelect = False
        .InitialFileName = strPath
        If .Show = True Then sItem = .SelectedItems(1)
    End With
    GetFolder = sItem
    Set fldr = Nothing
End Function