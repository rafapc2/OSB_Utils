#!/bin/bash
# version: 0.1.1
# Objetivo: Permite tomar los proyectos OSB,  analizar los proxy y business, catalogar y separar los endpoint segun tipo
# v 0.1.0: 23/05/2018 Version inicial
# v 0.1.1: 03/06/2019 Se agrega soporte dependencias COMP e IMPL

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

# Funcion de busqueda bajo patrones de texto conocidos 
function fnBuscarPorPatronesConocidos(){
    #eliminamos archivo en caso que exista.
    rm -f $1 || true
    #Aplicamos busqueda y filtros default
    echo "Iniciando busqueda de referencias de proxy a proxy"
    find . -iname "${2}" -exec grep -iH 'ref:ProxyRef' {} \;  > $1
    echo "Num Registros Parcial:"
    wc -l $1

    echo "Iniciando busqueda de referencias de proxy a business"
    find . -iname "${2}" -exec grep -iH 'ref:BusinessServiceRef' {} \;  >> $1
    echo "Total Registros:"
    wc -l $1

}

#Funcion para dejar solo el texto necesario para el analisis
function fnLimpiarValores(){

    echo "Procesando Archivo $1 para eliminar informacion innecesaria"
    gsed -i 's/\.\///g' $1
    gsed -i 's/proxy\:.*</proxy\;</g' $1
    gsed -i 's/proxy\;.* ref\=/proxy\;/g' $1
    gsed -i 's/xmlns\:ref\=\"http\:\/\/www\.bea\.com\/wli\/sb\/reference\"\/>//g'  $1
    gsed -i 's/xsi\:type\=\"ref\:ProxyRef\"//g' $1

    #caso especial de comp a impl
    gsed -i 's/ xsi\:type\=\"ref\:BusinessServiceRef\"//g' $1
    # fin caso especial

    gsed -i 's/ /__/g' $1
    #eliminando caracteres al final de la linea
    gsed -i 's/_*$//' $1
    gsed -i 's/\"//g' $1
    echo "Total Registros en archivo:"
    wc -l $1
}

#funcion especializada en busqueda y registro de referencias desde capa EXP a COMP
function fnBuscarRegistrarReferencias(){
    
    echo "Iniciando comparacion y busqueda de referencias EXP a COMP/IMPL"
    rm -f tmp_PxComposiciones.txt || true
    rm -f tmp_PxImplementaciones.txt || true
    rm -f tmp_BizImplementaciones.txt || true
    rm -f f2_exposiciones2comp.csv || true
    fileExp=f1_exposiciones.csv
    count=0
    countComp=0
    countImpl=0
    countOtros=0
    
    while IFS=";" read -r mdwDominio proxyExp uriExp
    do
        count=$(( $count +1 ))
        #echo "$count - $mdwDominio $proxyExp $uriExp"
        #echo "Buscando texto en  referencias y extrayendo a variable pathNextComp"
        nextComp="$(grep -i $proxyExp tmp_refereciasDeEXP.txt)"
        IFS=';' read -r -a pathNextComp <<< "$nextComp"

        #echo "num elementos ${#pathNextComp[@]}"

        if [[ ${pathNextComp[1]} == *"_COMP"* ]]; then
            echo "${pathNextComp[1]}.proxy" >> tmp_PxComposiciones.txt
            echo "$mdwDominio;$proxyExp;$uriExp;${pathNextComp[1]}.proxy" >> f2_exposiciones2comp.csv
            countComp=$(( $countComp + 1 ))
        elif [[ ${pathNextComp[1]} == *"_IMPL"* ]]; then
            echo "${pathNextComp[1]}.proxy" >> tmp_PxImplementaciones.txt
            echo "$mdwDominio;$proxyExp;$uriExp;_;${pathNextComp[1]}.proxy" >> f2_exposiciones2comp.csv
            countImpl=$(( $countImpl + 1 ))
        else
            #echo "business ${pathNextComp[1]} $proxyExp"
            echo "${pathNextComp[1]}.biz" >> tmp_BizImplementaciones.txt
            echo "$mdwDominio;$proxyExp;$uriExp;_;_;${pathNextComp[1]}.biz" >> f2_exposiciones2comp.csv
            countOtros=$(( $countOtros + 1 ))
        fi

    done < $fileExp

    echo " $count Registros EXP Procesados"
    echo "  - $countComp a COMP"
    echo "  - $countImpl a IMPL"
    echo "  - $countOtros a Business"
    echo ""
    echo ""
    wc -l $fileExp
    wc -l tmp_refereciasDeEXP.txt
    wc -l f2_exposiciones2comp.csv 

}


#EXP 2 COMP e IMPL

#Paso 1 se inicia proceso para buscar en archivos origen 
    echo "procesando proxy EXP to COMP ...."
    fnBuscarPorPatronesConocidos "tmp_refereciasDeEXP.txt" "*EXP*.proxy"
    echo ""
    fnLimpiarValores "tmp_refereciasDeEXP.txt"
#Paso 2 se inicia proceso Buscar referencias y generar archivo csv que contine referencias de EXP a COMP/IMPL
    fnBuscarRegistrarReferencias


#COMP 2 IMPL
echo ""
#read -p "Presiona cualquier tecla para continuar con Mapeo de COMP a IMPL "

#Paso 3 se inicia proceso para buscar en archivos origen 
    echo ""
    echo "procesando proxy COMP to IMPL ...."
    fnBuscarPorPatronesConocidos "tmp_refereciasDeCOMP.txt" "*Comp.proxy"
    echo ""
    fnLimpiarValores "tmp_refereciasDeCOMP.txt"


