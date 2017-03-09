#This tiny powershell script is scanning an IP range from 0 to 254 to find other devices in the local network
#The IPs that give an answer are saved in the $OutputFile which can be specified below.

$OutputFile = "C:\temp\ping4.txt"; #File to save the responding IPs
$IPAdressRoot = "192.168.2." #part of network that should be scanned i.e. "192.168.2." for "192.168.2.xxx"
$PingTimeout = 300
$PingNumber = 1

for ($i=0;$i -lt 255; $i++){
$IPFull = $IPAdressRoot + $i;
"IP Adress " + $IPFull + ": send ping....";
$OnePing = ping -n $PingNumber -w $PingTimeout $IPFull;
if ($OnePing -like '*ms*'){
$OnePing | Out-File -append $OutputFile; "Found something!`n " + $OnePing}
{no answer}
}