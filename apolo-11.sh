#!/bin/bash

#Edicion Propuesta por Carlos
#Edicion 2 desde el pc
# Funcion para crear archivos
fn_crear_archivo(){

	echo $1
	echo $2
	echo $3
	echo $4
	echo $5
	echo $#

	vSiglaProyecto=$1
	vRutaArchivo=$2
	vContenidoArchivo=$3
	vFecha=$(date +%d-%m-%y)
	vNumeroArchivo=$4
	vSubcarpetas=$5
	vNombreArchivo="APL["$vSiglaProyecto"]0000"$vNumeroArchivo".log"
	echo $vRutaArchivo/$vFecha/$vNombreArchivo
	
}

fn_valida_directorio(){
	echo $1

	vRuta=$1

	if [ -d $vRuta ]; then
		echo "El directorio existe"	
	else 
		mkdir -p $vRuta
	fi

}





#Variable que contiene las siglas del proyecto del programa apolo-11
#
# Orbit(ORB)             : modernizar toda la flota de satélites para potenciarlos y mejorar su alcance de cobertura y comunicaciones y 
# Colony(CNL)           : proyecto para crear una colonia lunar 
# Mars(MRS)             : proyecto para llevar personas de turismo a marte 
# Desconocido(DES) : Control para dispositivo no controlado o infiltrado 

siglaProyecto=("ORB" "CNL" "MRL" "DES")


# Diferentes opciones que puede contener el log generado

opcionesArchivo=("unknow" "excelent" "good" "warning" "kill")


# Subcarpetas donde deben quedar almacenados los log generados por los diferentes dispositivos

subcarpetas=("devices" "logsapolo11" "config" "stats")


ruta="$pwd/cloudera/takeoff-mission"
echo $ruta
fn_valida_directorio $ruta

echo $ruta/{${vSubcarpetas[0]},${subcarpetas[1]},${subcarpetas[2]},${subcarpetas[3]}}

#mkdir $ruta/{${vSubcarpetas[0]},${subcarpetas[1]},${subcarpetas[2]},${subcarpetas[3]}}

#mkdir -p $ruta


# generador de numeros aleatorios entre 0 - 4 echo $(($RANDOM%4))

let indexSiglaProyecto="echo $(($RANDOM%4))"

let indexOpcionesArchivo="echo $(($RANDOM%5))"

#fn_crear_archivo ${siglaProyecto[1]} $ruta ${opcionesArchivo[2]} 1 ${vSubcarpetas[0]}
fn_crear_archivo ${siglaProyecto[$indexSiglaProyecto]} $ruta ${opcionesArchivo[$indexOpcionesArchivo]} 1 ${vSubcarpetas[0]}


