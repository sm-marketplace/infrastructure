Para configurar la infraestructura en un nuevo backend (DESDE CERO) debe primero crear el bucket para su backend.


Para hacerlo en AWS puede seguir el tutorial: https://www.golinuxcloud.com/configure-s3-bucket-as-terraform-backend/


Una vez tenga creado el backend debe colocar tanto el nombre del bucket como de la tabla de dynamo en el archivo main.tf


```
terraform {
  backend "s3" {
    bucket         = "rgb-terraformbe"     <--
    key            = "terraform.tfstate"
    region         = "us-east-1"  
    dynamodb_table = "rgb-terraform-table" <--
  }
```

Para generar la infraestructura desde cero, elimine la carpeta `.terraform` y el fichero `.terraform.lock.hcl`


Luego puede ejecutar `terraform init` seguido de `terraform apply` para levantar la infraestructura.