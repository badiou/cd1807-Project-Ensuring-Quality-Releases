# Azure DevOps Nanodegree Project
## _Udacity Nanodegree Cloud DevOps with Microsoft Azure_
[![Build Status](https://dev.azure.com/obbadiou/cd1807-Project-Ensuring-Quality-Releases/_apis/build/status%2Fbadiou.cd1807-Project-Ensuring-Quality-Releases?branchName=main)](https://dev.azure.com/obbadiou/cd1807-Project-Ensuring-Quality-Releases/_build/latest?definitionId=61&branchName=main)

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

- Fakerestapi 
<img width="1427" alt="20- Fakerestapi" src="https://github.com/user-attachments/assets/72299763-a8c7-485d-a5e8-24abffe3a90f">

- All resource created on azure
<img width="1427" alt="20- Fakerestapi" src="https://github.com/user-attachments/assets/b344b79a-0f7f-4381-a1ae-93fc05fd0f36">

## Azure artifact: Viewing Pipeline Logs

After executing your pipeline, you can view the logs generated during the pipeline run directly in Azure DevOps. This helps in diagnosing issues and reviewing the details of each step in your pipeline.
You can view JMeter and Selenium logs in Azure DevOps under the pipeline run details, with JMeter logs showing performance test results and Selenium logs displaying UI test outcomes, both accessible through the pipeline artifacts.
<img width="1435" alt="21-Azure pipeline artifacts" src="https://github.com/user-attachments/assets/51c9f329-f506-46f9-9d84-d86cb68daa19">

### Jmeter Logs: Endurance Test log Donwloaded from azure artifact
```bash
2024-08-15 13:07:39,456 INFO o.a.j.u.JMeterUtils: Setting Locale to en_EN
2024-08-15 13:07:39,491 INFO o.a.j.JMeter: Loading user properties from: /home/vsts/work/1/drop-perftests/apache-jmeter-5.6.2/bin/user.properties
2024-08-15 13:07:39,491 INFO o.a.j.JMeter: Loading system properties from: /home/vsts/work/1/drop-perftests/apache-jmeter-5.6.2/bin/system.properties
2024-08-15 13:07:39,492 INFO o.a.j.JMeter: Setting JMeter property: exampleCSV=/home/vsts/work/1/drop-perftests/exempleCsv.csv
2024-08-15 13:07:39,492 INFO o.a.j.JMeter: Setting JMeter property: resultsCSV=/home/vsts/work/1/drop-perftests/results.csv
2024-08-15 13:07:39,499 INFO o.a.j.JMeter: Copyright (c) 1998-2023 The Apache Software Foundation
2024-08-15 13:07:39,499 INFO o.a.j.JMeter: Version 5.6.2
2024-08-15 13:07:39,499 INFO o.a.j.JMeter: java.version=11.0.24
2024-08-15 13:07:39,499 INFO o.a.j.JMeter: java.vm.name=OpenJDK 64-Bit Server VM
2024-08-15 13:07:39,499 INFO o.a.j.JMeter: os.name=Linux
2024-08-15 13:07:39,499 INFO o.a.j.JMeter: os.arch=amd64
2024-08-15 13:07:39,499 INFO o.a.j.JMeter: os.version=5.15.0-1070-azure
2024-08-15 13:07:39,499 INFO o.a.j.JMeter: file.encoding=UTF-8
2024-08-15 13:07:39,499 INFO o.a.j.JMeter: java.awt.headless=true
2024-08-15 13:07:39,499 INFO o.a.j.JMeter: Max memory     =1073741824
2024-08-15 13:07:39,500 INFO o.a.j.JMeter: Available Processors =2
2024-08-15 13:07:39,509 INFO o.a.j.JMeter: Default Locale=English (EN)
2024-08-15 13:07:39,510 INFO o.a.j.JMeter: JMeter  Locale=English (EN)
2024-08-15 13:07:39,510 INFO o.a.j.JMeter: JMeterHome=/home/vsts/work/1/drop-perftests/apache-jmeter-5.6.2
2024-08-15 13:07:39,510 INFO o.a.j.JMeter: user.dir  =/home/vsts/work/1/drop-perftests
2024-08-15 13:07:39,510 INFO o.a.j.JMeter: PWD       =/home/vsts/work/1/drop-perftests
2024-08-15 13:07:39,510 INFO o.a.j.JMeter: IP: 10.1.10.2 Name: fv-az235-35 FullName: fv-az235-35.r13szwr3ayke3hep4zdq0gwbvc.fx.internal.cloudapp.net
2024-08-15 13:07:39,527 INFO o.a.j.JMeter: Setting property 'jmeter.reportgenerator.outputdir' to:'/home/vsts/work/1/drop-perftests/log/jmeter/EnduranceTestReport'
2024-08-15 13:07:39,529 INFO o.a.j.s.FileServer: Default base='/home/vsts/work/1/drop-perftests'
2024-08-15 13:07:39,531 INFO o.a.j.s.FileServer: Set new base='/home/vsts/work/1/drop-perftests'
2024-08-15 13:07:39,780 INFO o.a.j.s.SaveService: Testplan (JMX) version: 2.2. Testlog (JTL) version: 2.2
2024-08-15 13:07:39,808 INFO o.a.j.s.SaveService: Using SaveService properties version 5.0
2024-08-15 13:07:39,811 INFO o.a.j.s.SaveService: Using SaveService properties file encoding UTF-8
2024-08-15 13:07:39,815 INFO o.a.j.s.SaveService: Loading file: /home/vsts/work/1/drop-perftests/EnduranceTest.jmx
2024-08-15 13:07:39,885 INFO o.a.j.p.h.s.HTTPSamplerBase: Parser for text/html is org.apache.jmeter.protocol.http.parser.LagartoBasedHtmlParser
2024-08-15 13:07:39,885 INFO o.a.j.p.h.s.HTTPSamplerBase: Parser for application/xhtml+xml is org.apache.jmeter.protocol.http.parser.LagartoBasedHtmlParser
2024-08-15 13:07:39,886 INFO o.a.j.p.h.s.HTTPSamplerBase: Parser for application/xml is org.apache.jmeter.protocol.http.parser.LagartoBasedHtmlParser
2024-08-15 13:07:39,886 INFO o.a.j.p.h.s.HTTPSamplerBase: Parser for text/xml is org.apache.jmeter.protocol.http.parser.LagartoBasedHtmlParser
2024-08-15 13:07:39,886 INFO o.a.j.p.h.s.HTTPSamplerBase: Parser for text/vnd.wap.wml is org.apache.jmeter.protocol.http.parser.RegexpHTMLParser
2024-08-15 13:07:39,886 INFO o.a.j.p.h.s.HTTPSamplerBase: Parser for text/css is org.apache.jmeter.protocol.http.parser.CssParser
2024-08-15 13:07:39,936 INFO o.a.j.JMeter: Creating summariser <summary>
2024-08-15 13:07:39,941 INFO o.a.j.r.d.ReportGenerator: ReportGenerator will use for Parsing the separator: ','
2024-08-15 13:07:39,941 INFO o.a.j.r.d.ReportGenerator: Will generate report at end of test from  results file: /home/vsts/work/1/drop-perftests/log/jmeter/results_EnduranceTest.csv
2024-08-15 13:07:39,941 INFO o.a.j.r.d.ReportGenerator: Reading report generator properties from: /home/vsts/work/1/drop-perftests/apache-jmeter-5.6.2/bin/reportgenerator.properties
2024-08-15 13:07:39,942 INFO o.a.j.r.d.ReportGenerator: Merging with JMeter properties
2024-08-15 13:07:39,946 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.temp_dir' not found, using default value 'temp' instead.
2024-08-15 13:07:39,950 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.apdex_per_transaction' not found, using default value 'null' instead.
2024-08-15 13:07:39,950 INFO o.a.j.r.c.ReportGeneratorConfiguration: apdex_per_transaction is empty, not APDEX per transaction customization
2024-08-15 13:07:39,950 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.sample_filter' not found, using default value 'null' instead.
2024-08-15 13:07:39,950 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.report_title' not found, using default value 'null' instead.
2024-08-15 13:07:39,950 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.start_date' not found, using default value 'null' instead.
2024-08-15 13:07:39,950 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.end_date' not found, using default value 'null' instead.
2024-08-15 13:07:39,951 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.date_format' not found, using default value 'null' instead.
2024-08-15 13:07:39,951 INFO o.a.j.r.c.ReportGeneratorConfiguration: Will use date range start date: null, end date: null
2024-08-15 13:07:39,955 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.graph.totalTPS.exclude_controllers' not found, using default value 'false' instead.
2024-08-15 13:07:39,955 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.graph.activeThreadsOverTime.exclude_controllers' not found, using default value 'false' instead.
2024-08-15 13:07:39,956 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.graph.timeVsThreads.exclude_controllers' not found, using default value 'false' instead.
2024-08-15 13:07:39,956 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.graph.responseTimeDistribution.exclude_controllers' not found, using default value 'false' instead.
2024-08-15 13:07:39,956 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.graph.transactionsPerSecond.exclude_controllers' not found, using default value 'false' instead.
2024-08-15 13:07:39,957 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.graph.responseTimePercentiles.exclude_controllers' not found, using default value 'false' instead.
2024-08-15 13:07:39,957 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.graph.responseTimePercentilesOverTime.exclude_controllers' not found, using default value 'false' instead.
2024-08-15 13:07:39,957 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.graph.responseTimesOverTime.exclude_controllers' not found, using default value 'false' instead.
2024-08-15 13:07:39,957 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.graph.connectTimeOverTime.exclude_controllers' not found, using default value 'false' instead.
2024-08-15 13:07:39,957 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.graph.latenciesOverTime.exclude_controllers' not found, using default value 'false' instead.
2024-08-15 13:07:39,959 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.exporter.json.filters_only_sample_series' not found, using default value 'true' instead.
2024-08-15 13:07:39,959 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.exporter.json.series_filter' not found, using default value '' instead.
2024-08-15 13:07:39,959 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.exporter.json.show_controllers_only' not found, using default value 'false' instead.
2024-08-15 13:07:39,959 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.exporter.html.filters_only_sample_series' not found, using default value 'true' instead.
2024-08-15 13:07:39,960 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.exporter.html.series_filter' not found, using default value '' instead.
2024-08-15 13:07:39,960 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.exporter.html.show_controllers_only' not found, using default value 'false' instead.
2024-08-15 13:07:39,980 INFO o.a.j.e.StandardJMeterEngine: Running the test!
2024-08-15 13:07:39,982 INFO o.a.j.s.SampleEvent: List of sample_variables: []
2024-08-15 13:07:39,982 INFO o.a.j.s.SampleEvent: List of sample_variables: []
2024-08-15 13:07:39,998 INFO o.a.j.e.u.CompoundVariable: Note: Function class names must contain the string: '.functions.'
2024-08-15 13:07:39,998 INFO o.a.j.e.u.CompoundVariable: Note: Function class names must not contain the string: '.gui.'
2024-08-15 13:07:40,301 INFO o.a.j.JMeter: Running test (1723727260301)
2024-08-15 13:07:40,360 INFO o.a.j.e.StandardJMeterEngine: Starting ThreadGroup: 1 : Starter
2024-08-15 13:07:40,360 INFO o.a.j.e.StandardJMeterEngine: Starting 10 threads for group Starter.
2024-08-15 13:07:40,361 INFO o.a.j.e.StandardJMeterEngine: Thread will continue on error
2024-08-15 13:07:40,361 INFO o.a.j.t.ThreadGroup: Starting thread group... number=1 threads=10 ramp-up=1 delayedStart=false
2024-08-15 13:07:40,386 INFO o.a.j.t.ThreadGroup: Started thread group number 1
2024-08-15 13:07:40,386 INFO o.a.j.e.StandardJMeterEngine: All thread groups have been started
2024-08-15 13:07:40,456 INFO o.a.j.t.JMeterThread: Thread started: Starter 1-1
2024-08-15 13:07:40,458 INFO o.a.j.s.FileServer: Stored: exempleCsv.csv
2024-08-15 13:07:40,491 INFO o.a.j.p.h.s.HTTPHCAbstractImpl: Local host = fv-az235-35
2024-08-15 13:07:40,497 INFO o.a.j.p.h.s.HTTPHC4Impl: HTTP request retry count = 0
2024-08-15 13:07:40,498 INFO o.a.j.s.SampleResult: Note: Sample TimeStamps are START times
2024-08-15 13:07:40,499 INFO o.a.j.s.SampleResult: sampleresult.default.encoding is set to UTF-8
2024-08-15 13:07:40,499 INFO o.a.j.s.SampleResult: sampleresult.useNanoTime=true
2024-08-15 13:07:40,499 INFO o.a.j.s.SampleResult: sampleresult.nanoThreadSleep=5000
2024-08-15 13:07:40,549 INFO o.a.j.t.JMeterThread: Thread started: Starter 1-2
2024-08-15 13:07:40,587 INFO o.a.j.p.h.s.h.LazyLayeredConnectionSocketFactory: Setting up HTTPS TrustAll Socket Factory
2024-08-15 13:07:40,593 INFO o.a.j.u.JsseSSLManager: Using default SSL protocol: TLS
2024-08-15 13:07:40,593 INFO o.a.j.u.JsseSSLManager: SSL session context: per-thread
2024-08-15 13:07:40,661 INFO o.a.j.t.JMeterThread: Thread started: Starter 1-3
2024-08-15 13:07:40,729 INFO o.a.j.u.SSLManager: JmeterKeyStore Location:  type JKS
2024-08-15 13:07:40,733 INFO o.a.j.u.SSLManager: KeyStore created OK
2024-08-15 13:07:40,733 WARN o.a.j.u.SSLManager: Keystore file not found, loading empty keystore
2024-08-15 13:07:40,741 INFO o.a.j.t.JMeterThread: Thread started: Starter 1-4
2024-08-15 13:07:40,844 INFO o.a.j.t.JMeterThread: Thread started: Starter 1-5
2024-08-15 13:07:40,942 INFO o.a.j.t.JMeterThread: Thread started: Starter 1-6
2024-08-15 13:07:41,036 INFO o.a.j.t.JMeterThread: Thread started: Starter 1-7
2024-08-15 13:07:41,140 INFO o.a.j.t.JMeterThread: Thread started: Starter 1-8
2024-08-15 13:07:41,239 INFO o.a.j.t.JMeterThread: Thread started: Starter 1-9
2024-08-15 13:07:41,337 INFO o.a.j.t.JMeterThread: Thread started: Starter 1-10
2024-08-15 13:07:41,483 INFO o.a.j.t.JMeterThread: Thread is done: Starter 1-5
2024-08-15 13:07:41,483 INFO o.a.j.t.JMeterThread: Thread finished: Starter 1-5
2024-08-15 13:07:41,485 INFO o.a.j.t.JMeterThread: Thread is done: Starter 1-2
2024-08-15 13:07:41,485 INFO o.a.j.t.JMeterThread: Thread finished: Starter 1-2
2024-08-15 13:07:41,485 INFO o.a.j.t.JMeterThread: Thread is done: Starter 1-3
2024-08-15 13:07:41,486 INFO o.a.j.t.JMeterThread: Thread finished: Starter 1-3
2024-08-15 13:07:41,489 INFO o.a.j.t.JMeterThread: Thread is done: Starter 1-4
2024-08-15 13:07:41,489 INFO o.a.j.t.JMeterThread: Thread finished: Starter 1-4
2024-08-15 13:07:41,491 INFO o.a.j.t.JMeterThread: Thread is done: Starter 1-1
2024-08-15 13:07:41,491 INFO o.a.j.t.JMeterThread: Thread finished: Starter 1-1
2024-08-15 13:07:41,509 INFO o.a.j.t.JMeterThread: Thread is done: Starter 1-6
2024-08-15 13:07:41,509 INFO o.a.j.t.JMeterThread: Thread finished: Starter 1-6
2024-08-15 13:07:41,569 INFO o.a.j.t.JMeterThread: Thread is done: Starter 1-7
2024-08-15 13:07:41,569 INFO o.a.j.t.JMeterThread: Thread finished: Starter 1-7
2024-08-15 13:07:41,659 INFO o.a.j.t.JMeterThread: Thread is done: Starter 1-8
2024-08-15 13:07:41,659 INFO o.a.j.t.JMeterThread: Thread finished: Starter 1-8
2024-08-15 13:07:41,743 INFO o.a.j.t.JMeterThread: Thread is done: Starter 1-9
2024-08-15 13:07:41,744 INFO o.a.j.t.JMeterThread: Thread finished: Starter 1-9
2024-08-15 13:07:41,842 INFO o.a.j.t.JMeterThread: Thread is done: Starter 1-10
2024-08-15 13:07:41,842 INFO o.a.j.t.JMeterThread: Thread finished: Starter 1-10
2024-08-15 13:07:41,843 INFO o.a.j.e.StandardJMeterEngine: Notifying test listeners of end of test
2024-08-15 13:07:41,843 INFO o.a.j.s.FileServer: Close: exempleCsv.csv
2024-08-15 13:07:41,846 INFO o.a.j.r.Summariser: summary =     30 in 00:00:02 =   19.4/s Avg:   219 Min:    69 Max:   707 Err:     0 (0.00%)
2024-08-15 13:07:41,846 INFO o.a.j.JMeter: Generating Dashboard
2024-08-15 13:07:41,846 INFO o.a.j.r.d.ReportGenerator: Flushing result collector before report Generation
2024-08-15 13:07:41,856 INFO o.a.j.r.p.NormalizerSampleConsumer: Using format, 'ms', to parse timeStamp field
2024-08-15 13:07:41,938 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.AggregateConsumer#stopProducing(): beginDate produced 0 samples
2024-08-15 13:07:41,938 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.AggregateConsumer#stopProducing(): endDate produced 0 samples
2024-08-15 13:07:41,940 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.ApdexSummaryConsumer#stopProducing(): apdexSummary produced 0 samples
2024-08-15 13:07:41,940 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.RequestsSummaryConsumer#stopProducing(): requestsSummary produced 0 samples
2024-08-15 13:07:41,945 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.StatisticsSummaryConsumer#stopProducing(): statisticsSummary produced 0 samples
2024-08-15 13:07:41,947 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.Top5ErrorsBySamplerConsumer#stopProducing(): top5ErrorsBySampler produced 0 samples
2024-08-15 13:07:41,947 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.ErrorsSummaryConsumer#stopProducing(): errorsSummary produced 0 samples
2024-08-15 13:07:41,947 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.HitsPerSecondGraphConsumer#stopProducing(): hitsPerSecond produced 0 samples
2024-08-15 13:07:41,961 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.LatencyVSRequestGraphConsumer#stopProducing(): latencyVsRequest produced 0 samples
2024-08-15 13:07:41,961 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.SyntheticResponseTimeDistributionGraphConsumer#stopProducing(): syntheticResponseTimeDistribution produced 0 samples
2024-08-15 13:07:41,962 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.BytesThroughputGraphConsumer#stopProducing(): bytesThroughputOverTime produced 0 samples
2024-08-15 13:07:41,962 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.CodesPerSecondGraphConsumer#stopProducing(): codesPerSecond produced 0 samples
2024-08-15 13:07:41,965 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.ResponseTimeVSRequestGraphConsumer#stopProducing(): responseTimeVsRequest produced 0 samples
2024-08-15 13:07:41,965 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.FilterConsumer#stopProducing(): startIntervalControlerFilter produced 210 samples
2024-08-15 13:07:41,965 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.TotalTPSGraphConsumer#stopProducing(): totalTPS produced 0 samples
2024-08-15 13:07:41,965 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.ActiveThreadsGraphConsumer#stopProducing(): activeThreadsOverTime produced 0 samples
2024-08-15 13:07:41,965 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.TimeVSThreadGraphConsumer#stopProducing(): timeVsThreads produced 0 samples
2024-08-15 13:07:41,966 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.ResponseTimeDistributionGraphConsumer#stopProducing(): responseTimeDistribution produced 0 samples
2024-08-15 13:07:41,966 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.TransactionsPerSecondGraphConsumer#stopProducing(): transactionsPerSecond produced 0 samples
2024-08-15 13:07:41,966 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.ResponseTimePercentilesGraphConsumer#stopProducing(): responseTimePercentiles produced 0 samples
2024-08-15 13:07:41,968 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.ResponseTimePercentilesOverTimeGraphConsumer#stopProducing(): responseTimePercentilesOverTime produced 0 samples
2024-08-15 13:07:41,968 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.ResponseTimeOverTimeGraphConsumer#stopProducing(): responseTimesOverTime produced 0 samples
2024-08-15 13:07:41,968 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.ConnectTimeOverTimeGraphConsumer#stopProducing(): connectTimeOverTime produced 0 samples
2024-08-15 13:07:41,968 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.LatencyOverTimeGraphConsumer#stopProducing(): latenciesOverTime produced 0 samples
2024-08-15 13:07:41,968 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.FilterConsumer#stopProducing(): nameFilter produced 450 samples
2024-08-15 13:07:41,968 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.FilterConsumer#stopProducing(): dateRangeFilter produced 90 samples
2024-08-15 13:07:41,968 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.NormalizerSampleConsumer#stopProducing(): normalizer produced 30 samples
2024-08-15 13:07:41,969 INFO o.a.j.r.p.CsvFileSampleSource: produce(): 30 samples produced in 91ms on channel 0
2024-08-15 13:07:41,969 INFO o.a.j.r.d.ReportGenerator: Exporting data using exporter:'json' of className:'org.apache.jmeter.report.dashboard.JsonExporter'
2024-08-15 13:07:42,120 INFO o.a.j.r.d.JsonExporter: Found data for consumer statisticsSummary in context
2024-08-15 13:07:42,121 INFO o.a.j.r.d.JsonExporter: Creating statistics for overall
2024-08-15 13:07:42,121 INFO o.a.j.r.d.JsonExporter: Creating statistics for other transactions
2024-08-15 13:07:42,122 INFO o.a.j.r.d.JsonExporter: Checking output folder
2024-08-15 13:07:42,122 INFO o.a.j.r.d.JsonExporter: Writing statistics JSON to /home/vsts/work/1/drop-perftests/log/jmeter/EnduranceTestReport/statistics.json
2024-08-15 13:07:42,166 INFO o.a.j.r.d.ReportGenerator: Exporting data using exporter:'html' of className:'org.apache.jmeter.report.dashboard.HtmlTemplateExporter'
2024-08-15 13:07:42,168 INFO o.a.j.r.d.HtmlTemplateExporter: Will generate dashboard in folder: /home/vsts/work/1/drop-perftests/log/jmeter/EnduranceTestReport
2024-08-15 13:07:42,297 INFO o.a.j.r.d.HtmlTemplateExporter: Report will be generated in: /home/vsts/work/1/drop-perftests/log/jmeter/EnduranceTestReport, creating folder structure
2024-08-15 13:07:42,299 INFO o.a.j.r.d.TemplateVisitor: Copying folder from '/home/vsts/work/1/drop-perftests/apache-jmeter-5.6.2/bin/report-template' to '/home/vsts/work/1/drop-perftests/log/jmeter/EnduranceTestReport', got message: /home/vsts/work/1/drop-perftests/log/jmeter/EnduranceTestReport, found non empty folder with following content [/home/vsts/work/1/drop-perftests/log/jmeter/EnduranceTestReport/statistics.json], will be ignored
2024-08-15 13:07:42,484 INFO o.a.j.JMeter: Dashboard generated

```
### Jmeter Logs: Stress Test log Donwloaded from azure artifact
```bash
2024-08-15 13:07:28,794 INFO o.a.j.u.JMeterUtils: Setting Locale to en_EN
2024-08-15 13:07:28,862 INFO o.a.j.JMeter: Loading user properties from: /home/vsts/work/1/drop-perftests/apache-jmeter-5.6.2/bin/user.properties
2024-08-15 13:07:28,863 INFO o.a.j.JMeter: Loading system properties from: /home/vsts/work/1/drop-perftests/apache-jmeter-5.6.2/bin/system.properties
2024-08-15 13:07:28,863 INFO o.a.j.JMeter: Setting JMeter property: exampleCSV=/home/vsts/work/1/drop-perftests/exempleCsv.csv
2024-08-15 13:07:28,863 INFO o.a.j.JMeter: Setting JMeter property: resultsCSV=/home/vsts/work/1/drop-perftests/results.csv
2024-08-15 13:07:28,871 INFO o.a.j.JMeter: Copyright (c) 1998-2023 The Apache Software Foundation
2024-08-15 13:07:28,871 INFO o.a.j.JMeter: Version 5.6.2
2024-08-15 13:07:28,871 INFO o.a.j.JMeter: java.version=11.0.24
2024-08-15 13:07:28,871 INFO o.a.j.JMeter: java.vm.name=OpenJDK 64-Bit Server VM
2024-08-15 13:07:28,872 INFO o.a.j.JMeter: os.name=Linux
2024-08-15 13:07:28,872 INFO o.a.j.JMeter: os.arch=amd64
2024-08-15 13:07:28,872 INFO o.a.j.JMeter: os.version=5.15.0-1070-azure
2024-08-15 13:07:28,872 INFO o.a.j.JMeter: file.encoding=UTF-8
2024-08-15 13:07:28,872 INFO o.a.j.JMeter: java.awt.headless=true
2024-08-15 13:07:28,872 INFO o.a.j.JMeter: Max memory     =1073741824
2024-08-15 13:07:28,872 INFO o.a.j.JMeter: Available Processors =2
2024-08-15 13:07:28,894 INFO o.a.j.JMeter: Default Locale=English (EN)
2024-08-15 13:07:28,895 INFO o.a.j.JMeter: JMeter  Locale=English (EN)
2024-08-15 13:07:28,895 INFO o.a.j.JMeter: JMeterHome=/home/vsts/work/1/drop-perftests/apache-jmeter-5.6.2
2024-08-15 13:07:28,895 INFO o.a.j.JMeter: user.dir  =/home/vsts/work/1/drop-perftests
2024-08-15 13:07:28,895 INFO o.a.j.JMeter: PWD       =/home/vsts/work/1/drop-perftests
2024-08-15 13:07:28,896 INFO o.a.j.JMeter: IP: 10.1.10.2 Name: fv-az235-35 FullName: fv-az235-35.r13szwr3ayke3hep4zdq0gwbvc.fx.internal.cloudapp.net
2024-08-15 13:07:28,908 INFO o.a.j.JMeter: Setting property 'jmeter.reportgenerator.outputdir' to:'/home/vsts/work/1/drop-perftests/log/jmeter/StressTestReport'
2024-08-15 13:07:28,910 INFO o.a.j.s.FileServer: Default base='/home/vsts/work/1/drop-perftests'
2024-08-15 13:07:28,912 INFO o.a.j.s.FileServer: Set new base='/home/vsts/work/1/drop-perftests'
2024-08-15 13:07:29,268 INFO o.a.j.s.SaveService: Testplan (JMX) version: 2.2. Testlog (JTL) version: 2.2
2024-08-15 13:07:29,305 INFO o.a.j.s.SaveService: Using SaveService properties version 5.0
2024-08-15 13:07:29,308 INFO o.a.j.s.SaveService: Using SaveService properties file encoding UTF-8
2024-08-15 13:07:29,311 INFO o.a.j.s.SaveService: Loading file: /home/vsts/work/1/drop-perftests/StressTest.jmx
2024-08-15 13:07:29,372 INFO o.a.j.p.h.s.HTTPSamplerBase: Parser for text/html is org.apache.jmeter.protocol.http.parser.LagartoBasedHtmlParser
2024-08-15 13:07:29,372 INFO o.a.j.p.h.s.HTTPSamplerBase: Parser for application/xhtml+xml is org.apache.jmeter.protocol.http.parser.LagartoBasedHtmlParser
2024-08-15 13:07:29,372 INFO o.a.j.p.h.s.HTTPSamplerBase: Parser for application/xml is org.apache.jmeter.protocol.http.parser.LagartoBasedHtmlParser
2024-08-15 13:07:29,372 INFO o.a.j.p.h.s.HTTPSamplerBase: Parser for text/xml is org.apache.jmeter.protocol.http.parser.LagartoBasedHtmlParser
2024-08-15 13:07:29,372 INFO o.a.j.p.h.s.HTTPSamplerBase: Parser for text/vnd.wap.wml is org.apache.jmeter.protocol.http.parser.RegexpHTMLParser
2024-08-15 13:07:29,372 INFO o.a.j.p.h.s.HTTPSamplerBase: Parser for text/css is org.apache.jmeter.protocol.http.parser.CssParser
2024-08-15 13:07:29,427 INFO o.a.j.JMeter: Creating summariser <summary>
2024-08-15 13:07:29,431 INFO o.a.j.r.d.ReportGenerator: ReportGenerator will use for Parsing the separator: ','
2024-08-15 13:07:29,432 INFO o.a.j.r.d.ReportGenerator: Will generate report at end of test from  results file: /home/vsts/work/1/drop-perftests/log/jmeter/results_StressTest.csv
2024-08-15 13:07:29,432 INFO o.a.j.r.d.ReportGenerator: Reading report generator properties from: /home/vsts/work/1/drop-perftests/apache-jmeter-5.6.2/bin/reportgenerator.properties
2024-08-15 13:07:29,432 INFO o.a.j.r.d.ReportGenerator: Merging with JMeter properties
2024-08-15 13:07:29,436 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.temp_dir' not found, using default value 'temp' instead.
2024-08-15 13:07:29,442 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.apdex_per_transaction' not found, using default value 'null' instead.
2024-08-15 13:07:29,442 INFO o.a.j.r.c.ReportGeneratorConfiguration: apdex_per_transaction is empty, not APDEX per transaction customization
2024-08-15 13:07:29,442 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.sample_filter' not found, using default value 'null' instead.
2024-08-15 13:07:29,443 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.report_title' not found, using default value 'null' instead.
2024-08-15 13:07:29,443 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.start_date' not found, using default value 'null' instead.
2024-08-15 13:07:29,443 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.end_date' not found, using default value 'null' instead.
2024-08-15 13:07:29,443 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.date_format' not found, using default value 'null' instead.
2024-08-15 13:07:29,444 INFO o.a.j.r.c.ReportGeneratorConfiguration: Will use date range start date: null, end date: null
2024-08-15 13:07:29,448 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.graph.totalTPS.exclude_controllers' not found, using default value 'false' instead.
2024-08-15 13:07:29,448 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.graph.activeThreadsOverTime.exclude_controllers' not found, using default value 'false' instead.
2024-08-15 13:07:29,449 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.graph.timeVsThreads.exclude_controllers' not found, using default value 'false' instead.
2024-08-15 13:07:29,449 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.graph.responseTimeDistribution.exclude_controllers' not found, using default value 'false' instead.
2024-08-15 13:07:29,449 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.graph.transactionsPerSecond.exclude_controllers' not found, using default value 'false' instead.
2024-08-15 13:07:29,449 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.graph.responseTimePercentiles.exclude_controllers' not found, using default value 'false' instead.
2024-08-15 13:07:29,450 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.graph.responseTimePercentilesOverTime.exclude_controllers' not found, using default value 'false' instead.
2024-08-15 13:07:29,450 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.graph.responseTimesOverTime.exclude_controllers' not found, using default value 'false' instead.
2024-08-15 13:07:29,450 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.graph.connectTimeOverTime.exclude_controllers' not found, using default value 'false' instead.
2024-08-15 13:07:29,450 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.graph.latenciesOverTime.exclude_controllers' not found, using default value 'false' instead.
2024-08-15 13:07:29,452 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.exporter.json.filters_only_sample_series' not found, using default value 'true' instead.
2024-08-15 13:07:29,452 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.exporter.json.series_filter' not found, using default value '' instead.
2024-08-15 13:07:29,452 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.exporter.json.show_controllers_only' not found, using default value 'false' instead.
2024-08-15 13:07:29,452 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.exporter.html.filters_only_sample_series' not found, using default value 'true' instead.
2024-08-15 13:07:29,453 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.exporter.html.series_filter' not found, using default value '' instead.
2024-08-15 13:07:29,453 INFO o.a.j.r.c.ReportGeneratorConfiguration: Property 'jmeter.reportgenerator.exporter.html.show_controllers_only' not found, using default value 'false' instead.
2024-08-15 13:07:29,478 INFO o.a.j.e.StandardJMeterEngine: Running the test!
2024-08-15 13:07:29,482 INFO o.a.j.s.SampleEvent: List of sample_variables: []
2024-08-15 13:07:29,482 INFO o.a.j.s.SampleEvent: List of sample_variables: []
2024-08-15 13:07:29,496 INFO o.a.j.e.u.CompoundVariable: Note: Function class names must contain the string: '.functions.'
2024-08-15 13:07:29,496 INFO o.a.j.e.u.CompoundVariable: Note: Function class names must not contain the string: '.gui.'
2024-08-15 13:07:30,274 WARN o.a.j.r.ResultCollector: Error creating directories for /Users/ourobadiou/Desktop/cd1807-Project-Ensuring-Quality-Releases/automatedtesting/jmeter
2024-08-15 13:07:30,275 INFO o.a.j.JMeter: Running test (1723727250275)
2024-08-15 13:07:30,311 INFO o.a.j.e.StandardJMeterEngine: Starting ThreadGroup: 1 : Starter
2024-08-15 13:07:30,311 INFO o.a.j.e.StandardJMeterEngine: Starting 10 threads for group Starter.
2024-08-15 13:07:30,311 INFO o.a.j.e.StandardJMeterEngine: Thread will continue on error
2024-08-15 13:07:30,311 INFO o.a.j.t.ThreadGroup: Starting thread group... number=1 threads=10 ramp-up=1 delayedStart=false
2024-08-15 13:07:30,342 INFO o.a.j.t.ThreadGroup: Started thread group number 1
2024-08-15 13:07:30,342 INFO o.a.j.e.StandardJMeterEngine: All thread groups have been started
2024-08-15 13:07:30,486 INFO o.a.j.t.JMeterThread: Thread started: Starter 1-1
2024-08-15 13:07:30,488 INFO o.a.j.s.FileServer: Stored: exempleCsv.csv
2024-08-15 13:07:30,519 INFO o.a.j.p.h.s.HTTPHCAbstractImpl: Local host = fv-az235-35
2024-08-15 13:07:30,525 INFO o.a.j.p.h.s.HTTPHC4Impl: HTTP request retry count = 0
2024-08-15 13:07:30,527 INFO o.a.j.s.SampleResult: Note: Sample TimeStamps are START times
2024-08-15 13:07:30,527 INFO o.a.j.s.SampleResult: sampleresult.default.encoding is set to UTF-8
2024-08-15 13:07:30,527 INFO o.a.j.s.SampleResult: sampleresult.useNanoTime=true
2024-08-15 13:07:30,527 INFO o.a.j.s.SampleResult: sampleresult.nanoThreadSleep=5000
2024-08-15 13:07:30,581 INFO o.a.j.t.JMeterThread: Thread started: Starter 1-2
2024-08-15 13:07:30,645 INFO o.a.j.p.h.s.h.LazyLayeredConnectionSocketFactory: Setting up HTTPS TrustAll Socket Factory
2024-08-15 13:07:30,652 INFO o.a.j.u.JsseSSLManager: Using default SSL protocol: TLS
2024-08-15 13:07:30,652 INFO o.a.j.u.JsseSSLManager: SSL session context: per-thread
2024-08-15 13:07:30,679 INFO o.a.j.t.JMeterThread: Thread started: Starter 1-3
2024-08-15 13:07:30,780 INFO o.a.j.t.JMeterThread: Thread started: Starter 1-4
2024-08-15 13:07:30,799 INFO o.a.j.u.SSLManager: JmeterKeyStore Location:  type JKS
2024-08-15 13:07:30,803 INFO o.a.j.u.SSLManager: KeyStore created OK
2024-08-15 13:07:30,803 WARN o.a.j.u.SSLManager: Keystore file not found, loading empty keystore
2024-08-15 13:07:30,874 INFO o.a.j.t.JMeterThread: Thread started: Starter 1-5
2024-08-15 13:07:30,968 INFO o.a.j.t.JMeterThread: Thread started: Starter 1-6
2024-08-15 13:07:31,071 INFO o.a.j.t.JMeterThread: Thread started: Starter 1-7
2024-08-15 13:07:31,165 INFO o.a.j.t.JMeterThread: Thread started: Starter 1-8
2024-08-15 13:07:31,268 INFO o.a.j.t.JMeterThread: Thread started: Starter 1-9
2024-08-15 13:07:31,365 INFO o.a.j.t.JMeterThread: Thread started: Starter 1-10
2024-08-15 13:07:35,533 INFO o.a.j.r.Summariser: summary +      1 in 00:00:05 =    0.2/s Avg:  4453 Min:  4453 Max:  4453 Err:     0 (0.00%) Active: 10 Started: 10 Finished: 0
2024-08-15 13:07:35,819 INFO o.a.j.t.JMeterThread: Thread is done: Starter 1-10
2024-08-15 13:07:35,819 INFO o.a.j.t.JMeterThread: Thread is done: Starter 1-2
2024-08-15 13:07:35,821 INFO o.a.j.t.JMeterThread: Thread is done: Starter 1-3
2024-08-15 13:07:35,821 INFO o.a.j.t.JMeterThread: Thread finished: Starter 1-3
2024-08-15 13:07:35,821 INFO o.a.j.t.JMeterThread: Thread finished: Starter 1-10
2024-08-15 13:07:35,821 INFO o.a.j.t.JMeterThread: Thread is done: Starter 1-5
2024-08-15 13:07:35,821 INFO o.a.j.t.JMeterThread: Thread finished: Starter 1-5
2024-08-15 13:07:35,820 INFO o.a.j.t.JMeterThread: Thread is done: Starter 1-7
2024-08-15 13:07:35,821 INFO o.a.j.t.JMeterThread: Thread finished: Starter 1-7
2024-08-15 13:07:35,822 INFO o.a.j.t.JMeterThread: Thread is done: Starter 1-1
2024-08-15 13:07:35,822 INFO o.a.j.t.JMeterThread: Thread finished: Starter 1-1
2024-08-15 13:07:35,820 INFO o.a.j.t.JMeterThread: Thread is done: Starter 1-6
2024-08-15 13:07:35,823 INFO o.a.j.t.JMeterThread: Thread finished: Starter 1-6
2024-08-15 13:07:35,820 INFO o.a.j.t.JMeterThread: Thread is done: Starter 1-4
2024-08-15 13:07:35,825 INFO o.a.j.t.JMeterThread: Thread finished: Starter 1-2
2024-08-15 13:07:35,824 INFO o.a.j.t.JMeterThread: Thread is done: Starter 1-9
2024-08-15 13:07:35,826 INFO o.a.j.t.JMeterThread: Thread finished: Starter 1-4
2024-08-15 13:07:35,826 INFO o.a.j.t.JMeterThread: Thread finished: Starter 1-9
2024-08-15 13:07:35,827 INFO o.a.j.t.JMeterThread: Thread is done: Starter 1-8
2024-08-15 13:07:35,827 INFO o.a.j.t.JMeterThread: Thread finished: Starter 1-8
2024-08-15 13:07:35,827 INFO o.a.j.e.StandardJMeterEngine: Notifying test listeners of end of test
2024-08-15 13:07:35,827 INFO o.a.j.s.FileServer: Close: exempleCsv.csv
2024-08-15 13:07:35,830 INFO o.a.j.r.Summariser: summary +     29 in 00:00:00 =   96.3/s Avg:  1526 Min:   132 Max:  4917 Err:     0 (0.00%) Active: 0 Started: 10 Finished: 10
2024-08-15 13:07:35,830 INFO o.a.j.r.Summariser: summary =     30 in 00:00:06 =    5.4/s Avg:  1623 Min:   132 Max:  4917 Err:     0 (0.00%)
2024-08-15 13:07:35,830 INFO o.a.j.JMeter: Generating Dashboard
2024-08-15 13:07:35,831 INFO o.a.j.r.d.ReportGenerator: Flushing result collector before report Generation
2024-08-15 13:07:35,840 INFO o.a.j.r.p.NormalizerSampleConsumer: Using format, 'ms', to parse timeStamp field
2024-08-15 13:07:35,898 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.AggregateConsumer#stopProducing(): beginDate produced 0 samples
2024-08-15 13:07:35,898 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.AggregateConsumer#stopProducing(): endDate produced 0 samples
2024-08-15 13:07:35,900 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.ApdexSummaryConsumer#stopProducing(): apdexSummary produced 0 samples
2024-08-15 13:07:35,900 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.RequestsSummaryConsumer#stopProducing(): requestsSummary produced 0 samples
2024-08-15 13:07:35,904 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.StatisticsSummaryConsumer#stopProducing(): statisticsSummary produced 0 samples
2024-08-15 13:07:35,905 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.Top5ErrorsBySamplerConsumer#stopProducing(): top5ErrorsBySampler produced 0 samples
2024-08-15 13:07:35,905 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.ErrorsSummaryConsumer#stopProducing(): errorsSummary produced 0 samples
2024-08-15 13:07:35,905 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.HitsPerSecondGraphConsumer#stopProducing(): hitsPerSecond produced 0 samples
2024-08-15 13:07:35,916 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.LatencyVSRequestGraphConsumer#stopProducing(): latencyVsRequest produced 0 samples
2024-08-15 13:07:35,917 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.SyntheticResponseTimeDistributionGraphConsumer#stopProducing(): syntheticResponseTimeDistribution produced 0 samples
2024-08-15 13:07:35,917 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.BytesThroughputGraphConsumer#stopProducing(): bytesThroughputOverTime produced 0 samples
2024-08-15 13:07:35,917 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.CodesPerSecondGraphConsumer#stopProducing(): codesPerSecond produced 0 samples
2024-08-15 13:07:35,920 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.ResponseTimeVSRequestGraphConsumer#stopProducing(): responseTimeVsRequest produced 0 samples
2024-08-15 13:07:35,921 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.FilterConsumer#stopProducing(): startIntervalControlerFilter produced 210 samples
2024-08-15 13:07:35,921 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.TotalTPSGraphConsumer#stopProducing(): totalTPS produced 0 samples
2024-08-15 13:07:35,921 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.ActiveThreadsGraphConsumer#stopProducing(): activeThreadsOverTime produced 0 samples
2024-08-15 13:07:35,921 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.TimeVSThreadGraphConsumer#stopProducing(): timeVsThreads produced 0 samples
2024-08-15 13:07:35,921 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.ResponseTimeDistributionGraphConsumer#stopProducing(): responseTimeDistribution produced 0 samples
2024-08-15 13:07:35,921 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.TransactionsPerSecondGraphConsumer#stopProducing(): transactionsPerSecond produced 0 samples
2024-08-15 13:07:35,921 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.ResponseTimePercentilesGraphConsumer#stopProducing(): responseTimePercentiles produced 0 samples
2024-08-15 13:07:35,922 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.ResponseTimePercentilesOverTimeGraphConsumer#stopProducing(): responseTimePercentilesOverTime produced 0 samples
2024-08-15 13:07:35,923 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.ResponseTimeOverTimeGraphConsumer#stopProducing(): responseTimesOverTime produced 0 samples
2024-08-15 13:07:35,923 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.ConnectTimeOverTimeGraphConsumer#stopProducing(): connectTimeOverTime produced 0 samples
2024-08-15 13:07:35,923 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.graph.impl.LatencyOverTimeGraphConsumer#stopProducing(): latenciesOverTime produced 0 samples
2024-08-15 13:07:35,923 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.FilterConsumer#stopProducing(): nameFilter produced 450 samples
2024-08-15 13:07:35,923 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.FilterConsumer#stopProducing(): dateRangeFilter produced 90 samples
2024-08-15 13:07:35,923 INFO o.a.j.r.p.AbstractSampleConsumer: class org.apache.jmeter.report.processor.NormalizerSampleConsumer#stopProducing(): normalizer produced 30 samples
2024-08-15 13:07:35,923 INFO o.a.j.r.p.CsvFileSampleSource: produce(): 30 samples produced in 60ms on channel 0
2024-08-15 13:07:35,924 INFO o.a.j.r.d.ReportGenerator: Exporting data using exporter:'json' of className:'org.apache.jmeter.report.dashboard.JsonExporter'
2024-08-15 13:07:36,070 INFO o.a.j.r.d.JsonExporter: Found data for consumer statisticsSummary in context
2024-08-15 13:07:36,070 INFO o.a.j.r.d.JsonExporter: Creating statistics for overall
2024-08-15 13:07:36,071 INFO o.a.j.r.d.JsonExporter: Creating statistics for other transactions
2024-08-15 13:07:36,071 INFO o.a.j.r.d.JsonExporter: Checking output folder
2024-08-15 13:07:36,071 INFO o.a.j.r.d.JsonExporter: Writing statistics JSON to /home/vsts/work/1/drop-perftests/log/jmeter/StressTestReport/statistics.json
2024-08-15 13:07:36,116 INFO o.a.j.r.d.ReportGenerator: Exporting data using exporter:'html' of className:'org.apache.jmeter.report.dashboard.HtmlTemplateExporter'
2024-08-15 13:07:36,119 INFO o.a.j.r.d.HtmlTemplateExporter: Will generate dashboard in folder: /home/vsts/work/1/drop-perftests/log/jmeter/StressTestReport
2024-08-15 13:07:36,251 INFO o.a.j.r.d.HtmlTemplateExporter: Report will be generated in: /home/vsts/work/1/drop-perftests/log/jmeter/StressTestReport, creating folder structure
2024-08-15 13:07:36,255 INFO o.a.j.r.d.TemplateVisitor: Copying folder from '/home/vsts/work/1/drop-perftests/apache-jmeter-5.6.2/bin/report-template' to '/home/vsts/work/1/drop-perftests/log/jmeter/StressTestReport', got message: /home/vsts/work/1/drop-perftests/log/jmeter/StressTestReport, found non empty folder with following content [/home/vsts/work/1/drop-perftests/log/jmeter/StressTestReport/statistics.json], will be ignored
2024-08-15 13:07:36,482 INFO o.a.j.JMeter: Dashboard generated

```
### Selenium Logs: StressTest Donwloaded from azure artifact
```bash
2024-08-15 16:45:28,141 - INFO - Starting the browser...
2024-08-15 16:45:29,821 - INFO - Number of products found: 6
2024-08-15 16:45:29,847 - INFO - Sauce Labs Backpack
carry.allTheThings() with the sleek, streamlined Sly Pack that melds uncompromising style with unequaled laptop and tablet protection.
$29.99
Add to cart
2024-08-15 16:45:29,866 - INFO - Sauce Labs Bike Light
A red light isn't the desired state in testing but it sure helps when riding your bike at night. Water-resistant with 3 lighting modes, 1 AAA battery included.
$9.99
Add to cart
2024-08-15 16:45:29,885 - INFO - Sauce Labs Bolt T-Shirt
Get your testing superhero on with the Sauce Labs bolt T-shirt. From American Apparel, 100% ringspun combed cotton, heather gray with red bolt.
$15.99
Add to cart
2024-08-15 16:45:29,906 - INFO - Sauce Labs Fleece Jacket
It's not every day that you come across a midweight quarter-zip fleece jacket capable of handling everything from a relaxing day outdoors to a busy day at the office.
$49.99
Add to cart
2024-08-15 16:45:29,924 - INFO - Sauce Labs Onesie
Rib snap infant onesie for the junior automation engineer in development. Reinforced 3-snap bottom closure, two-needle hemmed sleeved and bottom won't unravel.
$7.99
Add to cart
2024-08-15 16:45:29,943 - INFO - Test.allTheThings() T-Shirt (Red)
This classic Sauce Labs t-shirt is perfect to wear when cozying up to your keyboard to automate a few tests. Super-soft and comfy ringspun combed cotton.
$15.99
Add to cart
2024-08-15 16:45:29,969 - INFO - Number of 'Add to cart' buttons found: 6
2024-08-15 16:45:29,984 - INFO - Button found with text: Add to cart
2024-08-15 16:45:30,018 - INFO - Click on the button with class Add cart successful
2024-08-15 16:45:30,030 - INFO - The button has transformed into Remove
2024-08-15 16:45:30,047 - INFO - Button found with text: Add to cart
2024-08-15 16:45:30,081 - INFO - Click on the button with class Add cart successful
2024-08-15 16:45:30,090 - INFO - The button has transformed into Remove
2024-08-15 16:45:30,105 - INFO - Button found with text: Add to cart
2024-08-15 16:45:30,139 - INFO - Click on the button with class Add cart successful
2024-08-15 16:45:30,149 - INFO - The button has transformed into Remove
2024-08-15 16:45:30,164 - INFO - Button found with text: Add to cart
2024-08-15 16:45:30,195 - INFO - Click on the button with class Add cart successful
2024-08-15 16:45:30,203 - INFO - The button has transformed into Remove
2024-08-15 16:45:30,224 - INFO - Button found with text: Add to cart
2024-08-15 16:45:30,255 - INFO - Click on the button with class Add cart successful
2024-08-15 16:45:30,262 - INFO - The button has transformed into Remove
2024-08-15 16:45:30,276 - INFO - Button found with text: Add to cart
2024-08-15 16:45:30,305 - INFO - Click on the button with class Add cart successful
2024-08-15 16:45:30,312 - INFO - The button has transformed into Remove
Starting the browser...
Number of products found: 6
Sauce Labs Backpack
carry.allTheThings() with the sleek, streamlined Sly Pack that melds uncompromising style with unequaled laptop and tablet protection.
$29.99
Add to cart
Sauce Labs Bike Light
A red light isn't the desired state in testing but it sure helps when riding your bike at night. Water-resistant with 3 lighting modes, 1 AAA battery included.
$9.99
Add to cart
Sauce Labs Bolt T-Shirt
Get your testing superhero on with the Sauce Labs bolt T-shirt. From American Apparel, 100% ringspun combed cotton, heather gray with red bolt.
$15.99
Add to cart
Sauce Labs Fleece Jacket
It's not every day that you come across a midweight quarter-zip fleece jacket capable of handling everything from a relaxing day outdoors to a busy day at the office.
$49.99
Add to cart
Sauce Labs Onesie
Rib snap infant onesie for the junior automation engineer in development. Reinforced 3-snap bottom closure, two-needle hemmed sleeved and bottom won't unravel.
$7.99
Add to cart
Test.allTheThings() T-Shirt (Red)
This classic Sauce Labs t-shirt is perfect to wear when cozying up to your keyboard to automate a few tests. Super-soft and comfy ringspun combed cotton.
$15.99
Add to cart
Number of 'Add to cart' buttons found: 6
Button found with text: Add to cart
Click on the button with class Add cart successful
The button has transformed into Remove
Button found with text: Add to cart
Click on the button with class Add cart successful
The button has transformed into Remove
Button found with text: Add to cart
Click on the button with class Add cart successful
The button has transformed into Remove
Button found with text: Add to cart
Click on the button with class Add cart successful
The button has transformed into Remove
Button found with text: Add to cart
Click on the button with class Add cart successful
The button has transformed into Remove
Button found with text: Add to cart
Click on the button with class Add cart successful
The button has transformed into Remove
```

## Jmeter HTML Report: Download from azure artifact
<img width="733" alt="Capture d’écran 2024-08-15 à 21 24 07" src="https://github.com/user-attachments/assets/f06434d5-cc59-45ec-b74c-7a2af5387fa4">
<img width="733" alt="Capture d’écran 2024-08-15 à 21 24 38" src="https://github.com/user-attachments/assets/46b05182-0a90-4207-9f70-85d58b09a49f">
<img width="733" alt="Capture d’écran 2024-08-15 à 21 24 54" src="https://github.com/user-attachments/assets/c13ed03e-edd3-4029-88e3-cf548b11f4ca">

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
