param(
    [string]$ResourceGroupName
)

# Generate a timestamp to use in the deployment name
$timestamp = Get-Date -Format 'yyyyMMddHHmmss'

# Construct the deployment name using the prefix and timestamp
$deploymentName = "MyDeploment-$timestamp"

# Deploy the template using the Azure PowerShell module
New-AzResourceGroupDeployment -Name $deploymentName -ResourceGroupName $ResourceGroupName -TemplateFile './templates/template.bicep'