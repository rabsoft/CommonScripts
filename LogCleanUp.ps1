################################################################################
################################################################################
#
#   Description : Log File cleanup script
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
$SystemName = $env:COMPUTERNAME
$Logfolders = @("C:\Logfolder") #Folder where the log files are
$LogArchive = $Logfolder+"\old" #Location to move the unwanted folder if move is used
$Scriptlogfolder = "$ScriptLocation\Logfiles"
$Scriptlogfile = "$Scriptlogfolder\Logclean-$SystemName-$(Get-NZDate -FileDate ).txt"
$FileType = "*.log"  #file types only 1 at a time
$FileAge = 7        #how many days old before doing something with the files
$FileAction = "delete"  #put either (move/delete/test) in this field
$UseLogFile = $True  #use either $TRUE or $FALSE
if($UseLogFile){if(!(test-path $Scriptlogfolder)){md $Scriptlogfolder}}
################################################################################

################################################################################
function log($string)
{
   #$UseLogFile
   if ($UseLogFile) {
       $now = get-date
       "$now --- $string" | out-file -Filepath $Scriptlogfile -append
   }
}
################################################################################

################################################################################
foreach ($Logfolder in $Logfolders){
    ################################################################################
    $allfiles = Get-ChildItem -path $Logfolder -Recurse -Include $FileType
    ($allfiles | ?{$_.LastWriteTime -lt (Get-Date).AddDays(-$FileAge)}).count
    $allfiles.count
    foreach($file in $allfiles){
        if ($file.LastWriteTime -lt (Get-Date).AddDays(-$FileAge)) {
            Switch ($FileAction)
            {
                "move" {
                    #this is the move
                    Try{
                        Move-Item $file.FullName -destination $LogArchive -force -ErrorAction Stop
                        log "$($file.FullName) ----- has been moved to ----- $LogArchive"
                    } catch {
                        log "$($file.FullName) ----- failed to be moved to ----- $LogArchive"
                    }
                }
                "delete" {
                    #this is the delete
                    Try{
                        Remove-Item $file.FullName -force -ErrorAction Stop
                        log "$($file.FullName) ----- has been deleted"
                    } catch {
                        log "$($file.FullName) ----- failed to be deleted"
                    }
                }
                "test" {
                    #this will just log the files that it will touch
                    log "$($file.FullName) ----- will have something done to it"
                }
                default {
                    log "put either move/delete/test in the FileAction field"
                
                }
            }
        }
    }
    ################################################################################
}
################################################################################
