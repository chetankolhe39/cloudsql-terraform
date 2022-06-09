#1.Remediation use case - Google Cloud SQL:
   Ensure that Cloud SQL database instances are not wide open to the Internet.

#2. Why remediation:
    As this SQL instance is open to internet we need to restrict its access to our office network only

#2. Remediation Solution:
    First, we will setup the Google Cloud SQL instance using terraform script (in this SQL instance is accessible to internet).
    Second, we will restrict SQL instance access to our office network only using terraform.

#4. Roles, permissions required for IAM user to execute the remediation script:
    A. Enable Cloud SQL Admin Api using gcp console.
    B. Create service account and assign CloudSQLAdmin role to that service account using below commands:
       1. gcloud iam service-accounts create sa-terraform --display-name "Terraform service account"
       2. gcloud projects add-iam-policy-binding PROJECT_ID --member="serviceAccount:sa-terraform@PROJECT_ID.iam.gserviceaccount.com" --role="roles/cloudsql.admin"
    C. Create service account key which will be used by terraform:
       1. gcloud iam service-accounts keys create key.json --iam-account sa-terraform@PROJECT_ID.iam.gserviceaccount.com
    D. Export GOOGLE_APPLICATION_CREDENTIALS:
       1. export GOOGLE_APPLICATION_CREDENTIALS=key.json

#5. Variables used in terraform script:
    A. Variables inside variables-1.tfvars file (Used for Cloud SQL setup)
       project = "project_id"
       region = "region"
       password = "password"
       cidr-name = "open-to-all"
       cidr ="0.0.0.0/0"
    B. Variables inside variables-2.tfvars file (Used for remediation i.e. to restrict the access of instance to internet)
       project = "project_id"
       region = "region"
       password = "password"
       cidr-name = "opcito-office"
       cidr ="1.1.1.1/32"
     

#6. Steps for creating Cloud SQL instance using terraform script:
    A. We need to use variables-1.tfvars and main.tf files to setup Cloud SQL instance which is open to internet: 
       1. terraform init ==>(One time activity after git clone)
       2. terraform plan -var-file=variables-1.tfvars ==>(Shows which resources will be created)
       3. terraform apply -var-file=variables-1.tfvars ==>(Creates resources)

#7. Steps to destroy the Cloud SQL setup:
    1. terraform plan -destroy
    2. terraform apply -destroy

#8. Remediation Steps:
    A. We need to use variables-2.tfvars and main.tf files for remediation, it will restrict Cloud SQL instance access to opcito office network only:
       1. terraform plan -var-file=variables-2.tfvars ==>(Shows which resources will be updated)
       2. terraform apply -var-file=variables-2.tfvars ==>(Updates resources)

