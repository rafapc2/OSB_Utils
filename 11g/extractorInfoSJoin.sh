#!/bin/bash
# version: 0.1.1
# Objetivo: Permite tomar los proyectos OSB,  analizar los split join con informacion de dependencias
# v 0.1.0: 23/05/2018 Version inicial
# v 0.1.1: 31/09/2019 Se agrega logica para multilinea.. aun pendiente de automatización

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

# ejemplo de salida del archivo f0_splitJoin.csv TODO:
fileName=f0_splitJoin.csv
rm $fileName

echo "procesando proxy Split Join ...."
find . -iname '*.flow' -not -path "*.metadata*" -exec grep -iH 'isProxy' {} \; > $fileName

#se inicia proceso para limpiar archivo y  eliminar valores

echo "se elimina \"./\" inicial"
gsed -i 's/\.\///g' $fileName

#verificando si hay estructuras multilinea, los Split Join tienden a no ser estandar

countErr=0
countOk=0
while IFS= read -r line 
do 
    #revisando completitud
    if [[ $line == *"ref="* ]]; then
        countOk=$(( $countOk +1 ))
    else
        countErr=$(( $countErr +1 ))
        echo ""
        printf "WARNING posible informacion faltante.. revise archivo: $line"
    fi    
done < $fileName
echo ""
echo ""
echo "$countErr linea(s) de WARNING por posible informacion faltante --> EDITE el(los) archivos y corrija manualmente"
echo "$countOK linea(s) correctas"
#eliminando texto </bpel:invoke></bpel:sequence>
gsed -i 's/<rescon:service //g' $fileName
gsed -i 's/isProxy\=\"true\"//g' $fileName

#eliminando texto </rescon:service> </rescon:invokeInfo> y </bpel:invoke> y </bpel:sequence>
gsed -i 's/<\/rescon:service>//g' $fileName
gsed -i 's/<\/rescon:invokeInfo>//g' $fileName
gsed -i 's/<\/bpel:invoke>//g' $fileName
gsed -i 's/<\/bpel:sequence>//g' $fileName


#grupo de textos, tab y espacios
gsed -i 's/.flow/.flow;/g' $fileName
gsed -i  's/\/>//g' $fileName
gsed -i -r 's/[:\">]//g' $fileName
gsed -i  's/\t//g' $fileName
gsed -i 's/ //g' $fileName
gsed -i 's/ref\=//g' $fileName

gsed -i  's/$/.proxy/g' $fileName

echo ""
#read -p "Presiona cualquier tecla para finalizar con el proceso de filtrado "
nombreDominio=${PWD##*/}  
gsed -i "s|^|${nombreDominio};|g" $fileName

echo ""
echo ""

wc -l $fileName 

echo ""
echo ""

echo "*************** PROCESO FINALIZADO *******************"
echo "******************************************************"
