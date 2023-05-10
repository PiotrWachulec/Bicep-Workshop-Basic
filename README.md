# Bicep - From zero to Hero!

Here are the materials for the basic workshops about Bicep. You will learn how to:

- write basic and more complex Bicep templates,
- do the deployment from Powershell,
- configure and run Powershell scripts from VS Code,
- configure basic deployment pipelines using GitHub Actions.

## Requirements

To install:

- Visual Studio Code
- Powershell Core 7+
- Azure Powershell
- git

Additionally:

- GitHub account
- access to the resource group on Azure with created and configured SPN with assigned Contributor role on the resource group level.

# Prerequisite concepts and additional materials

## The `.git/info/exclude` file

The `.git/info/exclude` file is a Git configuration file that allows you to specify files and directories that Git should ignore when tracking changes to a project. It is similar to the `.gitignore` file, but it applies only to the local repository, rather than being committed and shared with other contributors.

The `exclude` file is useful when you want to exclude certain files or directories from being tracked by Git but don't want to add them to the `.gitignore` file because they are specific to your local environment or workflow. For example, you might use this file to exclude temporary files, log files, or build artifacts that are generated during the development process.

The syntax of the exclude file is the same as that of the `.gitignore` file. You can use wildcards and patterns to specify files or directories to exclude. Each pattern should be listed on a separate line.

Here's an example of a `.git/info/exclude` file that excludes all files with the extension `.log` and the build directory:

```bash
# exclude log files
*.log

# exclude build directory
build/
```

Note that any files or directories specified in the exclude file will still be present in your local repository, but they will be ignored by Git and will not be included in any commits or pushes to remote repositories.

## The `.local` folder

The `.local` folder is a concept where you have a dedicated folder for everything which you want to have in the project folder, but you don't want to commit to the repository. You can create a folder called `.local` and add it to the `.git/info/exclude`. Then you will be sure that everything which will land in this folder will not be committed to the repository. 

## Abbreviation examples for Azure resources

The naming convention for resources is always the subject of heated debate. In this document you have examples of abbreviations for Azure resources: [Abbreviation examples for Azure resources](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations).

## More complex templates designs

After this workshop, you should be able to write basic and later more complex Bicep templates. Then it is good to have the better overview on how they can be designed. In the [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/) you can find the document called: [Enterprise infrastructure as code using Bicep and Azure Container Registry](https://learn.microsoft.com/en-us/azure/architecture/guide/azure-resource-manager/advanced-templates/enterprise-infrastructure-bicep-container-registry) which describes the way of building reusable assets of templates.

## Splatting

In PowerShell, splatting is a technique that allows you to pass a collection of key-value pairs to a command or function as individual parameters. Instead of passing each parameter one by one, you can define a hashtable that contains the parameter names as keys and their corresponding values as values. This hashtable is then passed to the command or function using the @ symbol followed by the name of the hashtable.

Example:
```ps
$params = @{
  ComputerName = 'Server01'
  Credential = (Get-Credential)
  Path = 'C:\Temp\File.txt'
}

Get-Content @params
```

Splatting can be especially useful when you have a large number of parameters to pass to a command or function, or when you're building up a set of parameters dynamically. It can make your code easier to read and maintain, since you can see all the parameters in one place rather than scattered throughout your code.

# Workshop

## Step 1 - Basic Bicep template

Defining resources is super easy in Bicep:

```
resource <symbolic-name> <type@api-version> (existing) = {
  name: name
  location: location
}
```

As you can see above you have to use `resource` keyword.

Optionally, you can add `existing` keyword if you are referring to the existing resource.

Later between the `{}` you have to fulfill required properties.

Example:

```
resource myResource 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'myStorageAccount'
  location: 'eastus'
}
```

## Step 2 - Basic Powershell deployment

> The detailed instruction can be found in the documentation [Deploy resources with Bicep and Azure PowerShell](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-powershell)

> Before running the deployment make sure that you logged into the Azure from Powershell (`Connect-AzAccount`) and set proper context (`Set-AzContext -SubscriptionId <SubscriptionID>`).

For running basic deployment you need to run the `New-AzResourceGroupDeployment` cmdlet.

```ps
$rgName = "bicep-workshop-test"
New-AzResourceGroupDeployment -Name "MyDeployment" -ResourceGroupName $rgName -Template './templates/template.bicep'
```
## Step 3 - Deployments in Azure Portal

When you are reviewing the resource group, you can find the 'Deployment' pane. It shows the deployment history, so you can check the detailed errors and so on. Due to this, it is important to make deployment names unique. More information you can find in the [documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-history?tabs=azure-portal).

## Step 4 - Preparing PS script for the deployment

As we mentioned above, it would be good if the deployment names will be unique. Let's prepare a script for running the deployments of the resources:

```ps
param(
    [string]$ResourceGroupName
)

# Generate a timestamp to use in the deployment name
$timestamp = Get-Date -Format 'yyyyMMddHHmmss'

# Construct the deployment name using the prefix and timestamp
$deploymentName = "MyDeploment-$timestamp"

# Deploy the template using the Azure PowerShell module
New-AzResourceGroupDeployment -Name $deploymentName -ResourceGroupName $rgName -TemplateFile './templates/template.bicep'
```

And later, the script can be called in that way:

```ps
$rgName = "bicep-workshop-test"
./scripts/Deploy-Resources.ps1 -ResourceGroupName $rgName
```

For now, it looks like overengineering, but it can be helpful later.