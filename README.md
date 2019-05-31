# Forest
 Script que crea una galeria html con imagenes jpg,jpeg,png de la carpeta actual en que se ejecuta el script, tiene la opcion para mostrar la descripcion EXIF de las imagenes.
 
 Las opciones son las siguientes:
 
     -f           No elimina lista de archivos file.txt creada
     -e           Agrega informacion EXIF a la descripcion de la imagen (proceso lento!!)
     -r           Elimina la galeria previamente creada 
     -s           No hay tamaño limite para procesar la imagen (limite de 6 MB por defecto)
     -t LIMITE    Limite de tamaño de imagen, donde LIMITE es el tamaño en KB
     -v           Muestra todos los mensajes de procesamiento
     -q           Muestra la minima cantidad de mensajes, modo "silencioso" (anula -v)
     -h           Muestra esta ayuda

La galeria creada tiene como nombre "galeria.html" y se puede abrir con cualquier navegador web.

Paquetes necesario para funcionar: 
```bash
exiftool mogrify
```
