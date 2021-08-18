param(
    [Parameter(Mandatory = $true)][string]$parameterFile,
    [Parameter(Mandatory = $true)][string]$rgName,
    [Parameter(Mandatory = $true)][string]$rgLocation,
    [Parameter(Mandatory = $true)][string]$environment,
    [Parameter(Mandatory = $false)][string]$componentType = "datafactoryv2"
)

$ErrorActionPreference = "Stop"
$scriptRootDirectory = $PSScriptRoot

# $today = Get-Date -Format "yyyyMMddhhmmss"
# $deploymentName = $component + "_" + "Deployment_" + "$today"
#Write-Output $deploymentName
$armComponentName = $parameterFile.parameters.datafactoryv2name.value
$armTemplateParameterFileName = $armComponentName + ".json"
$armTemplateFilePath = $scriptRootDirectory + "/armtemplates/'$componentType'/ARMTemplateForFactory.json"
Write-Debug "Deployment Template Folder Path:'$armTemplateFilePath'"
$templateParameterFileRootPath = Split-Path -Path $scriptRootDirectory -Parent

#Create or check for existing resource group
$resourceGroup = Get-AzureRmResourceGroup -Name $rgName -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    Write-Host "Resource group '$rgName' does not exist. To create a new resource group, please enter a location.";
    if (!$rgLocation) {
        $rgLocation = Read-Host "resourceGroupLocation";
    }
    Write-Host "Creating resource group '$rgName' in location '$rgLocation'";
    New-AzureRmResourceGroup -Name $rgName -Location $rgLocation
}
else {
    Write-Host "Using existing resource group '$rgName'";
}

#Check environment and assign template parameter file
if ($environment) {
    if ($environment -eq "DEV") {
        $templateParameterFilePath = "'$templateParameterFileRootPath'/armTemplates/'$componentType'/templateParameterFile/$armTemplateParameterFileName"
    }
    elseif ($environment -eq "QA") {
        $templateParameterFilePath 
    }
    elseif ($environment -eq "PPD") {
        $templateParameterFilePath 
    }
    elseif ($environment -eq "PROD") {
        $templateParameterFilePath 
    }
}

# Start the deployment
Write-Host "Starting deployment...";
if (Test-Path $templateParameterFilePath) {
    New-AzureRmResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile $armTemplateFilePath -TemplateParameterFile $templateParameterFilePath;
}
else {
    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $armTemplateFilePath;
}