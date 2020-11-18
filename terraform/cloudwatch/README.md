## How to run

1. Within the "terraform/cloudwatch" directory run: `cp tfvars.copy terraform.tfvars`  
2. Modify desired fields. API KEY is really the only neccesary one.
3. Run: `terraform init`
4. Run: `terraform plan`
5. Run: `terraform apply`
  
  
6. To clean up, run: `terraform destroy`