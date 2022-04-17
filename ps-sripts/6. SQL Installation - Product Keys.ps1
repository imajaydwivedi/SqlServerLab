$pKeyServerEdition = @();

# SQL Server 2012
$pKeyServerEdition += (New-Object -TypeName psobject -Property $props @{
        'Version' = '2012';
        'Edition' = 'Enterprise';
        'pKey' = 'someg-arbag-evalu-inher-edone';
})

$pKeyServerEdition += (New-Object -TypeName psobject -Property $props @{
        'Version' = '2012';
        'Edition' = 'Standard';
        'pKey' = 'someg-arbag-evalu-inher-edone';
    })

$pKeyServerEdition += (New-Object -TypeName psobject -Property $props @{
        'Version' = '2012';
        'Edition' = 'Developer';
        'pKey' = 'someg-arbag-evalu-inher-edone';
    })

# SQL Server 2014
$pKeyServerEdition += (New-Object -TypeName psobject -Property $props @{
        'Version' = '2014';
        'Edition' = 'Enterprise';
        'pKey' = 'someg-arbag-evalu-inher-edone';
    })

$pKeyServerEdition += (New-Object -TypeName psobject -Property $props @{
        'Version' = '2014';
        'Edition' = 'Standard';
        'pKey' = 'someg-arbag-evalu-inher-edone';
    })

$pKeyServerEdition += (New-Object -TypeName psobject -Property $props @{
        'Version' = '2014';
        'Edition' = 'Developer';
        'pKey' = 'someg-arbag-evalu-inher-edone';
    })

# SQL Server 2016   
$pKeyServerEdition += (New-Object -TypeName psobject -Property $props @{
        'Version' = '2016';
        'Edition' = 'Enterprise';
        'pKey' = 'someg-arbag-evalu-inher-edone';
    })

$pKeyServerEdition += (New-Object -TypeName psobject -Property $props @{
        'Version' = '2016';
        'Edition' = 'Standard';
        'pKey' = 'someg-arbag-evalu-inher-edone';
    })
    
$pKeyServerEdition += (New-Object -TypeName psobject -Property $props @{
        'Version' = '2016';
        'Edition' = 'Developer';
        'pKey' = '22222-00000-00000-00000-00000'
    })
    
# SQL Server 2017
$pKeyServerEdition += (New-Object -TypeName psobject -Property $props @{
        'Version' = '2017';
        'Edition' = 'Enterprise';
        'pKey' = 'someg-arbag-evalu-inher-edone';
    })

$pKeyServerEdition += (New-Object -TypeName psobject -Property $props @{
        'Version' = '2017';
        'Edition' = 'Standard';
        'pKey' = 'someg-arbag-evalu-inher-edone';
    })
    
$pKeyServerEdition += (New-Object -TypeName psobject -Property $props @{
        'Version' = '2017';
        'Edition' = 'Developer';
        'pKey' = '22222-00000-00000-00000-00000'
    })


#$pKeyServerEdition
<#
($pKeyServerEdition | Where-Object {$_.Edition -eq 'Enterprise' -and $_.Version -eq '2012'}).pKey
($pKeyServerEdition | Where-Object {$_.Edition -eq 'Enterprise' -and $_.Version -eq '2014'}).pKey
($pKeyServerEdition | Where-Object {$_.Edition -eq 'Enterprise' -and $_.Version -eq '2016'}).pKey
($pKeyServerEdition | Where-Object {$_.Edition -eq 'Developer' -and $_.Version -eq '2016'}).pKey
#>