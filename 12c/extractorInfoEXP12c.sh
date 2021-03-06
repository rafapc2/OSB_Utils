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

# ejemplo de salida del archivo f1_exposiciones.csv TODO:

fileExp=f1_exposiciones.csv
rm $fileExp

echo "procesando proxy EXP ...."
find . -iname '*EXP*.proxy' -exec grep -iH '<env:value>' {} \; > $fileExp

#se inicia proceso para limpiar archivo y  eliminar valores

echo "se elimina \"./\" inicial"
gsed -i 's/\.\///g' $fileExp

echo "se elimina \":      <env:value> \" y se reemplaza por \";\""
gsed -i 's/\:      /\;/g' $fileExp


echo "Se elimina \"<env:value>\"  y \"</env:value>\""
gsed -i -r 's/<[^>]+>//g' $fileExp


#TODO mejorar esta parte con una regex
echo "se reemplaza un espacio por \"__\" para el caso de los path con espacio."
gsed -i 's/ /__/g' $fileExp
#elimina los espacios con excedentes 
gsed -i 's/;____________/;/g' $fileExp 

# fin TODO mejorar esta parte con una regex
echo ""
echo ""
#read -p "Presiona cualquier una tecla para continuar con el proceso de filtrado segun transport provider..."
nombreDominio=${PWD##*/}  
gsed -i "s|^|${nombreDominio};|g" $fileExp

echo ""
echo ""

wc -l $fileExp 

echo ""
echo ""

echo "*************** PROCESO FINALIZADO *******************"
echo "******************************************************"
