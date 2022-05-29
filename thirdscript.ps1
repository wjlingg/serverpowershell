$serverlist = @(get-content -Path "$env:HOMEDRIVE$env:HOMEPATH\ServerList.txt") # get the content of the server name from server list
$allServer = @()

foreach ($server in $serverlist)
{
    write-host "Server: $server"

    $osversion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
    $lastbootime = (Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $server).LastBootUpTime
    $CurrentDate = Get-Date
    $uptime = $CurrentDate - $bootuptime
    $manufacturer = (Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $server).Manufacturer
    $model = (Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $server).Model
    $numberofcores = (Get-WmiObject -class win32_processor -ComputerName $server).NumberOfCores
    $memoryram = (Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $server).totalphysicalmemory / 1GB
    $disksize = (Get-WmiObject -class win32_logicaldisk -ComputerName $server).Size / 1GB
    $freespace = (Get-WmiObject -class win32_logicaldisk -ComputerName $server).FreeSpace / 1GB
    $diskusage = ($disksize - $freespace) / $disksize * 100


    $serverObject = New-Object -TypeName psobject
    $serverObject | Add-Member -MemberType NoteProperty -Name ComputerName -Value "$server"
    $serverObject | Add-Member -MemberType NoteProperty -Name OSVersion -Value "$osversion"
    $serverObject | Add-Member -MemberType NoteProperty -Name Uptime -Value "Days: $($uptime.days), Hours: $($uptime.Hours), Minutes:$($uptime.Minutes)"
    $serverObject | Add-Member -MemberType NoteProperty -Name LastRebootDetails -Value "$lastbootime"
    $serverObject | Add-Member -MemberType NoteProperty -Name Manufacturer -Value "$manufacturer"
    $serverObject | Add-Member -MemberType NoteProperty -Name Model -Value "$model"
    $serverObject | Add-Member -MemberType NoteProperty -Name NumberOfCpuCores -Value "$numberofcores"
    $serverObject | Add-Member -MemberType NoteProperty -Name MemoryRAM -Value "$([math]::Round($memoryram,6))GB"
    $serverObject | Add-Member -MemberType NoteProperty -Name DiskCapacity -Value "$([math]::Round($disksize,6))GB"
    $serverObject | Add-Member -MemberType NoteProperty -Name DiskUsage -Value "$([math]::Round($diskusage,6))%"

    $allServer += $serverObject
}

$allServer | Export-Csv -Path "$env:HOMEDRIVE$env:HOMEPATH\ServerObjectListInfo.csv" # export object to csv file
