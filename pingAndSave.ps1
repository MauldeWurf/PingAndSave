#This tiny powershell script is scanning an IPv4 range from 0 to 255 to find other devices in the local network
#The IPs that give an answer are saved in the $OutputFile which can be specified below.

$OutputFile = "C:\temp\PingIPRange.log"; #File to save the responding IPs
$IPAdressRoot = "192.168.2." #part of network that should be scanned i.e. "192.168.2." for "192.168.2.xxx"
$PingTimeout = 50
$PingNumber = 1
$ListOfIP = New-Object System.Collections.ArrayList
$Date = Get-Date
$webC = New-Object System.Net.Webclient

Function LogWrite
{
Param ([string]$logstring)
Write-Host $logstring
$logstring | Out-File -append $OutputFile;
}

Function AskResponse
{
#use the .Net.Webclient to ask for the frontpage of the device in the network. A shorter timeout would improve the speed of this process without loosing accuracy.
Param ([string]$IPtoContact)
$responseString =""
$IPtoContact = "http://" + $IptoContact
$UriLocal = New-Object System.Uri($IPtoContact)
Try{
    $responseString = $webC.DownloadString($UriLocal)
}
Catch{
    $ErrorMessage = $_.Exception.Message
    return ("ErrorCode" + $ErrorMessage)
    
}
return $responseString
}

Function Recognize
{
#using particular words to recognize the different devices that are actually present in this house. This function has to be adapted to new devices,
#by looking at the $responseString to find characteristic phrases. Devices that immideatly ask for an authorization can not be distinguished.
#However, this works fine here.
Param ([string]$ResponseString)
 if($ResponseString.Contains("Speedport W 723V")){ return "Router"}
 if($ResponseString.Contains("Canon")){ return "Printer"}
 if($ResponseString.Contains("www.w3.org/1999/xhtml")){ return "WIFI-Extender"}
 if($ResponseString.Contains("ErrorCode")){
    if($ResponseString.Contains("401")){ return "TP-link/authorized only"}
    if($ResponseString.Contains("404")){ return "not responding 404"}
    else {return "User device/not responding"}
    }
 else {return "???"}


}

LogWrite "`n_________________________________________________________________________`n"
LogWrite "Starting IP-Scan...."
LogWrite $Date
LogWrite ("Ping TimeOut: " + [string]$PingTimeout)
LogWrite ("Ping Number of trys per IP: "+ [string]$PingNumber)
LogWrite "`n_________________________________________________________________________`n"

for ($i=0;$i -lt 256; $i++){ #for full scan use 256
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
    $ResponseString = AskResponse $IP
    $DeviceName = Recognize($ResponseString)
    LogWrite ($IP + ": " + $DeviceName)
}

LogWrite ("`nNumber of Elements found: " + $ListOfIP.Count)
LogWrite "_____________________________________________`n"

$End = Read-Host -Prompt 'Press any key to continue'