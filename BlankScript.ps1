################################################################################
################################################################################
#
#   Description : 
#    Created by : Mark
#    Created on : 
# Last Modified : 
#   Modified By :
#       Version : 1.0
#     Copyright : Mark
#
################################################################################
################################################################################

################################################################################
# Couple of different ways to get the script location
Function Get-ScriptPath()
{
    #get local path
    $scriptPath = "."
    if ($PSScriptRoot){$scriptPath = $PSScriptRoot} else {$scriptPath = (Get-Item -Path ".\").FullName}
    return $scriptPath
}

if(!$PSScriptRoot){
    try{$ScriptLocation = Split-Path $MyInvocation.MyCommand.Path -Parent -erroraction stop} catch {$ScriptLocation = Get-ScriptPath}
} else {
    $ScriptLocation = $PSScriptRoot
}

# Set Default Location
Set-location $ScriptLocation

# Set Culture to your location eg NZ
[System.Threading.Thread]::CurrentThread.CurrentUICulture = "en-NZ"
[System.Threading.Thread]::CurrentThread.CurrentCulture = "en-NZ"
################################################################################

################################################################################
#Logfile
$Scriptlogfile = "$ScriptLocation\Log-$env:COMPUTERNAME-"+$(get-date -format "yyyyMMdd")+".txt"
function log($string)
{
    "[$(get-date)] --- $string" | out-file -Filepath $Scriptlogfile -append
}
################################################################################

################################################################################
# Send Email Function example
$EmailToList = @("mark@Someplace.co.nz")
$SmtpServer = ""
function SendEmail ($subject, $body)
{
    $From = "$($ENV:Computername)@Someplace.co.nz"
    $anonUsername = "anonymous"
    $anonPassword = ConvertTo-SecureString -String "anonymous" -AsPlainText -Force
    $anonCredentials = New-Object System.Management.Automation.PSCredential($anonUsername,$anonPassword)
    Send-MailMessage -To $EmailToList -from $From -Subject $subject -Body $body -SmtpServer $SmtpServer -credential $anonCredentials
}
################################################################################

################################################################################
# A function to strip all unwanted characters
function RemoveSpecialCharacters ($CleanMe)
{
    return ((($CleanMe.Replace("(R)","")) -replace '[^\p{L}\p{Nd}/@.]', ' ') -replace '\s+',' ')
}
################################################################################

################################################################################
# Find the N'th day of a day in the current month
function FindnthDay ($FindNthDay, $WeekDay)
{
    # Find the N'th day of a day in the current month
    [datetime]$Today=[datetime]::NOW
    $todayM=$Today.Month.ToString()
    $todayY=$Today.Year.ToString()
    [datetime]$StrtMonth=$todayM+'/1/'+$todayY
    while ($StrtMonth.DayofWeek -ine $WeekDay ) { $StrtMonth=$StrtMonth.AddDays(1) }
    return $StrtMonth.AddDays(7*($FindNthDay-1))
}
#FindnthDay 2 Saturday
################################################################################

################################################################################
# Get the NZ date format
function Get-NZDate {
    Param ($DateTime = $(get-date),[switch]$Longdate,[switch]$ShortDate,[switch]$FileDate)
    $NZDate = New-Object psobject | select ShortDate,LongDate,FileDate
    $NZDate.LongDate = Get-date $DateTime -Format "dd/MM/yyyy HH:mm:ss"
    $NZDate.ShortDate = Get-Date $DateTime -Format "dd/MM/yyyy"
    $NZDate.FileDate = Get-Date $DateTime -Format "yyyy-MM-dd"
    if ($FileDate){return $NZDate.FileDate}
    ElseIf ($ShortDate){return $NZDate.ShortDate}
    Else {return $NZDate.LongDate}
}
################################################################################

################################################################################
# HTML Style sheet
$HTMLStyle="
<style>
    body {background-color:white; font-family:Tahoma; font-size:10pt; text-align: center; }
    h1, h5, th { text-align: center; }
    table { margin: auto; font-family: Segoe UI; box-shadow: 10px 10px 5px #888; border: thin ridge grey; text-align: left; }
    th { background: #0046c3; color: #fff; max-width: 400px; padding: 5px 10px; }
    td { font-size: 11px; padding: 5px 20px; color: #000; }
    tr { background: #b8d1f3; }
    tr:nth-child(even) { background: #dae5f4; }
    tr:nth-child(odd) { background: #b8d1f3; }
</style>
"
################################################################################


################################################################################
################################################################################
# Main Script



################################################################################
################################################################################
