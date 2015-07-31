#
Param([string] $webSiteRootFolder, [string] $relativeFolder, [string] $location)
Write-Host $webSiteRootFolder $relativeFolder $location

Write-Host "Setting up web.config to cache"

$f = ".\SetupCachingForFolderTemplate.config"

$webConfigFileLocation = "$webSiteRootFolder\$relativeFolder\web.config"

(Get-Content $f) | ForEach-Object {$_ -replace "locationToCache", $location} | Set-Content -path $webConfigFileLocation

Write-Host "Completed setting up $webConfigFileLocation to cache"
