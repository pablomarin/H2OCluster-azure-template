<#
SYNOPSYS
    
    DeployAzureRmH2oCluster.ps1 (Test version V1.0.1)

    This script creates an H2O cluster on an Azure Resource Group.
    The parameters passed to the deployment are:

    - Storage Account Type. DS-series VMs must be deployed in Premium_LRS in order to have an SSD OS disk.
      Available types are:
        - Standard_LRS
        - Premium_LRS

    - Virtual Machine Size. Available sizes are:
        - Standard_DS1_v2
        - Standard_DS2_v2
        - Standard_DS3_v2
        - Standard_DS4_v2
        - Standard_DS5_v2
        - Standard_DS11_v2
        - Standard_DS12_v2
        - Standard_DS13_v2
        - Standard_DS14_v2

    - Scale Number: The number of h2o nodes to provision in the cluster

    - Administrator username

    - Administrator password

    To run this script, download the file azuredeploy.json from the url
    https://github.com/pablomarin/H2OCluster-azure-template/blob/master/azuredeploy.json
#>

##########################
# json template location #
##########################
$h2oClusterPath = ""

##########################
#    Script Variables    #
##########################
$resourceGroupName = ""

##########################
#   Template Parameters  #
#     Change at will     #
##########################
$parameters = @{
    "storageAccountType" = "Premium_LRS"
    "vmSize"             = "Standard_DS2_v2"
    "adminUserName"      = "h2oadmin"
    "adminPassword"      = "********"
    "scaleNumber"        = 3
}

##########################
#     Begin of Script    #
##########################
Write-Host -ForegroundColor Yellow "H2O Azure Cluster Provisioning Script`r`n`r`n"

# Login to Azure
Login-AzureRmAccount

# Get template location
$fileExists = Test-Path -Path $h2oClusterPath
while (!$fileExists)
{
    Write-Host -ForegroundColor Green "Type the json template location on this computer:"
    $h2oClusterPath = Read-Host ""
    $fileExists = Test-Path $h2oClusterPath

    if ($fileExists)
    {
        Write-Host -ForegroundColor Green "File location verified. Continuing...`r`n"
    }
    else
    {
        Write-Host -ForegroundColor Red "File Not Found. Check the Make sure the file exists in the path specified or try a different one.`r`n"
    }
}

#Get resource group name
if ([string]::IsNullOrEmpty($resourceGroupName))
{
    Write-Host -ForegroundColor Green "Enter the Resource Group Name:"
    $resourceGroupName = Read-Host ""
    $resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
    if ($resourceGroup -eq $null)
    {
        Write-Host -ForegroundColor Green "Resource Group does not exist. Creating...`r`n"

        # Get location
        $locationSet = $false
        do
        {
            $locations = (Get-AzureRmLocation -WarningAction SilentlyContinue).Location
            Write-Host -ForegroundColor Green "`r`nChoose one of the locations listed below:"
            for ($i = 0; $i -lt $locations.Count; $i++)
            {
                Write-Host -ForegroundColor Green "  [$($i + 1)] - $($locations[$i])"
            }
        
            $locationIndex = Read-Host ""
            try
            {
                $location = $locations[$i - 1]
                Write-Host -ForegroundColor Green "You selected '$location'. Press [c] to change or Enter to continue:"
                $change = Read-Host ""

                if ([string]::IsNullOrEmpty($change))
                {
                    $locationSet = $true
                }
            }
            catch
            {
                Write-Host -ForegroundColor Red "The option you selected is not valid. Try again.`r`n"
            }
        }
        while (!$locationSet)

        Write-Host -ForegroundColor Green "Creating Resource Group $resourceGroupName in $location..."
        New-AzureRmResourceGroup -Name $resourceGroupName -Location $location -Verbose -Force -ErrorAction Stop
    }
}
else
{
    Write-Host -ForegroundColor Green "Getting resource group '$resourceGroupName'..."
    $resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -Verbose -ErrorAction Stop
}

Test-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -Mode Incremental -TemplateParameterObject $parameters -TemplateFile $h2oClusterPath -Verbose -ErrorAction Stop

$deploymentName = "H2OCluster-$((Get-Date).Ticks)"
New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroupName -Mode Incremental -TemplateParameterObject $parameters -TemplateFile $h2oClusterPath -Force -Verbose -ErrorAction Stop
