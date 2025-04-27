configuration CREATEWFC
{
   param
   (
        [String]$SQLClusterName,
        [String]$PrivateSubnet,             
        [String]$NetBiosDomain,
        [System.Management.Automation.PSCredential]$Admincreds
    )

    Import-DscResource -Module xFailoverCluster # Used for Reboots

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        xCluster CreateCluster
        {
            Name = $SQLClusterName
            DomainAdministratorCredential = $DomainCreds
        }

       Script RemovePrimaryNICFromCluster
        {
            SetScript =
            {
                # Variables
                $Cluster = (Get-ClusterNetworkInterface | Where-Object {$_.Ipv4Addresses -like "$using:PrivateSubnet"+"*"}).Network
                (Get-ClusterNetwork $Cluster[0].Name).Role = "None"
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $AdminCreds
            DependsOn = '[xCluster]CreateCluster'
        }
    }
}