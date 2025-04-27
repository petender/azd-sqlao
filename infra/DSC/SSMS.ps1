Configuration SSMS
{
 
    Import-DscResource -Module ComputerManagementDsc # Used for TimeZone
    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemote
 
    Node localhost
    {
        Registry SchUseStrongCrypto
        {
            Key                         = 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319'
            ValueName                   = 'SchUseStrongCrypto'
            ValueType                   = 'Dword'
            ValueData                   =  '1'
            Ensure                      = 'Present'
        }

        Registry SchUseStrongCrypto64
        {
            Key                         = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319'
            ValueName                   = 'SchUseStrongCrypto'
            ValueType                   = 'Dword'
            ValueData                   =  '1'
            Ensure                      = 'Present'
        }

        WindowsFeature 'NetFramework45'
        {
            Name   = 'NET-Framework-45-Core'
            Ensure = 'Present'
        }


        File SQLSoftware
        {
            Type = 'Directory'
            DestinationPath = 'C:\SQLSoftware'
            Ensure = "Present"
        }

        xRemoteFile SSMS
        {
            DestinationPath = 'C:\SQLSoftware\SSMS-Setup-ENU.exe'
            Uri             = "https://aka.ms/SSMSFullSetup"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn =    "[File]SQLSoftware"
        }


        Script InstallSQLManagementStudio
        {
            SetScript =
            {
                # Install SQL Management Studio
                C:\SQLSoftware\SSMS-Setup-ENU.exe /install /quiet /norestart

            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[xRemoteFile]SSMS'
        }

        TimeZone SetTimeZone
        {
            IsSingleInstance = 'Yes'
            TimeZone         = 'Eastern Standard Time'
        }
     }
  }