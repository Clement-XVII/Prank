$Password = "user1"
$Username = "user1"

#Démarre toutes les Sessions du fichier CSV.
Function Start-AllSession()
{
    $ListPCs = Get-Content "C:\Users\user1\Desktop\SalleE03.csv" -Encoding UTF8 | ConvertFrom-Csv -Delimiter ";" | select Machines, Users
    $mdp = ConvertTo-SecureString $Password -AsPlainText -Force
    foreach ($UnPC in $ListPCs) {
        $NomPC = $UnPC.Machines
        $NomUser = $UnPC.Users
        $login = "$NomPC\$Username"
        $mycreds = New-Object System.Management.Automation.PSCredential($login, $mdp)
        $Session = New-PSSession -ComputerName $NomPC -Name $NomUser -Credential $mycreds
	}
}
#Ouvre une Session avec le nom ou l'ip.
Function Start-OneSession()
{
	$ListPCs = Get-Content "C:\Users\user1\Desktop\SalleE03.csv" -Encoding UTF8 | ConvertFrom-Csv -Delimiter ";" | select Machines, Users
    $mdp = ConvertTo-SecureString $Password -AsPlainText -Force
	$users = Read-Host -Prompt "Enter the name of user"

	foreach ($UnPC in $ListPCs) {
		if ($UnPC -match "$users") {
			echo $UnPC
			$NomPC = $UnPC.Machines
            $NomUser = $UnPC.Users
			$login = "$NomPC\$Username"
			$mycreds = New-Object System.Management.Automation.PSCredential($login, $mdp)
			$Session = New-PSSession -ComputerName $NomPC -Name $NomUser -Credential $mycreds
		}
	}
}
#Ouvre une Session avec le nom ou l'ip.
Function Open-OneSession()
{
	$ListPCs = Get-Content "C:\Users\user1\Desktop\SalleE03.csv" -Encoding UTF8 | ConvertFrom-Csv -Delimiter ";" | select Machines, Users
    $mdp = ConvertTo-SecureString $Password -AsPlainText -Force
	$users = Read-Host -Prompt "Enter the name of user"

	foreach ($UnPC in $ListPCs) {
		if ($UnPC -match "$users") {
			echo $UnPC
			$NomPC = $UnPC.Machines
			$login = "$NomPC\$Username"
			$mycreds = New-Object System.Management.Automation.PSCredential($login, $mdp)
			$Session = Enter-PSSession -ComputerName $NomPC -Credential $mycreds
		}
	}
}
#Démarre toutes les Sessions du fichier CSV.
Function Start-AllSession-NoName()
{
    $ListPCs = Get-Content "C:\Users\user1\Desktop\SalleE03.csv" -Encoding UTF8 | ConvertFrom-Csv -Delimiter ";" | select Machines
    $mdp = ConvertTo-SecureString $Password -AsPlainText -Force
    foreach ($UnPC in $ListPCs) {
        $NomPC = $UnPC.Machines
        $login = "$NomPC\$Username"
        $mycreds = New-Object System.Management.Automation.PSCredential($login, $mdp)
        $Session = New-PSSession -ComputerName $NomPC -Name $NomUser -Credential $mycreds
	}
}
#Envoie un script.ps1 à toutes les sessions ouvertes.
Function Send-Script()
{
    $Session = Get-PSSession
    $MyScript = Read-Host -Prompt "Enter the path of the script file ex: C:\test\script.ps1"
    Invoke-Command -FilePath $MyScript -Session $Session
}
#Envoie une commande à toutes les sessions ouvertes.
Function Send-Command()
{
    $Session = Get-PSSession
    $command = Read-Host -Prompt "Enter command to run"
    Invoke-Command -Session $Session -ScriptBlock {
       powershell.exe $Using:command
    }
}
#Redemande en boucle une commande à envoyer aux sessions.
Function Send-Commands()
{
    while($true){
        $Session = Get-PSSession
        $command = Read-Host -Prompt "Enter command to run"
        Invoke-Command -Session $Session -ScriptBlock {
        powershell.exe $Using:command
        }
    }
}
#Ajoute une musique sur les pcs cibles.
Function Add-Music()
{
    $Session = Get-PSSession
    $cheminaudio = "C:\Program Files\WindowsPowerShell\Modules\PSModule\AudioFiles\"

    $audio = Read-Host -Prompt "Enter the path of the WAV file ex: C:\test\meme.wav"
    Write-Host "Configured path: $audio `n" -ForegroundColor Green

    Copy-Item -Path $audio -Destination $cheminaudio -ToSession $Session
}
#Ajoute et joue une musique sur les pcs cibles.
Function Add-Play-Music
{
    $Session = Get-PSSession
    $cheminaudio = "C:\Program Files\WindowsPowerShell\Modules\PSModule\AudioFiles\"

    $audio = Read-Host -Prompt "Enter the path of the WAV file ex: C:\test\meme.wav"
    Write-Host "Configured path: $audio `n" -ForegroundColor Green

    Copy-Item -Path $audio -Destination $cheminaudio -ToSession $Session

    $audiofile = Get-Item $audio
    $nomfile = $audiofile.Basename + $audiofile.Extension

    Invoke-Command -Session $Session -ScriptBlock { 
		$sound = new-Object System.Media.SoundPlayer;
		$sound.SoundLocation="C:\Program Files\WindowsPowerShell\Modules\PSModule\AudioFiles\$Using:nomfile";
		$sound.Play();
    }
}
#Joue une musique sur les pcs cibles grace au nom donné.
Function Play-Music()
{
    $Session = Get-PSSession
    $audio = Read-Host -Prompt "Enter the name of the WAV file ex: meme.wav"
    Write-Host "Configured path: $audio `n" -ForegroundColor Green
    Invoke-Command -Session $Session -ScriptBlock { 
        

        $sound = new-Object System.Media.SoundPlayer;
        $sound.SoundLocation="C:\Program Files\WindowsPowerShell\Modules\PSModule\AudioFiles\$Using:audio";
        $sound.Play();
    }
}
#Eject tout les périfiériques en fonction du type
Function Eject-ALLCD()
{
    $Session = Get-PSSession
    Write-Host "CDRom                       5`nFixed(External/Fixed Disk)  3`nNetwork                     4`nNoRootDirectory             1`nRam                         6`nRemovable(USB Drive)        2`nUnknown                     0`n"
    $type = Read-Host -Prompt "Enter the Drive Type"
    
    Invoke-Command -Session $Session -ScriptBlock {
        $lettre = Get-WmiObject -Class Win32_logicaldisk | Where { $_.DriveType -eq "$Using:type" } | ForEach-Object {$_.DeviceID}
        foreach ($UnPC in $lettre) {
            (new-object -COM Shell.Application).NameSpace(17).ParseName("$UnPC").InvokeVerb("Eject")
        }
    }
}
#Supprime toutes les sessions ouvertes.
Function Remove-AllSession()
{
    $s = Get-PSSession
    Remove-PSSession -Session $s
}
#Suppime une sessions ouvertes avec le nom.
Function Remove-OneSession()
{
    $ListPCs = Get-Content "C:\Users\user1\Desktop\SalleE03.csv" -Encoding UTF8 | ConvertFrom-Csv -Delimiter ";" | select Machines, Users
    $mdp = ConvertTo-SecureString $Password -AsPlainText -Force
    $users = Read-Host -Prompt "Enter the name of user"

    foreach ($UnPC in $ListPCs) {
        if ($UnPC -match "$users") {
            $NomUser = $UnPC.Users
            Remove-PSSession -Name $NomUser
        }
    }
}