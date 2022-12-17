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

## TODO:

- manejar entornos (ej: x workspaces) para reducir la cantidad de variables

## Conexion EC2

```ssh -i terraform-keys ubuntu@ec2-3-226-6-32.compute-1.amazonaws.com```

## EC2 install docker
```sh
sudo apt-get update
sudo apt-get install docker.io
```
check docker running
```service docker.io status```

start docker
```service docker.io start```