﻿################################################################################
################################################################################
#
#   Description : Log to file
#    Created by : Mark
#    Created on : 31/07/2023
# Last Modified : 
#   Modified By :
#       Version : 1.0
#     Copyright : Mark
#
################################################################################
################################################################################

################################################################################
#Log to file
param(
    [String]$string
)

$Scriptlogfile = ".\Log-$env:COMPUTERNAME-"+$(get-date -format "yyyyMMdd")+".log"
write-host "[$(get-date)] --- $string"
"[$(get-date)] --- $string" | out-file -Filepath $Scriptlogfile -append
################################################################################
