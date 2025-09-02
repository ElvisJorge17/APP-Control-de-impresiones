Set objShell = CreateObject("Shell.Application")
Set objFSO = CreateObject("Scripting.FileSystemObject")
strPath = objFSO.GetParentFolderName(WScript.ScriptFullName)
objShell.ShellExecute "powershell.exe", "-ExecutionPolicy Bypass -NoProfile -File """ & strPath & "\Activar-Registro.ps1""", "", "runas", 1
