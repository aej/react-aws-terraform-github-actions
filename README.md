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
   - IAMFullAccess
2) (For Github Deployment pipeline) An AWS User with the following permissions:
   - AmazonS3FullAccess 
   - CloudFrontFullAccess
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

and

```bash
terraform apply
```

If you get an error from Cloudfront that the SLL certificate doesn't exist then manually verify the Certificate (see below) and re-apply the Terraform.

### Confirm certificate

Log into the AWS console and make sure you are in the `us-east-1` region. Navigate to the `Certificate Manager` and you will find the domain name waiting for validation. Follow the steps listed in the AWS Console to validate the domain. This involves setting up a CNAME record in your DNS.

Wait a few minutes for it to verify.


### Update your DNS record 

The Cloudfront distribution will be given a domain. Create a CNAME record pointing to that domain. It can take some time for this to propagate.

## Create a policy to allow the CI User to invalidate paths

Our Terraform should have created a policy called `cloudfront-invalidate-paths`. Inside the AWS Console attach this policy to the Github Actions deployment User.

## Add the following secrets to Github Actions:

| NAME | VALUE |
| ---- | ----- |
| AWS_ACCESS_KEY_ID | aws-access-key-id |
| AWS_SECRET_ACCESS_KEY | aws-secret-key |
| S3_BUCKET_NAME | react-aws-terraform-github-actions |
| CLOUDFRONT_DISTRIBUTION_ID | cloudfront-distribution-id |

