configuration INSTALLWFC
{
    Import-DscResource -Module ComputerManagementDsc # Used for TimeZone
    Import-DscResource -Module xPendingReboot # Reboot

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        TimeZone SetTimeZone
        {
            IsSingleInstance = 'Yes'
            TimeZone         = 'Eastern Standard Time'
        }

        WindowsFeature Failover-Clustering
        {
            Ensure = 'Present'
            Name = 'Failover-Clustering'
        }
        
        WindowsFeature RSAT-Clustering
        {
            Ensure = 'Present'
            Name = 'RSAT-Clustering'
            IncludeAllSubFeature = $true
        }

       Script AllowLBProbe
        {
            SetScript =
            {
                $firewall = Get-NetFirewallRule "Azure LB Probe" -ErrorAction 0
                IF ($firewall -eq $null) {New-NetFirewallRule -DisplayName "Azure LB Probe" -Direction Inbound -LocalPort 1433,59999,5022 -Protocol TCP -Action Allow}
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }

        PendingReboot BeforeWFCConfig
        {
            Name       = 'BeforeWFCConfig'
            DependsOn  = '[Script]AllowLBProbe'
        }
    }
}