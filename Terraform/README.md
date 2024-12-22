# AWS Server Setup with Terraform

## Overview

This repository contains Terraform configurations for setting up a tiered architecture on AWS.

## Directory Structure

The project is organized into directories representing different AWS services and components:
![Directory Structure](https://github.com/sushant9822/aws-s3-assigment/blob/main/screenshots/terraform-structure.png)
- `loadbalancer` - Application Load Balancer
- `ec2` - Amazon Elastic Compute Cloud
- `vpc` - AWS Virtual Private Cloud
## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine
- An AWS account with appropriate permissions
- AWS CLI configured with your credentials
- An S3 bucket for storing Terraform state files (optional, if using remote state)

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/Dhirva/AWS-ALB-S3-Terraform.git
cd Terraform 
```
### Configuration
#### 1. Update Variables:
   
   Navigate to specific directory example: EC2-ALB, VPC
   Edit terraform.tfvars or use environment variables to set the required values for your setup.

#### 2. Create AWS Profile
   ```bash
   aws configure --profile= <profile_name>
   ```
   
#### 3. Initialize Terraform:
   ```bash
    terraform init
   ```
#### 4. Create Terraform workspace
   ```bash
   terraform workspace new <workspace name>
   ```
#### 5. Plan the Infrastructure:
   ```bash
   terraform plan
   ```
#### 6. Create Parameter Store Manually (Optional):
   Add the paramteres like ```S3_BUCKET_NAME , AWS_REGION , AWS_ACCESS_KEY_ID , AWS_SECRET_ACCESS_KEY``` and specify the variable name in the EC2 userdata to get the values fetched from parameter store.

#### 7. Apply the Configuration:
   ```bash
   terraform apply
   ```
#### NOTE: I have written user_data script while EC2 Creation which will take care of installing and running app in background using docker.


   

