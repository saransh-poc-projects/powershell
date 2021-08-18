param(
    [Parameter(Mandatory = $true)][string]$parameterFile,
    [Parameter(Mandatory = $true)][string]$rgName,
    [Parameter(Mandatory = $true)][string]$rgLocation
)
$storageAccountName = $parameterFile.parameters.storageAccountName.value
$skuName = $parameterFile.parameters.storageAccountSkuName.value

# Create the storage account.
$storageAccount = New-AzStorageAccount -ResourceGroupName $rgName `
    -Name $storageAccountName `
    -Location $rgLocation `
    -SkuName $skuName

if ($storageAccount) {
    retrun "Succeeded"
}
else {
    return "Failed"
}