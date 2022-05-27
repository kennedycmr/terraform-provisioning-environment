# Overview

This repository is a basic setup of scripts to setup a development environment
with Terraform, ready to deploy code. 

My use case is typically GCP and using BitBucket for my repo and pipelines. Thus 
my variables are specific to those platforms. But if you use another git provider 
and/or another cloud provider you can modify as needed.

The basic terraform init assumes you want the state file to reside on a GCP bucket.

# Dependancies

* These are Linux scripts, designed to be run on an interactive container session. 
* The container image I use is gcr.io/google.com/cloudsdktool/cloud-sdk:latest

# How to Use

To get started, you will need to do the following minimum steps: 
* Edit ./test/environment_variables and set the required variables for your environment.
* Make sure the storage bucket for the state file exists and the account has rights to it.
* If you want to use a service account, put in in the location you defined with the environment variable.
* Run the setup script with the command: 
```
cd ./test
source ./terraform_setup.sh
```
* Depending on whether you are using service account keys or not, it will either authenticate
 to GCP using those keys, or prompt you to authenticate.
 