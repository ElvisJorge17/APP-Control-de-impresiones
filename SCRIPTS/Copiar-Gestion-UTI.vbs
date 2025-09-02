' Script en VBScript para verificar si existe la carpeta "Gestion-UTI"
' Si no existe, la copia desde \\172.20.106.20\LogControl\Directivas\GESTION-UTI a C:\GESTION-UTI

Option Explicit

Dim fso, carpetaOrigen, carpetaDestino, carpeta

' Crear el objeto FileSystemObject
Set fso = CreateObject("Scripting.FileSystemObject")

' Definir las rutas de las carpetas
carpetaOrigen = "\\172.20.106.20\LogControl\Directivas\GESTION-UTI"
carpetaDestino = "C:\GESTION-UTI"

' La carpeta origen existe, proceder a copiar
If fso.FolderExists(carpetaOrigen) Then
    ' Copiar la carpeta
    fso.CopyFolder carpetaOrigen, carpetaDestino
    
    ' Hacer la carpeta destino oculta
    Set carpeta = fso.GetFolder(carpetaDestino)
    carpeta.Attributes = carpeta.Attributes Or 2 ' 2 es el valor de vbHidden
    
Else
    ' La carpeta origen no existe
    WScript.Echo "La carpeta origen no existe."
End If

' Liberar el objeto FileSystemObject
Set fso = Nothing
