configuration ROUTING
{
   param
   (
        [String]$NextHop,
        [String]$PrivateSubnet,
        [String]$PublicSubnet
    )

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        Script UnregisterNIC
        {
            SetScript =
            {
                # UnRegister NIC 2
                $PrivateAdapter = Get-NetIPAddress | Where-Object {$_.IPAddress -like "$using:PrivateSubnet"+"*"}
                Set-DnsClient -InterfaceAlias $PrivateAdapter.InterfaceAlias -RegisterThisConnectionsAddress:$False                
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }

       Script AddStaticRoute2ndNic
        {
            SetScript =
            {
                $RouteCheck = Get-NetRoute | Where-Object {$_.NextHop -like "$using:NextHop"}
                IF ($RouteCheck -eq $Null) {
                $PublicAdapter = Get-NetIPAddress | Where-Object {$_.IPAddress -like "$using:PublicSubnet"+"*"}
                New-NetRoute -DestinationPrefix "0.0.0.0/0" -InterfaceIndex $PublicAdapter.InterfaceIndex -NextHop "$using:NextHop"
                }
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }
    }
}