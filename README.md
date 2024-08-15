# Azure DevOps Nanodegree Project
## _The Last Markdown Editor, Ever_

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

### Destroy Resources: To clean up resources, use:
```sh
terraform destroy
```

```sh
cd dillinger
npm i
node app
```

For production environments...

```sh
npm install --production
NODE_ENV=production node app
```

## Plugins

Dillinger is currently extended with the following plugins.
Instructions on how to use them in your own application are linked below.

| Plugin | README |
| ------ | ------ |
| Dropbox | [plugins/dropbox/README.md][PlDb] |
| GitHub | [plugins/github/README.md][PlGh] |
| Google Drive | [plugins/googledrive/README.md][PlGd] |
| OneDrive | [plugins/onedrive/README.md][PlOd] |
| Medium | [plugins/medium/README.md][PlMe] |
| Google Analytics | [plugins/googleanalytics/README.md][PlGa] |

## Development

Want to contribute? Great!

Dillinger uses Gulp + Webpack for fast developing.
Make a change in your file and instantaneously see your updates!

Open your favorite Terminal and run these commands.

First Tab:

```sh
node app
```

Second Tab:

```sh
gulp watch
```

(optional) Third:

```sh
karma test
```

#### Building for source

For production release:

```sh
gulp build --prod
```

Generating pre-built zip archives for distribution:

```sh
gulp build dist --prod
```

## Docker

Dillinger is very easy to install and deploy in a Docker container.

By default, the Docker will expose port 8080, so change this within the
Dockerfile if necessary. When ready, simply use the Dockerfile to
build the image.

```sh
cd dillinger
docker build -t <youruser>/dillinger:${package.json.version} .
```

This will create the dillinger image and pull in the necessary dependencies.
Be sure to swap out `${package.json.version}` with the actual
version of Dillinger.

Once done, run the Docker image and map the port to whatever you wish on
your host. In this example, we simply map port 8000 of the host to
port 8080 of the Docker (or whatever port was exposed in the Dockerfile):

```sh
docker run -d -p 8000:8080 --restart=always --cap-add=SYS_ADMIN --name=dillinger <youruser>/dillinger:${package.json.version}
```

> Note: `--capt-add=SYS-ADMIN` is required for PDF rendering.

Verify the deployment by navigating to your server address in
your preferred browser.

```sh
127.0.0.1:8000
```

## License

MIT

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
