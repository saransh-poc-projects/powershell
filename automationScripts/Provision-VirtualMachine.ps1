param(
    [Parameter(Mandatory = $true)][string]$parameterFile,
    [Parameter(Mandatory = $true)][string]$rgName,
    [Parameter(Mandatory = $true)][string]$rgLocation
)

#Fetch username and password and create credentials
try {
    $username = Read-Host -Prompt "Enter the username for this VM"
    $pass = Read-Host -Prompt "Enter the password for this VM"
    $vmPassword = ConvertTo-SecureString $pass -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($username, $vmPassword)

    $vmName = "WebServer03"
    $image = "UbuntuLTS"
    $openPorts = 22
    $vmSize = "Standard_B1ls"

    #Execute command to create a new VM based on above specs
    New-AzVm -Name $vmName -Location $rgLocation -Image $image -Credential $credential -OpenPorts $openPorts -ResourceGroupName $rgName -Size $vmSize

}
catch {

}

return "Succeeded"