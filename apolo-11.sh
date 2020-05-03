#!/bin/bash


# Funcion para crear archivos
fn_crear_archivo(){

	echo "Ruta del archivo : "$1
	echo "Contenido del archivo : "$2
	echo "Nombre del archivo : "$3	
	echo "Numero de parametros enviados a la funcion : "$#

	vRutaArchivo=$1
	vContenidoArchivo=$2
	vNombreArchivo=$3

	fn_valida_directorio  $vRutaArchivo

	echo "Se crea el archivo : "$vNombreArchivo" en la ruta "$vRutaArchivo/$vNombreArchivo
	echo $vContenidoArchivo > $vRutaArchivo/$vNombreArchivo
	
}

fn_valida_directorio(){

	echo "Ruta enviada a la funcion fn_valida_directorio : "$1

	vRuta=$1

	if [ -d $vRuta ]; then
		echo "El directorio ya existe"	
	else 
		echo "Se creara la ruta [OK]"
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


ruta=$(pwd)"/cloudera/takeoff-mission"

contadorArchivos=1

fn_valida_directorio $ruta

#echo $ruta/{${subcarpetas[0]},${subcarpetas[1]},${subcarpetas[2]},${subcarpetas[3]}}

#mkdir $ruta/{${vSubcarpetas[0]},${subcarpetas[1]},${subcarpetas[2]},${subcarpetas[3]}}

#mkdir -p $ruta

nombreGrupo="nasa"

sudo groupadd $nombreGrupo 2>/dev/null


# generador de numeros aleatorios entre 0 - 4 echo $(($RANDOM%4))

while [ $contadorArchivos -le 100 ]; do

	let indexSiglaProyecto=$(($RANDOM%${#siglaProyecto[@]}))
	echo "Numero de proyectos : " ${#siglaProyecto[@]}

	let indexOpcionesArchivo=$(($RANDOM%${#opcionesArchivo[@]}))
	echo "Numero de resultados que puede contener el LOG : "${#opcionesArchivo[@]}

	nombreArchivo="APL"${siglaProyecto[$indexSiglaProyecto]}"0000"$contadorArchivos".log"
	sudo adduser ${siglaProyecto[$indexSiglaProyecto]}	2>/dev/null

	fecha=$(date +%d-%m-%y)
	ruta=$ruta/${subcarpetas[0]}/$fecha

	fn_crear_archivo $ruta ${opcionesArchivo[$indexOpcionesArchivo]} $nombreArchivo
	sudo chown :$nombreGrupo $ruta/$nombreArchivo
	sudo chown ${siglaProyecto[$indexSiglaProyecto]} $ruta/$nombreArchivo
	let contadorArchivos=$contadorArchivos+1
	ruta=$(pwd)"/cloudera/takeoff-mission"


done



