#Script to manage all actions related to Storage accounts
$action = Read-Host -Prompt "Enter action to be performed"

if ($action -eq 'Move') {
  ##################################################################
  # 1. Moving a storage account from 1 RG to another
  ##################################################################

  $srcResourceGroupName = Read-Host -Prompt "Enter the source Resource Group name"
  $destResourceGroupName = Read-Host -Prompt "Enter the destination Resource Group name"
  $storageAccountName = Read-Host -Prompt "Enter the storage account name"

  $storageAccount = Get-AzResource -ResourceGroupName $srcResourceGroupName -ResourceName $storageAccountName
  Move-AzResource -DestinationResourceGroupName $destResourceGroupName -ResourceId $storageAccount.ResourceId
  
}



