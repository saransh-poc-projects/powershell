param(
    [Parameter(Mandatory = $true)][string]$parameterFile,
    [Parameter(Mandatory = $true)][string]$rgName,
    [Parameter(Mandatory = $true)][string]$rgLocation
)
Install-Module -Name Az.Databricks -AllowPrerelease
$azureDatabricksWorkspaceName = $parameterFile.parameters.azureDatabricksWorkspaceName.value
$azureDatabricksGroupName = $rgName
$azureDatabricksSku = $parameterFile.parameters.azureDatabricksSku.value


$resourceGroup = Get-AzureRmResourceGroup -Name $rgName -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    Write-Host "Resource group '$rgName' does not exist. Create one and try again";
    return "Failed"
}
else {
    Write-Host "Using existing resource group '$rgName'";
}
try {
    New-AzDatabricksWorkspace -Name $azureDatabricksWorkspaceName -ResourceGroupName $rgName -Location $rgLocation -ManagedResourceGroupName $azureDatabricksGroupName -Sku $azureDatabricksSku
}
catch {
    Write-Host "Failure occured while creating Azure Databricks Workspace '$azureDatabricksWorkspaceName'";
}
Write-Output "Workspace present in Resource Group '$rgName' are:"+(Get-AzResource -ResourceType "Microsoft.Databricks/workspaces" -ResourceGroupName $rgName).Name
return "Succeeded"