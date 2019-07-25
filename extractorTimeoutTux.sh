#!/bin/bash
# version: 0.1.1
# Objetivo: Permite tomar los proyectos OSB,  analizar los business tuxedo y obtener el timeout de cada uno

echo "******************* INICIO *******************"
echo "**********************************************"


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

echo "procesando business Tuxedo...."
#find . -name '*.biz' -exec grep -iH '<tux:timeout>' {} \; > timeoutEndpointsTuxedo.txt
###find . -name '*.biz' -not -path '*/\.*' | xargs grep -i '<tux:timeout>' > timeoutEndpointsTuxedo.txt
###
###echo "se elimina \"./\" inicial"
###sed -i 's/\.\///g' timeoutEndpointsTuxedo.txt
###
###echo "se elimina \":      <tux:timeout> \" y se reemplaza por \"=\""
###sed -i 's/\:        /\=/g' timeoutEndpointsTuxedo.txt
###


echo "Iniciando Lectura del archivo:"

while IFS='' read -r line || [[ -n "$line" ]]; do
	echo "texto $line"
	 BSFile=$(echo $line | awk -F= '{print $1;}' )
	 BSTimeout=$(echo $line | awk -F= '{print $2;}' )
    echo "$BSFile"
	echo "$BSTimeout"
#done < "$1"

done < "timeoutEndpointsTuxedo.txt"
