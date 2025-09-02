# Activar ejecución de scripts para esta sesión
if ((Get-ExecutionPolicy -Scope Process) -ne "Bypass") {
    Write-Host "Estableciendo política de ejecución temporal a 'Bypass'..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
}

# Validar que se está ejecutando como administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Este script debe ejecutarse como administrador." -ForegroundColor Red
    exit 1
}

# Parámetros del registro de impresión
$logName = "Microsoft-Windows-PrintService/Operational"
$maxSize = 97108864  # 64 MB

Write-Host "`n==== Configuración del registro de eventos de impresión ===="

# Verificar si el log está habilitado
Write-Host "Verificando si el log '$logName' está habilitado..."
try {
    $channelStatus = (wevtutil gl $logName | Select-String "enabled").ToString()
    if ($channelStatus -like "*false*") {
        Write-Host "El log está deshabilitado. Habilitándolo..."
        wevtutil sl $logName /e:true
        Start-Sleep -Seconds 3  # Esperar a que se aplique
    } else {
        Write-Host "El log ya está habilitado."
    }
}
catch {
    Write-Host " Error al obtener el estado del log: $_"
    exit 1
}

# Establecer tamaño máximo del log
Write-Host "Estableciendo tamaño máximo del log a $($maxSize / 1MB) MB..."
try {
    wevtutil sl $logName /ms:$maxSize
    Write-Host " Tamaño máximo configurado correctamente."

    # Crear archivo con el nombre del host
    $hostname = $env:COMPUTERNAME
    $destino = "\\172.20.106.20\LogControl\RegistroActivo\$hostname.txt"

    Write-Host "Creando archivo de registro en: $destino"
    try {
        $fecha = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        "Registro actualizado desde $hostname el $fecha" | Out-File -FilePath $destino -Encoding UTF8 -Force
        Write-Host "Archivo creado exitosamente."
    }
    catch {
        Write-Host " Error al crear el archivo de registro: $_"
    }

    exit 0
}
catch {
    Write-Host " Error al configurar el tamaño del log: $_"
    exit 1
}
