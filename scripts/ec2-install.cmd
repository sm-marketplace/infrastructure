@echo off

echo installing on server DEV
ssh -i terraform-keys ubuntu@ec2-34-238-181-64.compute-1.amazonaws.com "sudo apt-get update && sudo apt-get install docker.io"

echo installing on server PROD
ssh -i terraform-keys ubuntu@ec2-3-226-6-32.compute-1.amazonaws.com "sudo apt-get update && sudo apt-get install docker.io"