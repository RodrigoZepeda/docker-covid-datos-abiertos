#!/usr/bin/env python3
import sys
import pandas as pd
from datetime import datetime
file_name = sys.argv[1] #Name of the file to read

#Columnas a quedarnos
keep_cols = ['ID_REGISTRO','SECTOR','ENTIDAD_UM','SEXO','ENTIDAD_NAC','ENTIDAD_RES', 'MUNICIPIO_RES',
             'TIPO_PACIENTE','FECHA_INGRESO','FECHA_SINTOMAS','FECHA_DEF','EDAD','CLASIFICACION_FINAL']

#Lectura de la base de datos
archivo  = pd.read_csv(file_name, usecols=lambda cc : cc in keep_cols, index_col=False,
                       dtype={'ID_REGISTRO': 'string', 'SECTOR': 'int', 'ENTIDAD_UM': 'int', 'SEXO': 'int',
                              'ENTIDAD_RES': 'int', 'MUNICIPIO_RES': 'int', 'TIPO_PACIENTE': 'int',
                              'FECHA_INGRESO': 'string', 'FECHA_SINTOMAS': 'string',
                              'FECHA_DEF': 'string', 'EDAD': 'int', 'CLASIFICACION_FINAL': 'int'})

archivo["FECHA_DESCARGA"] = datetime.now().strftime("%Y-%m-%d")
archivo["HORA_DESCARGA"]  = datetime.now().strftime("%H:%M:%S")

archivo.to_csv("/home/covid-data/COVID.csv", index = False)
