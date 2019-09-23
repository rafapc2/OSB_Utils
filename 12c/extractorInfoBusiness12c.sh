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

fileExp=f0_endpoints.csv
rm $fileExp



echo "procesando business ...."
find . -name '*.bix' -exec grep -iH '<env:value>' {} \; > $fileExp 

#se inicia proceso para limpiar archivo y  eliminar valores

echo "se elimina \"./\" inicial"
gsed -i 's/\.\///g' $fileExp 

echo "se elimina \":      <env:value> \" y se reemplaza por \";\""
gsed -i 's/\:      /\;/g' $fileExp 


echo "Se elimina \"<env:value>\"  y \"</env:value>\""
gsed -i -r 's/<[^>]+>//g' $fileExp 

echo "se reemplaza un espacio por \"__\" para el caso de los path con espacio."
gsed -i 's/ /__/g' $fileExp 

echo "se elimina ____________ que se genera en archivos 12c"
gsed -i 's/____________//g'  $fileExp 
echo ""
echo ""
#read -p "Presiona cualquier una tecla para continuar con el proceso de filtrado segun transport provider..."

nombreDominio=${PWD##*/}  
gsed -i "s|^|${nombreDominio};|g" $fileExp 
echo ""

wc -l $fileExp 

#cat $fileExp 
echo ""
echo ""
echo "Separando servicios por tipo:"
echo ""

#echo "Separando servicios TUXEDO"
cat $fileExp  | grep -i 'tuxedo:' >  TUXEDO_TRANSPORT_MDW_OSB.csv
wc -l TUXEDO_TRANSPORT_MDW_OSB.csv

#echo "Separando servicios FILE"
cat $fileExp  | grep -i 'file:' > FILE_TRANSPORT_MDW_OSB.csv
wc -l FILE_TRANSPORT_MDW_OSB.csv

#echo "Separando servicios JMS"
cat $fileExp  | grep -i 'jms:' > JMS_TRANSPORT_MDW_OSB.csv
wc -l JMS_TRANSPORT_MDW_OSB.csv

#echo "Separando servicios HTTP HTTPS"
cat $fileExp  | grep -i 'http' > HTTP_TRANSPORT_MDW_OSB.csv
wc -l HTTP_TRANSPORT_MDW_OSB.csv

#echo "Separando servicios EMAIL "
cat $fileExp  | grep -i 'mailto:' > EMAIL_TRANSPORT_MDW_OSB.csv
wc -l EMAIL_TRANSPORT_MDW_OSB.csv

#echo "Separando servicios JCA "
cat $fileExp  | grep -i 'jca:' > JCA_TRANSPORT_MDW_OSB.csv
wc -l JCA_TRANSPORT_MDW_OSB.csv

#echo "Separando servicios SB "
cat $fileExp  | grep -i 'sb:' > SB_TRANSPORT_MDW_OSB.csv
wc -l SB_TRANSPORT_MDW_OSB.csv

#echo "Separando servicios EJB "
cat $fileExp  | grep -i 'ejb:' > EJB_TRANSPORT_MDW_OSB.csv
wc -l EJB_TRANSPORT_MDW_OSB.csv

#echo "Separando servicios EJB "
cat $fileExp  | grep -i 'flow:' > FLOW_TRANSPORT_MDW_OSB.csv
wc -l FLOW_TRANSPORT_MDW_OSB.csv

echo ""

echo "*************** PROCESO FINALIZADO *******************"
echo "******************************************************"