# mover a-->    fnBuscarRegistrarReferenciasIMPL
#Paso 4 busqueda de referencias



count=0
countSinComp=0
countExpCompExpImpl=0
countExpComBizImpl=0
countSinMatch=0

f3_exposiciones2comp2impl=f3_exposiciones2comp2impl.csv

rm $f3_exposiciones2comp2impl 

while IFS=";" read -r mdwDominio proxyExp uriExp proxyComp proxyImpl bizImpl
do
    numOcur=0
    count=$(( $count +1 ))

 #   echo "$count Buscando: $proxyComp"

    if [[ $proxyComp == "_" ]]; then
        countSinComp=$(( $countSinComp +1 ))
        echo "$mdwDominio;$proxyExp;$uriExp;$proxyComp;$proxyImpl;$bizImpl" >> $f3_exposiciones2comp2impl
        continue
    fi

    numOcur="$(grep -i $proxyComp tmp_refereciasDeCOMP.txt | wc -l)"
    
  #  echo "$numOcur veces encontrado"

    if [[ $((numOcur)) > 0 ]]; then

        grep -i $proxyComp tmp_refereciasDeCOMP.txt > tmp_referencia.txt

        while IFS=";" read -r tmpProxyComp tmpProxyBizImpl
        do
            if [[ $tmpProxyBizImpl == *"BusinessService"* ]]; then
                #encontramos Business de IMPL
                countExpComBizImpl=$(( $countExpComBizImpl + 1 ))
                echo "$mdwDominio;$proxyExp;$uriExp;$proxyComp;_;$tmpProxyBizImpl.biz" >> $f3_exposiciones2comp2impl 
            else 
                #encontramos proxy de IMPL
                countExpCompExpImpl=$(( $countExpCompExpImpl + 1 ))
                echo "$mdwDominio;$proxyExp;$uriExp;$proxyComp;$tmpProxyBizImpl.proxy;$bizImpl" >> $f3_exposiciones2comp2impl 
            fi
        done < tmp_referencia.txt
    else
        countSinMatch=$(( $countSinMatch + 1 ))
        echo "$mdwDominio;$proxyExp;$uriExp;$proxyComp;$proxyImpl;$bizImpl" >> $f3_exposiciones2comp2impl 
    fi

done < f2_exposiciones2comp.csv

    echo ""
    echo ""
    echo " $count Registros EXP Procesados"
    echo "  - $countExpCompExpImpl Exp_COMP a Exp_IMPL"
    echo "  - $countExpComBizImpl Exp_COMP a Biz_IMPL"
    echo "  - $countSinComp sin COMP"
    echo "  - $countSinMatch  WTF!! "

 wc -l $f3_exposiciones2comp2impl 


echo "*************** ANALISIS CAPA COMP FINALIZADO *******************"
echo "*****************************************************************"
echo ""
echo ""
#read -p "Presiona cualquier tecla para continuar con Mapeo de IMPL "




#Paso 5 se inicia proceso para buscar en archivos origen 
echo ""
echo "procesando proxy IMPL ...."
fnBuscarPorPatronesConocidos "tmp_refereciasDeIMPL.txt" "*mpl.proxy"
echo ""
fnLimpiarValores "tmp_refereciasDeIMPL.txt"

count=0
countSinPxImpl=0
countSinMatch=0
countConPxImpl=0
rm f4_final.csv
echo "Dominio;Exposicion;URI;Composicion;Implementacion;Business" >> f4_final.csv
while IFS=";" read -r mdwDominio proxyExp uriExp proxyComp proxyImpl bizImpl
do
    numOcur=0
    count=$(( $count +1 ))

 #   echo "$count Buscando: $proxyImpl"

    if [[ $proxyImpl == "_" ]]; then
        countSinPxImpl=$(( $countSinPxImpl +1 ))
        echo "$mdwDominio;$proxyExp;$uriExp;$proxyComp;$proxyImpl;$bizImpl" >> f4_final.csv
        continue
    else

        rm tmp_referencia.txt
        grep -i $proxyImpl tmp_refereciasDeIMPL.txt > tmp_referencia.txt
        
        while IFS=";" read -r tmpProxyImpl tmpBizImpl
        do
            echo "$mdwDominio;$proxyExp;$uriExp;$proxyComp;$tmpProxyImpl;$tmpBizImpl.biz" >> f4_final.csv
            countConPxImpl=$(( $countConPxImpl +1 ))
        done < tmp_referencia.txt
    fi


done < $f3_exposiciones2comp2impl 

    echo ""
    
    echo "  - $count Registros IMPL Procesados"
    echo "  - $countConPxImpl con EXP IMPL"
    echo "  - $countSinPxImpl sin EXP IMPL"
    echo "  - $countSinMatch  WTF!! "

 wc -l f4_final.csv


 #Paso 5 info de se inicia proceso para buscar en archivos origen 
cp f4_final.csv f5_final.csv
#echo "Dominio;Exposicion;URI;Composicion;Implementacion;Business;urlImpl" > f5_final.csv
while IFS=";" read -r mdwDominio bizImpl urlImpl
do
    #echo "$bizImpl"
    gsed  -i "s|${bizImpl}|${bizImpl};${urlImpl}|" f5_final.csv
done < f0_endpoints.csv

#clean tmp files 
rm tmp_*.txt
 wc -l f5_final.csv
