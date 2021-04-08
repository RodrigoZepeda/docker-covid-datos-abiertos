# docker-covid-datos-abiertos

Docker que se dedica a descargar y limpiar los datos abiertos de COVID-19 en México [(fuente)](http://datosabiertos.salud.gob.mx/gobmx/salud/datos_abiertos/) cada 6 horas.

Para ello lo único que tienes que hacer es crear un volumen. En este caso yo lo estoy creando en el directorio `Users/rod/covid_conacyt` pero tú puedes cambiar el `device` al sitio de tu preferencia. 

```{bash}
docker volume create --name covid --opt type=none --opt device=/Users/rod/covid_conacyt --opt o=bind
```

corre el docker
```{bash}
docker run -ti --mount source=covid,target=/covid-data --restart=unless-stopped rodrigozepeda/covid-datos-abiertos
```