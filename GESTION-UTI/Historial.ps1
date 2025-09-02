# Espera de 5 minutos
Start-Sleep -Seconds 300
$hostname = hostname
# Definir la ruta del archivo
$csvPath = "C:\GESTION-IMPRESORAS\$hostname.csv"
$networkCsvPath = "\\172.20.106.20\LogControl\Printers\$hostname.csv"  # Ruta de red

$folderPath = [System.IO.Path]::GetDirectoryName($csvPath)
$networkFolderPath = [System.IO.Path]::GetDirectoryName($networkCsvPath)  # Ruta de red para carpeta

# Comprobar si la carpeta local existe, y si no, crearla
if (-not (Test-Path -Path $folderPath)) {
    New-Item -Path $folderPath -ItemType Directory
}

# Comprobar si la carpeta de red existe, y si no, crearla
if (-not (Test-Path -Path $networkFolderPath)) {
    New-Item -Path $networkFolderPath -ItemType Directory
}

# Extraer eventos de impresión y exportarlos al CSV
$eventDetails = Get-WinEvent -LogName "Microsoft-Windows-PrintService/Operational" |
    Where-Object {$_.Id -eq 307} |
    ForEach-Object {
        $details = @{
            Fecha_Creacion    = $_.TimeCreated
            Nro_Documento     = $_.Properties[0].Value
            Categoria_tarea   = $_.Properties[1].Value
            Usuario           = $_.Properties[2].Value
            Hostname          = $_.Properties[3].Value
            Nombre_impresora  = $_.Properties[4].Value
            Puerto            = $_.Properties[5].Value
            Tamanio_bytes     = $_.Properties[6].Value
            Paginas_impresas  = $_.Properties[7].Value
        }
        [PSCustomObject]$details
    }

# Exportar a la carpeta local
$eventDetails | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

# Exportar también a la carpeta de red
$eventDetails | Export-Csv -Path $networkCsvPath -NoTypeInformation -Encoding UTF8
