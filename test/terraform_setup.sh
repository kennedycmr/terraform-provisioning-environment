#!/bin/bash 
# This is the version of Terraform we will use
export TERRAFORM_VERSION=1.2.1



# Setup environment
if [ -f ./environment_variables ]; then
    source ./environment_variables
else
    printf "Didnt find ./environment_variables. How can we setup the environment?"
    return 1
fi



# Update OS Packages.
printf 'Updating Debian packages...\n\n\n'
apt update
apt install -y unzip gettext-base python3 python3-dev python3-venv wget vim



# re-export every os variable to be prefixed with TF_VAR_ so that terraform
# can use them if wanted
for VARIABLE in $(env |cut -d"=" -f 1); do
    export TF_VAR_${VARIABLE}=${!VARIABLE}
done



### Authenticate to GCP...
if [ x"${GOOGLE_APPLICATION_CREDENTIALS}" != "x" ]; then
    printf "\nFound \$GOOGLE_APPLICATION_CREDENTIALS set. Will use that for credentials...\n"

elif [ -f $GCP_SA_KEYS ]; then
    printf "\nFound \$GCP_SA_KEYS, will try and authenticate with ${GCP_SA_KEYS}...\n"
    gcloud auth activate-service-account --key-file=${GCP_SA_KEYS}
    export GOOGLE_APPLICATION_CREDENTIALS=${GCP_SA_KEYS}

elif [ gcloud auth application-default print-access-token 1>/dev/null 2>&1 ]; then
    printf "\nFound we have a gcloud app-default token...\n"

else
    printf "\nDidn't find any existing keys or tokens. You will need to authenticate to gcp:\n\n"
    gcloud auth application-default login --no-launch-browser
fi



# Setup Terraform.
echo "INFO: Setting up Terraform environment..."
cd ~
rm -rf terrafor*
wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
export PATH=$PATH:$(pwd)



# Provision Terraform resources.
cd ${BITBUCKET_CLONE_DIR}/terraform



# Initialize and download plugins needed for Terraform 
terraform init \
         -backend-config="bucket=${TERRAFORMSTATE_BUCKET_NAME}" \
         -backend-config="prefix=terraform/state/${BITBUCKET_REPO_SLUG}"

