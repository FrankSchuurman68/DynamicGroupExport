<#

Author: Frank Schuurman
Organization: WilroffReitsma BV

.SYNOPSIS 
List Name and Rules of Dynamic AD and  Distribtuion Groups

.DESCRIPTION
List Name and Rules of Dynamic AD and  Distribtuion Groups

.PARAMETER
No Parameters required

#>

Connect-AzureAD
Connect-ExchangeOnline

Import-Module AzureADPreview -force
Import-Module ExchangeOnlineManagement

$enddate = (Get-Date).tostring("yyyyMMdd")
$FileName1 = "c:\temp\"+$enddate+"DynamicADGroups.csv"
$FileName2 = "c:\temp\"+$enddate+"DynamicMailGroups.csv"

$aadmsg = Get-AzureADMSGroup -All:$True | Where {($_.GroupTypes -eq 'DynamicMembership')} 
foreach ($name in $aadmsg) {
    
    ForEach-Object {
        Get-AzureADMSGroup -id $name.id | Select-Object Displayname, Membershiprule | Export-Csv -Path $FileName1 -NoTypeInformation -append
        } 
    } 
   

$olDDG = Get-DynamicDistributionGroup
foreach($id in $olDDG) {

    ForEach-Object {
         Get-DynamicDistributionGroup -id $id.id | Select-Object identity, RecipientFilter, WindowsEmailAddress | Export-Csv -Path $FileName2 -NoTypeInformation -append
    }
   }
