'saves file using cell names and exports to pdf
Sub PDF()
    Dim SaveAsStr As String

    SaveAsStr = ActiveWorkbook.Path & "\" & ActiveSheet.Range("D3").Value & "_" & ActiveSheet.Range("AH3").Value & "_VRAM_2.3.1"
    ActiveWorkbook.SaveAs Filename:=SaveAsStr FileFormat:=51 'xlsx
    ActiveSheet.ExportAsFixedFormat Type:=xlTypePDF, _
        Filename:=SaveAsStr & ".pdf", _
        OpenAfterPublish:=False
    ActiveWorkbook.Close
End Sub
