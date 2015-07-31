# Creates web.config files for a DNN site to enable long duration cacheing

# Tramples any existing web.config files in the places it attacks.
param([string] $webSiteRootFolder = '.')

if (!(Test-Path "$webSiteRootFolder\Portals")) {
    Write-Host "Usage - takes a single parameter named webSiteRootFolder.  It should be the root folder of a DNN site."
    Write-Host "The path $webSiteRootFolder does not look to be the root folder of a DNN site.  It has no Portals folder"
    return
}

# Folders that apply to the entire installation
.\SetupCachingForFolder -webSiteRootFolder $webSiteRootFolder -relativeFolder 'Portals\_default' -location 'default.css'
.\SetupCachingForFolder -webSiteRootFolder $webSiteRootFolder -relativeFolder 'Resources\Libraries' -location '.'
.\SetupCachingForFolder -webSiteRootFolder $webSiteRootFolder -relativeFolder 'js' -location '.'
.\SetupCachingForFolder -webSiteRootFolder $webSiteRootFolder -relativeFolder 'Resources\Shared\Scripts' -location '.'
.\SetupCachingForFolder -webSiteRootFolder $webSiteRootFolder -relativeFolder 'Resources\Shared\Components' -location '.'

# Folders/Files that apply to all portals but have to be specified per portal
# Policy - each portal should have a CachedFiles folder.  Move the stuff that you want cached into it start with the Logo and the favicon files.

# Pick out the folders with only a number as their name
$portalFolders = Get-ChildItem -Path "$webSiteRootFolder\Portals" | Where-Object {$_.Name -match '^\d+$' }
foreach ($portalFolder in $portalFolders) {

    # Create a cachedfiles folder if there is not one there already
    $cachedFilesFolder = "$webSiteRootFolder\Portals\$($portalFolder.Name)\CachedFiles"
    if (!(Test-Path $cachedFilesFolder)) {
        mkdir $cachedFilesFolder
        Write-Host "$cachedFilesFolder Folder created"
        Write-Host "Don't forget to shift logo and favicon into the CachedFiles folder"
        Write-Host
    }
    .\SetupCachingForFolder -webSiteRootFolder $webSiteRootFolder -relativeFolder "Portals\$($portalFolder.Name)\CachedFiles" -location '.'

    .\SetupCachingForFolder -webSiteRootFolder $webSiteRootFolder -relativeFolder "Portals\$($portalFolder.Name)" -location 'portal.css'
}