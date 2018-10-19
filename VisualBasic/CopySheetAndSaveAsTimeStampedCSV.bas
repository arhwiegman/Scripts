Attribute VB_Name = "Module1"
'Save each worksheet as a timestamped .csv file in the output folder
'   use alt+F11 to open visual basic editor
'   select insert -> module and copy this script into the module text box
'   add a button to run the script by using developer -> insert -> button
'author: Adrian Wiegman
'date updated: 2018-06-26
Sub CopySheetAndSaveAsTimeStampedCSV()
Attribute CopySheetAndSaveAsTimeStampedCSV.VB_Description = "Saves worksheet as csv"
Attribute CopySheetAndSaveAsTimeStampedCSV.VB_ProcData.VB_Invoke_Func = "S\n14"
ActiveWorkbook.Save
Dim SaveName As String
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
Application.DisplayAlerts = False
ThisWorkbook.ActiveSheet.Copy
SaveName = xDir1 & "\" & ActiveWorkbook.ActiveSheet.Name & "_" & TimeStamp
ActiveWorkbook.SaveAs Filename:=SaveName, FileFormat:=xlCSV, CreateBackup:=True
ActiveWorkbook.Close

Application.DisplayAlerts = True

End Sub
