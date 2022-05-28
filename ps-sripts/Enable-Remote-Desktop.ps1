# Lab.com
$Computers = @('DC','SqlMonitor','SqlMonitor-Uat','SqlMonitor-Dev')
$Computers = @('SqlPractice')
$Computers = @('SqlProd-A','SqlProd-B','SqlProd-c','SqlDr-A','SqlDr-B','SqlDr-C')
foreach ($comp in $Computers) {
    "Working on [$comp].." | Write-Host -ForegroundColor Yellow
    $ssn = New-PSSession -ComputerName $comp
    Invoke-Command -Session $ssn -ScriptBlock {
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0;
        Enable-NetFirewallRule -DisplayGroup "Remote Desktop";
    }
    $ssn | Remove-PSSession
}
