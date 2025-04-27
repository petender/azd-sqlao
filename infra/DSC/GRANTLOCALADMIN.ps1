configuration GRANTLOCALADMIN
{
   param
   (
        [String]$TimeZone,        
        [String]$Account,
        [String]$NetBiosDomain
    )

    Import-DscResource -ModuleName ComputerManagementDsc

    Node localhost
    {
        TimeZone SetTimeZone
        {
            IsSingleInstance = 'Yes'
            TimeZone         = $TimeZone
        }

        Script GrantLocalAdmin
        {
            SetScript =
            {
                $AccountCheck = Get-LocalGroupMember -Group Administrators -Member "$using:NetBiosDomain\$Using:Account" -ErrorAction 0
                IF ($AccountCheck -eq $null){Add-LocalGroupMember -Member "$using:NetBiosDomain\$Using:Account" -Group Administrators}
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }

    }
}