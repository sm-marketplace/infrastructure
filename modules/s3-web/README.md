# S3 Web

Crea un bucket para alojar una página web, y provee una URL para que el público pueda acceder. 

- El acceso solo es permitido mediante HTTP (S3 no soporta SSL) 
- Si se quiere usar HTTPS, por ejemplo, se puede usar el servicio de Cloudfront (el modulo `cloudfront-dist` hace esta tarea)
