Write-Host "Starting powershell script..."
Write-Host "Getting information from a list of servers..."
Write-Host "Below are all the available servers:"

$serverlist = @(get-content -Path "$env:HOMEDRIVE$env:HOMEPATH\ServerList.txt") # get the content of the server name from server list
$allServer = @()

foreach ($server in $serverlist) # create dummy data for each of the server host in server list
{
    write-host "Server: $server"
    $serverObject = New-Object -TypeName psobject
    $serverObject | Add-Member -MemberType NoteProperty -Name ComputerName -Value "$server"
    $serverObject | Add-Member -MemberType NoteProperty -Name Environment -Value "Development$($server.ReadCount)"
    $serverObject | Add-Member -MemberType NoteProperty -Name OSVersion -Value "$(2018+$server.ReadCount)"
    $serverObject | Add-Member -MemberType NoteProperty -Name Uptime -Value "00:0$($server.ReadCount):0$($server.ReadCount):0$($server.ReadCount)"
    $serverObject | Add-Member -MemberType NoteProperty -Name LastRebootDetails -Value "Reboot on $($server.ReadCount)am"
    $serverObject | Add-Member -MemberType NoteProperty -Name Manufacturer -Value "ASUSTek$($server.ReadCount)"
    $serverObject | Add-Member -MemberType NoteProperty -Name Model -Value "UX430R$($server.ReadCount)"
    $serverObject | Add-Member -MemberType NoteProperty -Name NumberOfCpuCores -Value "$(2*$server.ReadCount)"
    $serverObject | Add-Member -MemberType NoteProperty -Name MemoryRAM -Value "$(4*$server.ReadCount)GB"
    $serverObject | Add-Member -MemberType NoteProperty -Name DiskCapacity -Value "$(200*$server.ReadCount)GB"
    $serverObject | Add-Member -MemberType NoteProperty -Name DiskUsage -Value "$(20*$server.ReadCount)%"
    
    Write-Host $serverObject
    $allServer += $serverObject
} 

# ConvertTo-Json $allServer | out-file -FilePath "$env:HOMEDRIVE$env:HOMEPATH\ServerObjectList.json" # convert object to json file
$allServer | Export-Csv -Path "$env:HOMEDRIVE$env:HOMEPATH\ServerObjectList.csv" # export object to csv file

$serverobject = Import-Csv -Path "$env:HOMEDRIVE$env:HOMEPATH\ServerObjectList.csv" # import items in CSV to objects
$serverobject | Format-Table # format the output as table

foreach ($server in $serverlist) # for each server in serverlist retrieve the corresponding information from csv
{ 
    if ($serverobject.ComputerName -contains $server) # if server is present in csv, retrieve server information
    {
        $serverObject | Where-Object -Property ComputerName -eq $server # Display required server information
    } else { # if server is not present in csv, display error message
        Write-host "Error: No such server host found in csv for $server."
    }
}