param(
    [Parameter(Mandatory = $true)][string]$parameterFile,
    [Parameter(Mandatory = $false)][string]$linkedTemplate,
    [Parameter(Mandatory = $false)][string]$provisionListFileName = "devProvisionConfig.csv",
    [switch]$validate,
    [switch]$deploy
)

#******************************************************************************
# Script body
# Execution begins here
#******************************************************************************
$ErrorActionPreference = "Stop"
$parentScriptDirectory = Get-Location

$parentScriptRootDirectory = Split-Path -Path $parentScriptDirectory -Parent
Write-Debug "Script Root Folder Path:'$parentScriptRootDirectory'"

$parameterFilesRootPath = $parentScriptRootDirectory + "/environmentParameters/"
Write-Debug "Parameter Files Root Folder Path:'$parameterFilesRootPath'"

$parametersFilePath = $parameterFilesRootPath + $parameterFile
Write-Debug "Parameter File Complete Path:'$parametersFilePath'"
$parameters = (Get-Content -Path $parametersFilePath -Raw) | ConvertFrom-Json

$subscriptionId = $parameters.parameters.subscriptionId.value
$resourceGroupName = $parameters.parameters.resourceGroupName.value
$resourceGroupLocation = $parameters.parameters.resourceGroupLocation.value

# sign in
# Write-Host "Logging in...";
# Login-AzureRmAccount;

# Display target details
Write-Host "Selecting subscription: '$subscriptionId'"
Select-AzureRmSubscription -SubscriptionID $subscriptionId
Write-Host "Targeting resource group: '$resourceGroupName'"



if ($validate) {

}



if ($deploy) {
    $provisionListFilePath = "'$parentScriptRootDirectory'/inputFiles/'$provisionListFileName'"
    $provisionList = Get-Content -Path $provisionListFilePath | ConvertFrom-Csv
    $provisionList | ForEach-Object {
        $componentType = $_.ComponentType
        $provisionScript = "Provision-'$componentType'.ps1"
        if ($_.OverrideParameterFile) {
            $overrideEnvironmentParameterFile = $_.OverrideParameterFile
            Write-Output "Provisioning '$componentType' using override values from '$overrideEnvironmentParameterFile'"
            #***************************************
            #Override Parameter File Section HERE!!
            #***************************************
            $taskParameters = "override.parameterFile"
        }
        else {
            Write-Output "Provisioning '$componentType' without any override values"
            $taskParameters = $parameters
        }
        $deploymentStatus = & $provisionScript -parameterFile $taskParameters -subscriptionId $subscriptionId -rgLocation $resourceGroupLocation -rgName $resourceGroupName -componentType $componentType.ToLower()
        Write-Output "Deployment Status of '$componentType' is: '$deploymentStatus'"
    }
    
}
