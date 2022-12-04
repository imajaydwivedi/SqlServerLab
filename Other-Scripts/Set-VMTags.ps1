# Import VMWare.PowerCLI Module
Import-Module -Name VMware.PowerCLI

# Connect to VIServer
    <# INPUTS => Provide VCenter Server Name
    #>
Connect-VIServer -Server vcsa-01a

$startTime = Get-Date
# Step 01 => Read Content of File containing <Name, App_Name, App_Owner>
    # Assuming catgories with name like 'App_Name' & 'App_Owner' exists
    <# INPUTS => Provide Path of Excel and its WorkSheet Name
    #>
$FileContent = @()
$FileContent += Import-Excel -Path 'vcenter_tags_1.xlsx' -WorksheetName 'Sheet2'


# Step 02 => Iterate through all App_Name tags & Create if not exists
    <# INPUTS => $tagCategoryName
    #>
$tagCategoryName = 'App_Name'
$appNameTagsList = @()
$appNameTagsList += $FileContent | Select-Object -ExpandProperty App_Name -Unique | Where-Object {$_.trim() -ne ''}
$appNameTagsListYet2Create = @()

"Loop through following `$appNameTagsList and validate existence => `n`t$($appNameTagsList -join ', ')" | Write-Host -ForegroundColor Yellow
foreach($appName in $appNameTagsList) {
    try {
        $appNameTag = Get-Tag -Name $appName -ErrorAction Stop
    }
    catch {
        $errMessage = $_
        #$errMessage.ToString() | Write-Host -ForegroundColor Red
        $appNameTagsListYet2Create += $appName
    }
}

"Following Tags are yet to be created => `n`t$($appNameTagsListYet2Create -join ', ')" | Write-Host -ForegroundColor Cyan
"Loop through these '$tagCategoryName' category tags, and create them.." | Write-Host -ForegroundColor Cyan
$tagCategory = Get-TagCategory -Name $tagCategoryName -ErrorAction Stop
# New-TagCategory -Name $tagCategoryName -Description $tagCategoryName

foreach($tag2Create in $appNameTagsListYet2Create)
{
    "Working on tag '$tag2Create'"
    $tagCreated = New-Tag -Name $tag2Create -Category $tagCategory -Description $tag2Create -ErrorAction Stop
}


# Step 03 => Assign App_Name tags
"Loop through '$tagCategoryName' category Tags, and assign them to VMs.." | Write-Host -ForegroundColor Yellow
foreach($tagName in $appNameTagsList) {
    $tagVMS = @()
    $tagVMS += $FileContent | Where-Object {$_.App_Name -eq $tagName} | Select-Object -ExpandProperty Name -Unique | Where-Object {$_.trim() -ne ''}

    "Assign tag '$tagName' to following VMs => `n`t$($tagVMS -join ', ')" | Write-Host -ForegroundColor Cyan

    $vmTag = Get-Tag -Name $tagName -Category $tagCategoryName -ErrorAction Stop
    Get-VM $tagVMS | New-TagAssignment -Tag $vmTag
}


# Step 04 => Iterate through all App_Owner tags & Create if not exists
    <# INPUTS => $tagCategoryName
    #>
$tagCategoryName = 'App_Owner'
$appOwnerTagsList = @()
$appOwnerTagsList += $FileContent | Select-Object -ExpandProperty App_Owner -Unique | Where-Object {$_.trim() -ne ''}
$appOwnerTagsListYet2Create = @()

"Loop through each `$appOwnerTagsList and validate existence.." | Write-Host -ForegroundColor Cyan
foreach($appOwner in $appOwnerTagsList) {
    try {
        $appOwnerTag = Get-Tag -Name $appOwner -ErrorAction Stop
    }
    catch {
        $errMessage = $_
        #$errMessage.ToString() | Write-Host -ForegroundColor Red
        $appOwnerTagsListYet2Create += $appOwner
    }
}

"Following Tags are yet to be created => `n`t$($appOwnerTagsListYet2Create -join ', ')" | Write-Host -ForegroundColor Cyan
"Loop through these '$tagCategoryName' category tags, and create them.." | Write-Host -ForegroundColor Cyan
$tagCategory = Get-TagCategory -Name $tagCategoryName -ErrorAction Stop
# New-TagCategory -Name $tagCategoryName -Description $tagCategoryName

foreach($tag2Create in $appOwnerTagsListYet2Create)
{
    "Working on tag '$tag2Create'"
    $tagCreated = New-Tag -Name $tag2Create -Category $tagCategory -Description $tag2Create -ErrorAction Stop
}


# Step 05 => Assign App_Owner tags
"Loop through '$tagCategoryName' category Tags, and assign them to VMs.." | Write-Host -ForegroundColor Yellow
foreach($tagName in $appOwnerTagsList) {
    $tagVMS = @()
    $tagVMS += $FileContent | Where-Object {$_.App_Owner -eq $tagName} | Select-Object -ExpandProperty Name -Unique | Where-Object {$_.trim() -ne ''}

    "Assign tag '$tagName' to following VMs => `n`t$($tagVMS -join ', ')" | Write-Host -ForegroundColor Cyan

    $vmTag = Get-Tag -Name $tagName -Category $tagCategoryName -ErrorAction Stop
    Get-VM $tagVMS | New-TagAssignment -Tag $vmTag
}

$endTime = Get-Date
$elapsedTime = New-TimeSpan -Start $startTime -End $endTime
"Tag Assignment Completed in $($elapsedTime.TotalMinutes) minutes $($elapsedTime.Seconds) seconds." | Write-Host -ForegroundColor Yellow



