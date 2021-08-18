#Script to manage all actions related to Virtual Machines
$action = Read-Host -Prompt "Enter action to be performed"


if ($action -eq "Create") {

    ##################################################################
    # 1. Create a new Virtual Machine
    ##################################################################
    #Fetch username and password and create credentials

    $vmPassword = ConvertTo-SecureString "adminadmin123!" -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential("adminuser", $vmPassword)

    $vmName = "WebServer03"
    $location = "centralindia"
    $image = "UbuntuLTS"
    $openPorts = 22
    $resourceGroup = "Mod-05-Azure-Powershell-RG"
    $vmSize = "Standard_B1ls"

    #Execute command to create a new VM based on above specs
    New-AzVm -Name $vmName -Location $location -Image $image -Credential $credential -OpenPorts $openPorts -ResourceGroupName $resourceGroup -Size $vmSize

}
elseif ($action -eq "Resize") {
    ##################################################################
    # 2. Resize an existing Virtual Machine 
    ##################################################################
}
elseif ($action -eq "Start") {
    ##################################################################
    # 3. Start an existing Virtual Machine 
    ##################################################################
}
elseif ($action -eq "Stop") {
    ##################################################################
    # 4. Stop an existing Virtual Machine 
    ##################################################################
}

$vm = Get-AzVM -ResourceGroupName $resourceGroup -VMName $vmName
$vm.HardwareProfile.VmSize = $vmSize
Update-AzVM -VM $vm -ResourceGroupName $resourceGroup