## Infrastructure Engineering using Terraform 

# Infrastructure as a Code

Terraform is a vendor neutral tool for provisioning infrastructures on Cloud platform, it supports almost all public cloud providers including AWS, Azure, GCP.

The selected cloud provider for this exercise is *AWS*

For this typical infrastructure, the terraform file include :
* provider.tf : using AWS with the required version
* terraform.tfvars: to set default parameters for the infrastructure provisioning
* variables.tf: this include all variables required for the the resources deployment 
* main.tf: all resources to deployed can be declared in this file with reference to the variables.


# Resources Deployed

* Virtual Private Cloud(Highy avalialable AZs)
* Public and Private Subnets
* Internet Gateway
* NAT gateway
* AWS Security Group
* Bastion host
* Application Load Balancer
* Target groups and listener
* Auto Scaling Group (EC2 instances)
* AWS CloudWatch
* AWS SNS 

# Deployment steps

* Enable the IAM access using the AWS access and secret key, to have the priviledge accces to deploy resoucres on AWS.
* change directory to the parent directory of the repositiroy
* Use the following commands to deploy your infrastructure;
```
terraform init
terraform plan
terraform apply --auto-approve
```
* The ouput of the deplyments shows the load bbalancer url for the python application.
* The web applicaton is wriiten in python with flask package




