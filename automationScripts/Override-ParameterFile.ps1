param(
    [Parameter(Mandatory)]$mainParameterFile,
    [Parameter(Mandatory)]$overrideParameterFile,
    [Parameter(Mandatory)]$environment = 'dev',
    [Parameter(Mandatory)]$component = 'storageaccount'
)

#******************************************************************************
# Script body
# Execution begins here
#******************************************************************************
$ErrorActionPreference = "Stop"
$parentScriptDirectory = Get-Location
Install-Module -Name JoinModule
#Install-Script -Name Join

Function RemoveProperty {
    param (
        # A PSCustomObject
        [Parameter( Mandatory, ValueFromPipeline )] $Object,
        # A list of property names to remove
        [Parameter( Mandatory )] [string[]]$PropList,
        # recurse?
        [Parameter()] [Switch]$Recurse
    )
    # Write-Host $Object  -ForegroundColor Cyan
    foreach ( $Prop in $PropList ) {
        $Object.PSObject.Properties.Remove($prop)
    }
    # Write-Host $Object  -ForegroundColor Green
    if ( $Recurse.IsPresent ) {
        foreach ($ObjValue in $Object.PSObject.Properties.Value) {
            # Write-Host $ObjValue  -ForegroundColor Yellow
            if ( $ObjValue.GetType().Name -eq 'PSCustomObject' ) {
                $ObjValue | RemoveProperty -PropList $PropList -Recurse
            }
        }
    }
    return $object
}

#RemoveProperty -Object $mainParametersPSObject -PropList $overrideParameterArray -Recurse

#Assign file paths to variables
$parentScriptRootDirectory = Split-Path -Path $parentScriptDirectory -Parent
Write-Debug "Script Root Folder Path:'$parentScriptRootDirectory'"

$parameterFilesRootPath = $parentScriptRootDirectory + "/environmentParameters"
Write-Debug "Parameter Files Root Folder Path:'$parameterFilesRootPath'"
$overrideFile = "$parameterFilesRootPath/override.$environment.$component.json"
Write-Output "Successful script execution will generate $overrideFile"

$mainParametersPath = "../environmentParameters/$mainParameterFile"
$overrideParametersFilePath = "../environmentParameters/$overrideParameterFile"

# Begin reading parameters
$mainParametersPSObject = Get-Content -Path $mainParametersPath | ConvertFrom-Json
$overrideParametersPSObject = Get-Content -Path $overrideParametersFilePath | ConvertFrom-Json

foreach ($overrideMemberObjects in $overrideParametersPSObject.PSObject.Members | Where-Object membertype -like 'noteproperty') {
    
    if ($overrideMemberObjects.name -eq 'parameters') {
        $parameters = $overrideMemberObjects.Value
    }
    #parameters.dev.main.json
}
Write-Debug "\nParameter object picked up: $parameters"

#Adding override parameter names to array
[System.Collections.ArrayList] $overrideParameterArray = @()
foreach ($p in $parameters.PSObject.Members) {
    if ($p.MemberType -eq 'NoteProperty') {
        $overrideParameterArray.Add($p.Name)
    }    
}
Write-Debug "\nParameters being overriden: $overrideParameterArray"


#Remove parameters to be override in oringinal file
$mainShortPSObject = RemoveProperty -Object $mainParametersPSObject -PropList $overrideParameterArray -Recurse
if ($mainShortPSObject) {
    Write-Debug "New override object:$mainShortPSObject"
}
else {
    Write-Output "Main short parameter PSObject not created.Check Remove Property function output"
}

#Merge both json files to create the override parameter file
$overridePSObject = Join-Object -Left $mainParametersPSObject -Right $overrideParametersPSObject -JoinType Full
if ($overridePSObject) {
    $overridePSObject | ConvertTo-Json | Out-File $overrideFile
    $overridePSObject
}
else {
    Write-Output "Final override array not created. Check execution from line 86." 
}
    
# }
# Catch {

#     Write-Output "Try block failed. Check RemoveProperty Function or the final object array"
 
# }
#$out = Get-Content | 
