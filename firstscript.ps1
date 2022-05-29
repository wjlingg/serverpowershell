Write-Host "Starting powershell script..."
Write-Host "Getting information from a list of servers..."
Write-Host "Below are all the available servers:"
# get-content -Path "..\ServerList.txt" # kept the text file in home directory under script folder hence "..\" is used
# get-childitem ENV: # returns a list of your environment variables
# $ENV:COMPUTERNAME # returns the name of your computer
$serverlist = @(get-content -Path "$env:HOMEDRIVE$env:HOMEPATH\ServerList.txt") 

foreach ($server in $serverlist)
{
    write-host "Server: $server"
} 