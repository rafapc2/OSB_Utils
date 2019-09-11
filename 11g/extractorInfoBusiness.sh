#!/bin/bash

# version: 0.1.1
# Objetivo: Permite tomar los proyectos OSB,  analizar los business, catalogar y separar los endpoint segun tipo
# v 0.1.0: 23/05/2018 Version inicial
# v 0.1.1: 03/06/2018 Se agrega soporte para endpoint EJB, SB y JCA

#   Copyright (C) 2018  Rafael Prudencio
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <https://www.gnu.org/licenses/>


echo "******************* INICIO *******************"
echo "**********************************************"

# ejemplo de salida del archivo f0_endpoints.csv
#osbBanco;BCO_BR_OPMOCUOWS_ModCompraCuotas_v1_0_IMPL/BusinessServices/BS_BCO_BRT_OPMOCUOWS_ModCompraCuotas.biz;http://mi.dominio.com/axis2/services/BACK_OPMOCUOWS

echo "procesando business ...."
find . -name '*.biz' -exec grep -iH '<env:value>' {} \; > f0_endpoints.csv

#se inicia proceso para limpiar archivo y  eliminar valores

echo "se elimina \"./\" inicial"
sed -i 's/\.\///g' f0_endpoints.csv

echo "se elimina \":      <env:value> \" y se reemplaza por \"=\""
sed -i 's/\:      /\;/g' f0_endpoints.csv


echo "Se elimina \"<env:value>\"  y \"</env:value>\""
sed -i -r 's/<[^>]+>//g' f0_endpoints.csv

echo "se reemplaza un espacio por \"__\" para el caso de los path con espacio."
sed -i 's/ /__/g' f0_endpoints.csv

nombreDominio=${PWD##*/}  
sed -i "s|^|${nombreDominio};|g" f0_endpoints.csv
echo ""

wc -l f0_endpoints.csv

echo ""
#read -p "Presiona cualquier tecla para continuar con el proceso de filtrado segun transport provider..."
echo ""
echo "Separando servicios por tipo:"
echo ""

#echo "Separando servicios TUXEDO"
cat f0_endpoints.csv | grep -i 'tuxedo:' >  TUXEDO_TRANSPORT_MDW_OSB.csv
wc -l TUXEDO_TRANSPORT_MDW_OSB.csv

#echo "Separando servicios FILE"
cat f0_endpoints.csv | grep -i 'file:' > FILE_TRANSPORT_MDW_OSB.csv
wc -l FILE_TRANSPORT_MDW_OSB.csv

#echo "Separando servicios JMS"
cat f0_endpoints.csv | grep -i 'jms:' > JMS_TRANSPORT_MDW_OSB.csv
wc -l JMS_TRANSPORT_MDW_OSB.csv

#echo "Separando servicios HTTP HTTPS"
cat f0_endpoints.csv | grep -i 'http' > HTTP_TRANSPORT_MDW_OSB.csv
wc -l HTTP_TRANSPORT_MDW_OSB.csv

#echo "Separando servicios EMAIL "
cat f0_endpoints.csv | grep -i 'mailto:' > EMAIL_TRANSPORT_MDW_OSB.csv
wc -l EMAIL_TRANSPORT_MDW_OSB.csv

#echo "Separando servicios JCA "
cat f0_endpoints.csv | grep -i 'jca:' > JCA_TRANSPORT_MDW_OSB.csv
wc -l JCA_TRANSPORT_MDW_OSB.csv

#echo "Separando servicios SB "
cat f0_endpoints.csv | grep -i 'sb:' > SB_TRANSPORT_MDW_OSB.csv
wc -l SB_TRANSPORT_MDW_OSB.csv

#echo "Separando servicios EJB "
cat f0_endpoints.csv | grep -i 'ejb:' > EJB_TRANSPORT_MDW_OSB.csv
wc -l EJB_TRANSPORT_MDW_OSB.csv

#echo "Separando servicios EJB "
cat f0_endpoints.csv | grep -i 'flow:' > FLOW_TRANSPORT_MDW_OSB.csv
wc -l FLOW_TRANSPORT_MDW_OSB.csv

echo ""

echo "*************** PROCESO FINALIZADO *******************"
echo "******************************************************"


