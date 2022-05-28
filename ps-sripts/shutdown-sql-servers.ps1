
# shut down dc & sqlmonitor
stop-computer -computername @('dc','sqlmonitor') -force -asjob -verbose

# shut down ag nodes
$nodes = @("sqlprod-a","sqlprod-b","sqlprod-c","sqldr-a","sqldr-b","sqldr-c")
foreach($node in $nodes)
{
    if(test-connection $node) {
        Stop-Computer -ComputerName $node -Verbose -force 
        Start-Sleep -Seconds 10
    }
}
