get-wmiobject win32_computersystem
Get-WmiObject -class win32_processor | Select-Object NumberOfCores
Get-ComputerInfo | Select-Object CsName, WindowsVersion, CsManufacturer, CsModel, CsPhyicallyInstalledMemory
Get-WmiObject -class win32_logicaldisk | Select-Object @{n="Size (GB)";e={[math]::Round($_.Size/1GB,2)}}, @{n="FreeSpace (GB)";e={[math]::Round($_.FreeSpace/1GB,2)}}, @{n="Usage (GB)";e={[math]::Round(($_.Size-$_.FreeSpace)/1GB,2)}}, @{n="PercentUsage (%)";e={[math]::Round((($_.Size-$_.FreeSpace)/$_.Size)*100,2)}}
Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object LastBootUpTime
$bootuptime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
$CurrentDate = Get-Date
$uptime = $CurrentDate - $bootuptime
$uptime
Write-Output "Server Uptime --> Days: $($uptime.days), Hours: $($uptime.Hours), Minutes:$($uptime.Minutes)"
