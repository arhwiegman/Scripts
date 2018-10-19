Attribute VB_Name = "Module2"
'save copies of worksheets as csv files into a timestamped folder and closes worksheet
'   use alt+F11 to open visual basic editor
'   select insert -> module and copy this script into the module text box
'   add a button to run the script by using developer -> insert -> button
'author: Adrian Wiegman
'date updated: 2018-06-26
Sub SaveSheetsAsTimeStampedCSV()
Attribute SaveSheetsAsTimeStampedCSV.VB_Description = "Backs up all worksheets to csv"
Attribute SaveSheetsAsTimeStampedCSV.VB_ProcData.VB_Invoke_Func = "B\n14"
ActiveWorkbook.Save
Dim xWs As Worksheet
Dim xDir As String
Dim fsoFSO
Dim xDir1 As String
Dim TimeStamp As String
Set fsoFSO = CreateObject("Scripting.FileSystemObject")
xDir1 = ActiveWorkbook.Path & "\" & "csv_data"
TimeStamp = Format(DateTime.Now, "yyyymmdd-hhmmss")
MsgBox "saving files to " & xDir1
'Check to see if output folder exists if not then create it
If fsoFSO.FolderExists(xDir1) Then
    'Do nothing
Else
    MkDir (xDir1)
End If
'Save each worksheet as a timestamped .csv file in the output folder
For Each xWs In Application.ActiveWorkbook.Worksheets
    xWs.SaveAs xDir1 & "\" & xWs.Name & "_" & TimeStamp, xlCSV
Next xWs
ActiveWorkbook.Close savechanges:=False 'closes without saving changes
End Sub
