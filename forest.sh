#! /bin/bash

hola ()
{
echo "                                                  ";
echo "   █████▒▒█████   ██▀███  ▓█████   ██████ ▄▄▄█████▓";
echo " ▓██   ▒▒██▒  ██▒▓██ ▒ ██▒▓█   ▀ ▒██    ▒ ▓  ██▒ ▓▒";
echo " ▒████ ░▒██░  ██▒▓██ ░▄█ ▒▒███   ░ ▓██▄   ▒ ▓██░ ▒░";
echo " ░▓█▒  ░▒██   ██░▒██▀▀█▄  ▒▓█  ▄   ▒   ██▒░ ▓██▓ ░ ";
echo " ░▒█░   ░ ████▓▒░░██▓ ▒██▒░▒████▒▒██████▒▒  ▒██▒ ░ ";
echo "  ▒ ░   ░ ▒░▒░▒░ ░ ▒▓ ░▒▓░░░ ▒░ ░▒ ▒▓▒ ▒ ░  ▒ ░░   ";
echo "  ░       ░ ▒ ▒░   ░▒ ░ ▒░ ░ ░  ░░ ░▒  ░ ░    ░    ";
echo "  ░ ░   ░ ░ ░ ▒    ░░   ░    ░   ░  ░  ░    ░      ";
echo "            ░ ░     ░        ░  ░      ░           ";
echo "                                                   ";
}

