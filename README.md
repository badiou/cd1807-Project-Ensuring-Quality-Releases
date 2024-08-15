# Azure DevOps Nanodegree Project
## _Udacity Nanodegree_

[![N|Solid](https://cldup.com/dTxpPi9lDf.thumb.png)](https://nodesource.com/products/nsolid)

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

This project is part of the Cloud DevOps Nanodegree using Azure offered by Udacity. The primary objective is to demonstrate the integration of various DevOps practices and tools learned throughout the course, with a focus on using:
A, Terraform, application monitoring, and automated testing.
![Capture d’écran 2024-08-15 à 19 49 36](https://github.com/user-attachments/assets/3d34eb25-6e8d-4456-a00c-5e86c815cc88)

- Azure DevOps
- Application monitoring
- Automated testing
## Prerequisites
Before you begin, ensure you have the following prerequisites:
- Azure Subscription: An active Azure account is required to create and manage resources.
- Azure DevOps Account: Access to Azure DevOps for setting up the CI/CD pipeline.
- Terraform Installed: Terraform should be installed locally if you plan to test infrastructure changes outside the pipeline. You can download it from Terraform's official website Terraform : https://www.terraform.io/downloads.html
- Node.js and npm Installed: Required for installing and running Newman for API testing. Install them from the official Node.js website https://nodejs.org/
- Postman Collection and Environment Files: Ensure you have the necessary Postman collections and environment files for API testing. These files should be stored in the automatedtesting/postman directory.
- JMeter Installed: Apache JMeter should be installed if you wish to run performance tests locally. It can be downloaded from JMeter's official website. https://jmeter.apache.org/download_jmeter.cgi
- Basic Knowledge of Azure and DevOps: Familiarity with Azure services, Terraform, CI/CD pipelines, and basic scripting is essential to understand and work with this project
- Selenium WebDriver Installed: If you intend to run Selenium tests locally, make sure Selenium WebDriver is installed, along with ChromeDriver for your local environment.
- Git Installed: You will need Git for version control and for cloning the repository. Download it from Git's official website. https://git-scm.com/downloads
Markdown is a lightweight markup language based on the formatting conventions
that people naturally use in email.

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

az ad sp create-for-rbac --role Contributor --scopes /subscriptions/<your_subscription_id> --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"
#az role assignment create --assignee 49ee535e-8d4c-46ca-8c9d-425e675d4719 --role Contributor --scope /subscriptions/<your_subscription_id>
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
Verifying the Created Azure Storage
After running the configure-tfstate-storage-account.sh script, you can verify that the Azure Storage resources have been created successfully by checking the Azure Portal

Open a terminal and change to the directory containing the configure-tfstate-storage-account.sh file. Use the following command to navigate to the appropriate directory:

- [AngularJS] - HTML enhanced for web apps!
- [Ace Editor] - awesome web-based text editor
- [markdown-it] - Markdown parser done right. Fast and easy to extend.
- [Twitter Bootstrap] - great UI boilerplate for modern web apps
- [node.js] - evented I/O for the backend
- [Express] - fast node.js network app framework [@tjholowaychuk]
- [Gulp] - the streaming build system
- [Breakdance](https://breakdance.github.io/breakdance/) - HTML
to Markdown converter
- [jQuery] - duh

And of course Dillinger itself is open source with a [public repository][dill]
 on GitHub.

## Installation

Dillinger requires [Node.js](https://nodejs.org/) v10+ to run.

Install the dependencies and devDependencies and start the server.

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
