#The search string you want to look for
$StringToSearchFor = "Something to search for"

# The root location you want to start searching from
$LocationToSearch = "C:\"

#Edit the Includes to say what file types you want to search in
$Includes = @("*.vbs","*.ps1","*.txt","*.cfg","*.csv","*.doc","*.bat","*.cmd","*.log")

$AllFiles = Get-ChildItem -Path $LocationToSearch -Include $Includes -recurse -ErrorAction SilentlyContinue
$FilesInSearch = $AllFiles | Select-String -pattern $StringToSearchFor | Select-Object Path

#Show all the files the search string was found in
$FilesInSearch

# Show file count 
Write-host "The search string was found in ($(@($FilesInSearch.count))) files"
