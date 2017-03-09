$OutputFile = "C:\temp\ping4.txt";
for ($i=0;$i -lt 255; $i++){
"Portnumber: " + $i + ": send ping....";
$OnePing = ping -n 1 192.168.2.$i;
if ($OnePing -like '*ms*'){
$OnePing | Out-File -append $OutputFile; "positive answer at: " + $OnePing}
{no answer}
}