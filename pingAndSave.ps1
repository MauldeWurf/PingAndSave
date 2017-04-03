#This tiny powershell script is scanning an IP range from 0 to 254 to find other devices in the local network
#The IPs that give an answer are saved in the $OutputFile which can be specified below.

$OutputFile = "C:\temp\PingIPRange.log"; #File to save the responding IPs
$IPAdressRoot = "192.168.2." #part of network that should be scanned i.e. "192.168.2." for "192.168.2.xxx"
$PingTimeout = 10
$PingNumber = 1
$ListOfIP = New-Object System.Collections.ArrayList
$Date = Get-Date

Function LogWrite
{
Param ([string]$logstring)
Write-Host $logstring
$logstring | Out-File -append $OutputFile;
}
LogWrite "`n_________________________________________________________________________`n"
LogWrite "Starting IP-Scan...."
LogWrite $Date
LogWrite ("Ping TimeOut: " + [string]$PingTimeout)
LogWrite ("Ping Number of trys per IP: "+ [string]$PingNumber)
LogWrite "`n_________________________________________________________________________`n"

for ($i=0;$i -lt 256; $i++){
$IPFull = $IPAdressRoot + $i;
"IP Adress " + $IPFull + ": send ping....";
$OnePing = ping -n $PingNumber -w $PingTimeout $IPFull;
if ($OnePing -like '*ms*'){
$OnePing | Out-File -append $OutputFile;
"Found something!`n " + $OnePing;
$ListOfIP.Add($IPFull);
}
{no answer}
}
LogWrite "`n============================================="
LogWrite "List of IPs that answered to Ping:"
LogWrite "=============================================`n"
foreach ($IP in $ListOfIP)
{
LogWrite $IP;
}
LogWrite ("`nNumber of Elements found: " + $ListOfIP.Count)
LogWrite "_____________________________________________`n"

$End = Read-Host -Prompt 'Press any key to continue'