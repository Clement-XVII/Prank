#Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force;
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force;
[system.Diagnostics.Process]::Start("chrome","")
#Active WinRM
Enable-PSRemoting -SkipNetworkProfileCheck –force
Set-Service WinRM -StartMode Automatic
Get-WmiObject -Class win32_service | Where-Object {$_.name -like "WinRM"}
Set-Item WSMan:localhost\client\trustedhosts -value * -force
Get-Item WSMan:\localhost\Client\TrustedHosts

#Récupère le nom et l'ip dans la machine vers un fichier csv sur la clé usb
$lettre = Get-WmiObject -Class Win32_logicaldisk | Where { $_.VolumeName -eq "Autexier" } | ForEach-Object {$_.DeviceID}
#$localIpAddress=((ipconfig | findstr [0-9].\.)[0]).Split()[-1]
$localIpAddress=(Get-NetIPAddress -AddressFamily IPV4 -InterfaceAlias Ethernet).IPAddress
% {$ip=$localIpAddress; Write-output "$ip ;$(test-connection -computername "$ip" -quiet -count 1);$( Resolve-DnsName $ip -ErrorAction Ignore |select -exp NameHost )"} >> "$lettre\liste.csv"

<#Active SSH
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}

$fichier = "C:\Program Files\WindowsPowerShell\Modules\PSModule\PSModule.psm1"

if(Test-Path $fichier) {
    Get-Content $fichier
}
else {
    Copy-Item "$lettre\Modules\PSModule\*" -Destination 'C:\Program Files\WindowsPowerShell\Modules\PSModule' -Recurse
}#>

#Ajout PSModule
if (Get-Module -ListAvailable -Name PSModule) {
        Write-Output "Module exists"
    } else {
        Write-Output "Module does not exist"
        Copy-Item "$lettre\Modules\PSModule\*" -Destination 'C:\Program Files\WindowsPowerShell\Modules\PSModule' -Recurse -Force
        Copy-Item "$lettre\Modules\PSModule\*" -Destination 'C:\Program Files\WindowsPowerShell\Modules\PSModule' -Recurse -Force
	    Copy-Item "$lettre\Modules\PSModule\*" -Destination 'C:\Program Files\WindowsPowerShell\Modules\PSModule' -Recurse
	    Copy-Item "$lettre\Modules\PSModule\*" -Destination 'C:\Program Files\WindowsPowerShell\Modules\PSModule' -Recurse
    }
Import-Module PSModule -Verbose -Force

[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
$msgBoxInput =  [System.Windows.Forms.MessageBox]::Show('Erreur 0x080004675','Google Chrome','Ok','Error')




<#
if (Get-Module -ListAvailable -Name BurntToast) {
    Write-Host "Module Hyper-V exists " -ForegroundColor Green
} else {
    Write-Host "Module does not exist " -ForegroundColor Yellow
    Install-PackageProvider -Name NuGet -force
    Install-Module BurntToast -force
    Import-Module BurntToast -force
    }
New-BurntToastNotification -Text "PowerShell Notification" , "Activation réussie !"
#>