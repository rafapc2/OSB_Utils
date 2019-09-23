#!/bin/bash
# version: 0.1.0
# Objetivo: Permite orquestar los script de analisis OSB


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


script_files=( "extractorInfoEXP12c.sh" "extractorInfoSJoin12c.sh"   "extractorInfoBusiness12c.sh"  )

echo "Iniciando Lectura del archivo:"
PATH=.:$PATH
export PATH
x
for script in "${script_files[@]}"
do
    start_time="$(date -u +%s)"

	printf "ejecutando $script"
    (exec "$script") > log.txt

    end_time="$(date -u +%s)"

    elapsed="$(($end_time-$start_time))"
    echo " : $elapsed seg."

done