#!/bin/sh
#Download file from datos abiertos gob and preprocess
#file if -p option is included. Else, 
#download raw file.
set -e
set -u
set -o pipefail

touch /home/covid-data/Yaestoyfuncionando.txt

#Bandera de que todo el proceso fue correcto
flag_identified=true
flag_decompressed=true
flag_copied=true
flag_processed=true

#Obtenemos las opciones
process_data=false
while getopts 'hp' OPTION; do
  case "$OPTION" in
    p)
      echo "Preprocesaremos datos"
      process_data=true
      ;;

    h)
      echo "Usa la opción -p para preprocesar datos; deja sin esa opción para no procesarlos"
      exit 1
      ;;
  esac
done

#Descargamos, descomprimimos, copiamos y (opcional) procesamos datos
while $flag_decompressed & $flag_copied & $flag_identified & $flag_processed; do 

    echo "Descargando datos..."
    while true; do
    wget -q -T 60 -c http://datosabiertos.salud.gob.mx/gobmx/salud/datos_abiertos/datos_abiertos_covid19.zip && break
    done

    echo "Descomprimiendo..."
    DATOS=$(unzip -Z1 datos_abiertos_covid19.zip)
    if [ "$?" -eq 0 ]; then
        echo "Leyendo archivo ${DATOS}"
        flag_identified=false
    fi
    unzip datos_abiertos_covid19.zip
    if [ "$?" -eq 0 ]; then
        echo "Archivo descomprimido exitosamente"
        flag_decompressed=false
    fi
    rm datos_abiertos_covid19.zip

    echo "Copiando..."
    fecha_descarga=$(date)
    mv -f $DATOS "COVID ${fecha_descarga}.csv"
    if [ "$?" -eq 0 ]; then
        echo "Archivo copiado exitosamente"
        flag_copied=false
    fi

    if [ $process_data ]; then
        echo "Procesando datos"
        python3 /process_data.py "COVID ${fecha_descarga}.csv"
        if [ "$?" -eq 0 ]; then
            echo "Archivo procesado exitosamente"
            flag_processed=false
        fi
    else
        flag_processed=false
    fi

done
echo "Todo salió bien"