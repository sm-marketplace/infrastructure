## Infraestructure

**Requirements**
- Terraform v1.3.4
- AWS account
- NodeJS

_Needs configure AWS Bucket as a Terraform Backend (for generate from scratch see [here](man/new-terraform-backend.md))_

**Up the infraestructure**
```sh
git clone https://github.com/sm-marketplace/infrastructure.git
cd infrastructure
terraform init
terraform plan
terraform apply -auto-approve
terraform output > infra-out
```

Las instacias de EC2 requieren tener docker instalado, para instalar estas dependencias ejecute:

```sh
node scripts/ec2install.js
```