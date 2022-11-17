# Notas

## Eliminacion de Buckets

- para eliminar un bucket primero se setea el force_destroy:
  ```
  resource "aws_s3_bucket" "website_bucket" {
    bucket = var.domain_name
    force_destroy = true
  }
  ```
- luego apply para modificar el bucket
- luego podemos hacer el destroy comentando las lineas de codigo o directamente con terraform destroy si queremos borrar todo