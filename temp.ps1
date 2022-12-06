
Add-Type -AssemblyName PresentationCore,PresentationFramework
$msgBody = "Reboot the computer now?"
$msgTitle = "Confirm Reboot"
$msgButton = 'YesNoCancel'
$msgImage = 'Warning'

function msgbox {
$msgBoxInput = [System.Windows.MessageBox]::Show($msgBody,$msgTitle,$msgButton,$msgImage)


  switch  ($msgBoxInput) {

  'Yes' {
    msgbox
  }

  'No' {

    msgbox

  }
  'cancel'{
    msgbox
  }
}
}
msgbox
------------------------------------------------------------------------------------------------------

$MYJOB = Start-Job -ScriptBlock {

  $MOVEMENTSIZE = 50
  $SLEEPTIME = 5
  
  Add-Type -AssemblyName System.Windows.Forms
  while ($true) {
  $POSITION = [Windows.Forms.Cursor]::Position
  $POSITION.x += $MOVEMENTSIZE
  $POSITION.y += $MOVEMENTSIZE
  [Windows.Forms.Cursor]::Position = $POSITION
  Start-Sleep -Seconds $SLEEPTIME
  $POSITION = [Windows.Forms.Cursor]::Position
  $POSITION.x -= $MOVEMENTSIZE
  $POSITION.y -= $MOVEMENTSIZE
  [Windows.Forms.Cursor]::Position = $POSITION
  Start-Sleep -Seconds $SLEEPTIME
  }
  }

---------------------------------------------------------------------------------------------------------

$hWnd = [WPIA.ConsoleUtils]::GetConsoleWindow()
[WPIA.ConsoleUtils]::ShowWindow($hWnd, 0)
  Add-Type -AssemblyName System.Windows.Forms

  while ($true)
  {
    $Pos = [System.Windows.Forms.Cursor]::Position
    $x = ($pos.X % 500) + 1
    $y = ($pos.Y % 500) + 1
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
    Start-Sleep -Seconds 10
  }
  ---------------------------------------------------------------------------------------------------------
  Add-Type -AssemblyName System.Windows.Forms
Add-Type -Name ConsoleUtils -Namespace WPIA -MemberDefinition @'
   [DllImport("Kernel32.dll")]
   public static extern IntPtr GetConsoleWindow();
   [DllImport("user32.dll")]
   public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'@

# Hide Powershell window
$hWnd = [WPIA.ConsoleUtils]::GetConsoleWindow()
[WPIA.ConsoleUtils]::ShowWindow($hWnd, 0)

Clear-Host

param($sleep = 5) # Seconds
$plusOrMinus = 1 # Mouse position increment or decrement
$wshell = New-Object -ComObject wscript.shell

$index = 0
while ($true)
{
  # Press ScrollLock key
  $wshell.SendKeys("{SCROLLLOCK}")
  Start-Sleep -Milliseconds 200
  $wshell.SendKeys("{SCROLLLOCK}")
  
  # Move mouse
  $p = [System.Windows.Forms.Cursor]::Position
  $x = $p.X + $plusOrMinus
  $y = $p.Y + $plusOrMinus
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
  $plusOrMinus *= -1
  
  # Sleep
  Start-Sleep -Seconds $sleep	
}


$ComputerName = "Orion_IX"
   
Remove-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "Hostname" 
Remove-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "NV Hostname" 

Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Computername\Computername" -name "Computername" -value $ComputerName
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Computername\ActiveComputername" -name "Computername" -value $ComputerName
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "Hostname" -value $ComputerName
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "NV Hostname" -value  $ComputerName
Set-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -name "AltDefaultDomainName" -value $ComputerName
Set-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -name "DefaultDomainName" -value $ComputerName