thumbdir ()
{
if [ -d thumb_dir ];
then
        echo
	echo " -Galeria encontrada, actualizando..."
        echo
        rm thumb_dir/*.*

else
        echo
	echo " -No existe galeria anterior creada, generando galeria..."
        echo
	mkdir thumb_dir
        
fi

if [ "$quiet" == "q" ]
then 
    count=0
else
    echo "  -Generando thumbnails..."
    echo
fi

htmlgen
}

htmlgen ()
{
count=0
countbr=0
countz=6
countkb=0
countno=0

ls --sort=size *.jpg >>file.txt 2> /dev/null
ls --sort=size *.jpeg >>file.txt 2> /dev/null
ls --sort=size *.png >>file.txt 2> /dev/null
ls --sort=size *.gif >>file.txt 2> /dev/null

echo /dev/null > $name > /dev/null

carpeta=$DIRSTACK
hostn=$HOSTNAME  
tipom=$HOSTTYPE
dirtotal=$PWD
tipoos=$OSTYPE

while read listsize
do 
            SS=`du -k "$listsize" | cut -f1`
            let count+=1
            if [ $SS -ge $sizemax ]
               then 
                      let countbr-=1 
                      let countno+=1                       
               else
                  let countkb+=SS
            fi
            
done < file.txt

printf "<!DOCTYPE html>\n<html>\n<head>\n
<title>-- Galeria de imagenes en %s de %s </title>\n
</head>\n\n<body>\n
<BODY BGCOLOR=\"#0B0035\"><body text= \"#0099e6\">\n
<br>\n
<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;}
.tg td{font-family:Arial, sans-serif;font-size:14px;padding:6px 5px;border-style:solid;border-width:0px;overflow:hidden;word-break:normal;}
.tg th{font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:6px 5px;border-style:solid;border-width:0px;overflow:hidden;word-break:normal;}
.tg .tg-yw4l{vertical-align:top}
.tg .tg-uejz{color:#80d4ff;vertical-align:top}
</style>
<table class=\"tg\">
  <tr>
    <td class=\"tg-yw4l\">Hostname..............</td>
    <td class=\"tg-uejz\">%s</td>
  </tr>
  <tr>
    <td class=\"tg-yw4l\">Arquitectura..........</td>
    <td class=\"tg-uejz\">%s</td>
  </tr>
  <tr>
    <td class=\"tg-yw4l\">OS........................</td>
    <td class=\"tg-uejz\">%s</td>
  </tr>
  <tr>
    <td class=\"tg-yw4l\">Ruta completa.......</td>
    <td class=\"tg-uejz\">%s</td>
  </tr>
  <tr>
    <td class=\"tg-yw4l\">Cantidad imagenes</td>
    <td class=\"tg-uejz\">%s</td>
  </tr>
  <tr>
    <td class=\"tg-yw4l\">Tama&ntilde;o total.........</td>
    <td class=\"tg-uejz\">%s KB</td>
  </tr>
</table>
<div align=center><br>\n" "$carpeta" "$hostn" "$HOSTNAME" "$HOSTTYPE" "$OSTYPE" "$PWD" "$count" "$countkb" >> $name

count=0
countbr=0

while read line
do 
            FILESIZE=`du -k "$line" | cut -f1`
            let count+=1
            let countbr+=1
            if [ $FILESIZE -ge $sizemax ]
               then 
                  if [ "$quiet" == "q" ]
                    then 
                      let countbr-=1 
                      let countno+=1                       
                    else
                      echo -e "Generando $line $FILESIZE bytes.......Archivo muy pesado"
                      let countbr-=1 
                      let countno+=1
                    fi
               else
                  if [ "$verbose" == "v" ]
                    then 
                       echo -e "Generando $line $FILESIZE bytes.......OK"
                       loophtml
                    else
                       loophtml
                  fi
                  let countkb+=FILESIZE
            fi
            
done < file.txt

printf "</div>\n  
</body>\n
</html>\n" >> $name
counter
}

loophtml ()
{
cp "$line" thumb_dir
mv thumb_dir/"$line" thumb_dir/$count.jpg
mogrify -resize 128x128! thumb_dir/$count.jpg


exiftype=`echo "$line" | cut -d "." -f 2`

if [ $exif -eq 1 ]
  then
      exifcam=`exiftool "$line" | grep "Camera Model Name" | cut -d ":" -f 2`
      exifiso=`exiftool "$line" | grep "ISO" | cut -d ":" -f 2`
      exifcdate=`exiftool "$line" | grep "Create date" | cut -d ":" -f 2`
      exifspeed=`exiftool "$line" | grep "Shutter Speed Value" | cut -d ":" -f 2`
      exifaper=`exiftool "$line" | grep "Aperture Value" | cut -d ":" -f 2`

      if [ $countbr -eq $countz ];
        then
           printf "<a href="%s" target="_blank"><img src=\"thumb_dir/%s.jpg\" alt=\"%s\" border=\"1\" title=\" File Name: %s &#13; File Size: %s KB&#13; File Type: %s &#13; Camera Model Name: %s &#13; ISO: %s &#13; Create Date: %s &#13; Shutter Speed Value: %s &#13; Aperture Value: %s\"/></a><br>\n" "$line" "$count" "$line" "$line" "$FILESIZE" "$exiftype" "$exifcam" "$exifiso" "$exifcdate" "$exifspeed" "$exifaper">> $name
           countbr=0
        else
           printf "<a href="%s" target="_blank"><img src=\"thumb_dir/%s.jpg\" alt=\"%s\" border=\"1\" title=\" File Name: %s &#13; File Size: KB%s &#13; File Type: %s &#13; Camera Model Name: %s &#13; ISO: %s &#13; Create Date: %s &#13; Shutter Speed Value: %s &#13; Aperture Value: %s\"/></a>\n" "$line" "$count" "$line" "$line" "$FILESIZE" "$exiftype" "$exifcam" "$exifiso" "$exifcdate" "$exifspeed" "$exifaper">> $name
     fi
  else
     if [ $countbr -eq $countz ];
        then
           printf "<a href="%s" target="_blank"><img src=\"thumb_dir/%s.jpg\" alt=\"%s\" border=\"1\" title=\" File Name: %s &#13; File Size: %s KB &#13; File Type: %s\"/></a><br>\n" "$line" "$count" "$line" "$line" "$FILESIZE" "$exiftype">> $name
           countbr=0
      else
           printf "<a href="%s" target="_blank"><img src=\"thumb_dir/%s.jpg\" alt=\"%s\" border=\"1\" title=\" File Name: %s &#13; File Size: %s KB &#13; File Type: %s\"/></a>\n" "$line" "$count" "$line" "$line" "$FILESIZE" "$exiftype">> $name
     fi
fi
}

counter ()
{
if [ "$quiet" == "0" ] 
   then 
      let countkb=countkb/1024
      countok=0
      let countok=count-countno
      echo
      echo "  ---------------------------------------"
      echo "   Cantidad de imagenes rechazadas = $countno "
      echo "   Cantidad de imagenes OK = $countok        " 
      echo "   Total MB imagenes OK = $countkb            "
      echo "  ---------------------------------------"
      echo  
   else 
      echo    
fi
unset countno count countkb
}


delfile ()
{
rm file.txt
}


delall ()
{
if [ -d "$optdir"thumb_dir ];
then
    echo " -Eliminando galeria y carpeta thumbnails..."
    echo
    rm thumb_dir/*.*
    rm -d thumb_dir
    rm $name
    exit
else
    echo " -No se puede borrar algo ya eliminado..."
    echo
    exit
fi
}

ayuda ()
{
echo
echo " Forest crea una galeria con imagenes jpg,jpeg,png de la carpeta actual en formato HTML
  
     -f           No elimina lista de archivos file.txt creada
     -e           Agrega informacion EXIF a la descripcion de la imagen (proceso lento!!)
     -r           Elimina la galeria previamente creada 
     -s           No hay tamaño limite para procesar la imagen (limite de 6 MB por defecto)
     -t LIMITE    Limite de tamaño de imagen, donde LIMITE es el tamaño en KB
     -v           Muestra todos los mensajes de procesamiento
     -q           Muestra la minima cantidad de mensajes, modo \"silencioso\" (anula -v)
     -h           Muestra esta ayuda

"
exit
}

start_time=$( date +%s )
sizemax=1000
quiet="0"
verbose="0"
name="galeria.html"
##thumbd="thumb_dir"
optdir=""
exif=0
dummy=0

while getopts ":hefsqvt:r" opt; do        
   case $opt in
      f) hola && thumbdir && exit ;;
      e) exif=1 ;;
      h) ayuda ;;
      r) delall && exit ;;
      s) sizemax=10000000 ;;
      t) sizemax=$OPTARG ;;
      v) verbose="v" ;;
      q) quiet="q" ;;
      *) echo " Opción inválida: -$OPTARG" && ayuda ;;
   esac
done

if [ "$quiet" == "q" ] 
    then
      verbose="p"
fi
hola
thumbdir
delfile
 
unset 
finish_time=$( date +%s )
echo "Time duration: $((finish_time - start_time)) secs."



