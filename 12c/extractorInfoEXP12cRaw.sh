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

# ejemplo de salida del archivo exp.txt TODO:


echo "procesando proxy EXP ...."
find . -name '*.ProxyService' -exec grep -iH '<env:value>' {} \; > exp.txt

#se inicia proceso para limpiar archivo y  eliminar valores

echo "se elimina \"./\" inicial"
sed -i 's/\.\///g' exp.txt

echo "se elimina \":      <env:value> \" y se reemplaza por \"=\""
sed -i 's/\:      /\=/g' exp.txt


echo "Se elimina \"<env:value>\"  y \"</env:value>\""
sed -i -r 's/<[^>]+>//g' exp.txt

echo "se reemplaza un espacio por \"__\" para el caso de los path con espacio."
sed -i 's/ /__/g' exp.txt
echo ""
echo ""
read -p "Presiona cualquier una tecla para continuar con el proceso de filtrado segun transport provider..."

#cat exp.txt

echo ""
echo ""

echo "*************** PROCESO FINALIZADO *******************"
echo "******************************************************"
