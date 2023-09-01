################################################################################
################################################################################
#
#   Description : Get the date in New Zealand Format
#    Created by : Mark
#    Created on : 31/07/2023
# Last Modified : 
#   Modified By :
#       Version : 1.0
#     Copyright : Mark
#
################################################################################
################################################################################

Param (
    $DateTime = $(get-date),
    [switch]$Longdate,
    [switch]$ShortDate,
    [switch]$FileDate
)

$NZDate = New-Object psobject | select ShortDate,LongDate,FileDate
$NZDate.LongDate = Get-date $DateTime -Format "dd/MM/yyyy HH:mm:ss"
$NZDate.ShortDate = Get-Date $DateTime -Format "dd/MM/yyyy"
$NZDate.FileDate = Get-Date $DateTime -Format "yyyy-MM-dd"
if ($FileDate){return $NZDate.FileDate}
ElseIf ($ShortDate){return $NZDate.ShortDate}
Else {return $NZDate.LongDate}
