# Azure DevOps Nanodegree Project
## _Udacity Nanodegree Cloud DevOps with Microsoft Azure_

[![N|Solid](https://cldup.com/dTxpPi9lDf.thumb.png)](https://nodesource.com/products/nsolid)

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)
## Project Overview
The project involves creating, deploying, and testing infrastructure and applications on Azure using Terraform and Azure DevOps pipelines. Key tasks include:

- Infrastructure Management: Using Terraform to manage the Azure infrastructure.
- Continuous Integration/Continuous Deployment (CI/CD): Implementing a CI/CD pipeline to deploy the application to Azure.
- Automated Testing: Running performance tests with JMeter and UI tests with Selenium.
- Application Monitoring: Setting up monitoring and alerts to ensure the application is performing as expected.
![Capture d’écran 2024-08-15 à 19 49 36](https://github.com/user-attachments/assets/d9388e67-868c-4c63-a4d5-f480806e3279)

## Prerequisites

Before you begin, ensure you have the following installed and configured:

- **[Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)**: Command-line tool for managing Azure resources.
- **[Terraform](https://www.terraform.io/downloads)**: Infrastructure as code tool for provisioning and managing cloud resources.
- **[JMeter](https://jmeter.apache.org/download_jmeter.cgi)**: Tool for performance testing and load testing.
- **[Postman](https://www.postman.com/downloads/)**: API development and testing tool.
- **[Python](https://www.python.org/downloads/)**: Programming language used for scripting and automation tasks.
- **[Selenium](https://www.selenium.dev/downloads/)**: Tool for automating web browser interactions.

Ensure these tools are properly installed and configured before proceeding with the setup and execution of the pipeline.
## Create storage
Running the Azure Configuration Script
To set up your Azure environment, follow the steps below to execute the configure-tfstate-storage-account.sh script:
```sh
ourobadiou@MacBook-Air-de-Badiou test % chmod +x configure-tfstate-storage-account.sh
./configure-tfstate-storage-account.sh
```
The configure-tfstate-storage-account.sh script is used to configure the Azure environment for storing Terraform state files
```sh
#!/bin/bash
RESOURCE_GROUP_NAME="Azuredevops"
STORAGE_ACCOUNT_NAME="tfstate$RANDOM$RANDOM"
CONTAINER_NAME="tfstate"
# This command is not needed in the Udacity provided Azure account. 
# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location eastus
az ad sp create-for-rbac --role Contributor --scopes /subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2 --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"
#az role assignment create --assignee 49ee535e-8d4c-46ca-8c9d-425e675d4719 --role Contributor --scope /subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2
# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob
# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
export ARM_ACCESS_KEY=$ACCOUNT_KEY
# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY
echo "RESOURCE_GROUP_NAME=$RESOURCE_GROUP_NAME"
echo "STORAGE_ACCOUNT_NAME=$STORAGE_ACCOUNT_NAME"
echo "CONTAINER_NAME=$CONTAINER_NAME"
echo "ACCOUNT_KEY=$ACCOUNT_KEY"
```

# Script Output
The script will produce the following output, which you will use to configure Terraform:
RESOURCE_GROUP_NAME: The name of the Azure resource group created.
STORAGE_ACCOUNT_NAME: The name of the Azure storage account created.
CONTAINER_NAME: The name of the blob container created within the storage account.
ACCOUNT_KEY: The access key for the storage account.
These parameters will be used to configure the Terraform backend for state management, ensuring that your Terraform configurations use the correct Azure storage account (main.tf file) for storing the state file 
```sh
terraform {
  backend "azurerm" {
    storage_account_name = "tfstate224873291"
    container_name       = "tfstate"
    key                  = "test.terraform.tfstate"
    access_key           = "4YtNNk70105FbwJhCRUsm+AKbPDdvoROQ/eRpBI4qt4DPudMiiiiwmVVBgAyL4Us54ljevoWDee1+ASt2YzCRw=="
  }
}
```

## Terraform configuration
For managing sensitive Terraform variables, we use `terraform.tfvars`, which contains crucial configuration details for our Terraform setup. To ensure that these variables are handled securely, we have added `terraform.tfvars` as a secure file in Azure Pipelines.
![Capture d’écran 2024-08-15 à 20 34 11](https://github.com/user-attachments/assets/59e4d6e4-5918-4689-b290-4d1b3491daa9)
### Manual Terraform Commands: Create ressources
Before using the Azure Pipeline, manually initialize and apply Terraform configurations as follows:
```sh
terraform init
terraform plan
terraform apply
```
![2-terraform apply (Create all resources)](https://github.com/user-attachments/assets/f2c16806-285d-425f-ae0c-7518c6d0a3d2)

### Destroy Resources: To clean up resources, use:
```sh
terraform destroy
```
![4-terraform destroy resource confirmation](https://github.com/user-attachments/assets/fc850bb2-71f8-4683-812d-559e1026e868)

## Azure pipeline
The Azure Pipeline automates the deployment and testing process. Here is an overview of the pipeline stages:

- Build Stage
- Terraform Initialization: Installs Terraform, initializes it, and configures the backend.
<img width="1427" alt="6-Terraform install in pipeline" src="https://github.com/user-attachments/assets/29f23229-bd15-4b60-8a2a-b6222f331b0d">
<img width="1427" alt="9-terraform apply" src="https://github.com/user-attachments/assets/ea0d1ebd-6e62-4a3e-9a40-7fb44ace9c96">
- Executes Newman tests for data validation and regression, archives test results, and publishes artifacts.
<img width="1427" alt="10-Install newman" src="https://github.com/user-attachments/assets/7184be9a-d46f-4bac-8da0-39251a2b6fd7">
<img width="1427" alt="11-Run Data validation Test suite" src="https://github.com/user-attachments/assets/7a0631a8-32ec-4ba4-8b6b-f63c2b5ba37f">
<img width="1427" alt="12-Run Regression Test suite" src="https://github.com/user-attachments/assets/01d5095c-b2fd-4019-a3a1-c54fa2e8540f">
- Deploys the application to Azure Web App.
<img width="1427" alt="13- Deploy Azure Web app" src="https://github.com/user-attachments/assets/ccffc875-321f-40e4-8b2e-964a59be244c">

- Run JMeter Performance Tests: Executes performance and stress tests using JMeter, and publishes the results.

<img width="1427" alt="15-Jmeter Installation" src="https://github.com/user-attachments/assets/3f43054d-c48f-478e-9aa9-e553b791118f">
<img width="1427" alt="16- Jmeter StressTest" src="https://github.com/user-attachments/assets/a41a0354-d017-44c9-9e56-f04f406153a4">
<img width="1427" alt="17- Jmeter EnduranceTest" src="https://github.com/user-attachments/assets/ed3e329d-6954-4493-a8b5-1d52f83e3b5f">
- Runs UI tests using Selenium, and publishes the test results.
<img width="1427" alt="20- Run selenium test" src="https://github.com/user-attachments/assets/11dd0e32-cf35-457b-ab67-7f92144740ac">
## Fakerestapi
![14- Run myapplication-ourobadiou-appservice app on browser](https://github.com/user-attachments/assets/72299763-a8c7-485d-a5e8-24abffe3a90f)


## Azure artifact: Viewing Pipeline Logs

After executing your pipeline, you can view the logs generated during the pipeline run directly in Azure DevOps. This helps in diagnosing issues and reviewing the details of each step in your pipeline.
You can view JMeter and Selenium logs in Azure DevOps under the pipeline run details, with JMeter logs showing performance test results and Selenium logs displaying UI test outcomes, both accessible through the pipeline artifacts.
<img width="1435" alt="21-Azure pipeline artifacts" src="https://github.com/user-attachments/assets/51c9f329-f506-46f9-9d84-d86cb68daa19">


**Free Software, Hell Yeah!**

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [dill]: <https://github.com/joemccann/dillinger>
   [git-repo-url]: <https://github.com/joemccann/dillinger.git>
   [john gruber]: <http://daringfireball.net>
   [df1]: <http://daringfireball.net/projects/markdown/>
   [markdown-it]: <https://github.com/markdown-it/markdown-it>
   [Ace Editor]: <http://ace.ajax.org>
   [node.js]: <http://nodejs.org>
   [Twitter Bootstrap]: <http://twitter.github.com/bootstrap/>
   [jQuery]: <http://jquery.com>
   [@tjholowaychuk]: <http://twitter.com/tjholowaychuk>
   [express]: <http://expressjs.com>
   [AngularJS]: <http://angularjs.org>
   [Gulp]: <http://gulpjs.com>

   [PlDb]: <https://github.com/joemccann/dillinger/tree/master/plugins/dropbox/README.md>
   [PlGh]: <https://github.com/joemccann/dillinger/tree/master/plugins/github/README.md>
   [PlGd]: <https://github.com/joemccann/dillinger/tree/master/plugins/googledrive/README.md>
   [PlOd]: <https://github.com/joemccann/dillinger/tree/master/plugins/onedrive/README.md>
   [PlMe]: <https://github.com/joemccann/dillinger/tree/master/plugins/medium/README.md>
   [PlGa]: <https://github.com/RahulHP/dillinger/blob/master/plugins/googleanalytics/README.md>
