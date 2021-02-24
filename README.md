# react-aws-terraform-github-actions

A complete example of provisioning a React app in AWS with deployment pipeline.

Features:

* Hosted in AWS S3
* Cloudfront CDN
* SSL
* Infrastructure provisioned by Terraform
* Github Actions deployment pipeline


S3 with Cloudfront. Github actions deployment pipeline. All infrastructure is provisioned using Terraform.


## Pre-requisites

1) An AWS account 
2) (For Terraform) An AWS User with programmatic access (an Access Key ID and Secret Access Key) and the following Permissions
   - AmazonS3FullAccess
   - CloudFrontFullAccess
   - AWSCertificateManagerFullAccess
2) (For Github Deployment pipeline) An AWS User with the following permissions:
   - TODO
   - TODO
2) Terraform ([Installation Instructions](https://www.terraform.io/downloads.html)) 

## Instructions


### Setup terraform

```bash
export AWS_ACCESS_KEY_ID=<your-aws-access-key-id>
export AWS_SECRET_ACCESS_KEY=<your-aws-secret-access-key>
```

```bash
cd infrastructure
terraform init
```

```bash
terraform plan
```

Result of running plan
```bash
Plan: 3 to add, 0 to change, 0 to destroy.
```

```bash
terraform apply
```

You will get an error from the Cloudfront that the SLL certificate doesn't exist - TODO: Create that first, before creating the cloudfront distribution

### Confirm certificate

You will need to manually validate the certificate. Log into the AWS console and make sure you are in the `us-east-1` region. Navigate to the `Certificate Manager` and you will find the domain name waiting for validation. Follow the steps listed in the AWS Console to validate the domain. This involves a CNAME record to your DNS.

Wait a few minutes for it to verify.

### Create the cloudfront distribution

This will take a few minutes to complete

TODO: separate this out.


### Update your DNS record 

The Cloudfront distribution will be given a domain. Create a CNAME record pointing to that domain.



## TODOs

- make the domain name configurable