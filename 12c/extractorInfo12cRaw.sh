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

# ejemplo de salida del archivo endpoints.txt
#./ATMGiroAsistido/Business Services/ATMGiroAsitido.biz:	<tran:provider-id>http</tran:provider-id>
#./BCO_CL_TUX_FM_SolicitudRescateRegistrar-v1_0_IMPL/BusinessServices/LogFMSolicitudRescateRegistrar.biz:      <env:value>file:///u01/apli/bea103/AppLog</env:value>
#./BCO_CL_TUX_FM_ValidarFechaContableObtener-v1_0_IMPL/BusinessServices/BS_CL_TUX_FMValFechConObt.biz:      <env:value>tuxedo:OSBFMValFechConObt/FMValFechConObt</env:value>


echo "procesando business ...."
find . -name '*.BusinessService' -exec grep -iH '<env:value>' {} \; > endpoints.txt

#se inicia proceso para limpiar archivo y  eliminar valores

echo "se elimina \"./\" inicial"
sed -i 's/\.\///g' endpoints.txt

echo "se elimina \":      <env:value> \" y se reemplaza por \"=\""
sed -i 's/\:      /\=/g' endpoints.txt


echo "Se elimina \"<env:value>\"  y \"</env:value>\""
sed -i -r 's/<[^>]+>//g' endpoints.txt

echo "se reemplaza un espacio por \"__\" para el caso de los path con espacio."
sed -i 's/ /__/g' endpoints.txt
echo ""
echo ""
read -p "Presiona cualquier una tecla para continuar con el proceso de filtrado segun transport provider..."

#cat endpoints.txt
echo ""
echo ""
echo "Separando servicios por tipo:"
echo ""

#echo "Separando servicios TUXEDO"
cat endpoints.txt | grep -i '=tuxedo:' >  TUXEDO_PROVIDER_MDW_OSB_XXX.properties
wc -l TUXEDO_PROVIDER_MDW_OSB_XXX.properties

#echo "Separando servicios FILE"
cat endpoints.txt | grep -i '=file:' > FILE_PROVIDER_MDW_OSB_XXX.properties
wc -l FILE_PROVIDER_MDW_OSB_XXX.properties

#echo "Separando servicios JMS"
cat endpoints.txt | grep -i '=jms:' > JMS_PROVIDER_MDW_OSB_XXX.properties
wc -l JMS_PROVIDER_MDW_OSB_XXX.properties

#echo "Separando servicios HTTP HTTPS"
cat endpoints.txt | grep -i '=http' > HTTP_PROVIDER_MDW_OSB_XXX.properties
wc -l HTTP_PROVIDER_MDW_OSB_XXX.properties

#echo "Separando servicios EMAIL "
cat endpoints.txt | grep -i '=mailto:' > EMAIL_PROVIDER_MDW_OSB_XXX.properties
wc -l EMAIL_PROVIDER_MDW_OSB_XXX.properties


#echo "Separando servicios JCA "
cat endpoints.txt | grep -i '=jca:' > JCA_PROVIDER_MDW_OSB_XXX.properties
wc -l JCA_PROVIDER_MDW_OSB_XXX.properties

#echo "Separando servicios SB "
cat endpoints.txt | grep -i '=sb:' > SB_PROVIDER_MDW_OSB_XXX.properties
wc -l SB_PROVIDER_MDW_OSB_XXX.properties

#echo "Separando servicios EJB "
cat endpoints.txt | grep -i '=ejb:' > EJB_PROVIDER_MDW_OSB_XXX.properties
wc -l EJB_PROVIDER_MDW_OSB_XXX.properties


echo ""
echo ""

echo "*************** PROCESO FINALIZADO *******************"
echo "******************************************************"
