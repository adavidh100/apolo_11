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
    fecha=$(date +%d%m%y)
    hora=`date +"%H:%M"`

    texto="Se crea el archivo de log : "$vNombreArchivo" a las  "$hora 
    file="log"$fecha".log"
    archivoGlobalLog=$vRutaArchivo/$file
    echo "voy a escribir" $texto "en " $archivoGlobalLog

     
    sudo touch $archivoGlobalLog
    sudo chmod 777 $archivoGlobalLog
    sudo echo $texto >> $archivoGlobalLog
	
    sudo touch $vRutaArchivo/$vNombreArchivo
    sudo chown :$nombreGrupo $vRutaArchivo/$vNsombreArchivo
	sudo chown ${siglaProyecto[$indexSiglaProyecto]} $vRutaArchivo/$vNombreArchivo
    sudo chmod 777 $vRutaArchivo/$vNombreArchivo
	sudo echo $vContenidoArchivo > $vRutaArchivo/$vNombreArchivo
	
}
#Funcion para crear el archivo de configuracion completo en caso de que este no exista.
fn_crear_configIni(){
echo "#Directorio principal
directorioRaiz=\"/cloudera/takeoff-mission\"

#Variable que contiene las siglas del proyecto del programa apolo-11
#
# Orbit(ORB)             : modernizar toda la flota de satélites para potenciarlos y mejorar su alcance de cobertura y comunicaciones y 
# Colony(CNL)           : proyecto para crear una colonia lunar 
# Mars(MRS)             : proyecto para llevar personas de turismo a marte 
# Desconocido(DES) : Control para dispositivo no controlado o infiltrado 
siglaProyecto=(\"ORB\" \"CNL\" \"MRL\" \"DES\")

# Diferentes opciones que puede contener el log generado
opcionesArchivo=(\"unknow\" \"excelent\" \"good\" \"warning\" \"kill\")

# Subcarpetas donde deben quedar almacenados los log generados por los diferentes dispositivos
subcarpetas=(\"devices\" \"logsapolo11\" \"config\" \"stats\")

#Cantidad de archivos que genera el programa apolo-11 por ejecucion
numeroArchivosGenera=2

#Cantidad maxima de archivos que genera el programa apolo-11 por dia
maximoArchivosGenera=1000" >>$vArchivo

}
#funcion que inspecciona todas las variables sobre un archivo config.ini ya existente.
fn_inspeccionarConfigIni(){

param=$1
echo "Validando" "${!param}"
if [[ -z "${!param}" ]]; 
then
    echo "La variable " $param " no existe, procedere a escribirla en el archivo"    
    
    case $1 in
     directorioRaiz)
    echo "
    
#Directorio principal
directorioRaiz=\"/cloudera/takeoff-mission\"">>$vArchivo
     ;;

     siglaProyecto)
    echo "    
#Variable que contiene las siglas del proyecto del programa apolo-11
#
# Orbit(ORB)             : modernizar toda la flota de satélites para potenciarlos y mejorar su alcance de cobertura y comunicaciones y 
# Colony(CNL)           : proyecto para crear una colonia lunar 
# Mars(MRS)             : proyecto para llevar personas de turismo a marte 
# Desconocido(DES) : Control para dispositivo no controlado o infiltrado 
siglaProyecto=(\"ORB\" \"CNL\" \"MRL\" \"DES\")">>$vArchivo
     ;;

     opcionesArchivo)
    echo "
    
# Diferentes opciones que puede contener el log generado
opcionesArchivo=(\"unknow\" \"excelent\" \"good\" \"warning\" \"kill\")">>$vArchivo
     ;;
     
    subcarpetas)
    echo "
    
# Subcarpetas donde deben quedar almacenados los log generados por los diferentes dispositivos
subcarpetas=(\"devices\" \"logsapolo11\" \"config\" \"stats\")">>$vArchivo
     ;;

    numeroArchivosGenera)
    echo "
    
#Cantidad de archivos que genera el programa apolo-11 por ejecucion
numeroArchivosGenera=2">>$vArchivo
     ;;

     maximoArchivosGenera)
    echo "
    
#Cantidad maxima de archivos que genera el programa apolo-11 por dia
maximoArchivosGenera=1000">>$vArchivo
     ;;
     
    esac
else    
echo "La variable " $1 " existe, todo tranqui" 
fi
} 
#Funcion que valida si el archivo existe y si existe, invoca inspeccionar con las variables requeridas por el sistema.
fn_valida_configIni(){

	echo "Validando si existe" $1

	vArchivo=$1

	if [ -f $vArchivo ]; then
        source $vArchivo
		echo "El archivo config.ini existe"
        fn_inspeccionarConfigIni directorioRaiz
        fn_inspeccionarConfigIni siglaProyecto
        fn_inspeccionarConfigIni opcionesArchivo
        fn_inspeccionarConfigIni subcarpetas
        fn_inspeccionarConfigIni numeroArchivosGenera	
        fn_inspeccionarConfigIni maximoArchivosGenera  
	else 
		fn_crear_configIni $vArchivo
        source $vArchivo
        echo "Se creara el archivo $vArchivo [OK]"
        
	fi
}
#Funcion que revisa si existe un directorio y encaso de no existencia, lo crea.
fn_valida_directorio(){

	echo "Ruta enviada a fn_valida_directorio : "$1

	vRuta=$1

	if [ -d $vRuta ]; then
		echo "El directorio ya existe"	
	else 
		sudo mkdir -p $vRuta
        echo "Se creara la ruta $vRuta [OK]"
	fi
}
#Funcion que imprime Menu
fn_menu(){
    
    echo "**************************************************************************"
    echo "*BIENVENIDOS A LA ADMINISTRACION NACIONAL DE LA AERONAUTICA Y DEL ESPACIO*"
    echo "*                                (NASA)                                  *"
    echo "**************************************************************************"
    echo "*PROGRAMA:        Apolo-11 (En memoria del primer viaje a la luna)       *"
    echo "*PROYECTOS:       Orbit(ORB), Colony(CNL), Mars(MRS)                     *"
    echo "*IMPLEMENTACION:  Carlos Alberto Barrera Barraera                        *"
    echo "*                 Daniel Esteban Lopez                                   *"
    echo "*                 Andres David Herrera Parrado                           *"
    echo "**************************************************************************"
}

#Inicializacion de programa
fn_inicializar(){

    PATH2=$(pwd)
    echo "el path actual es "$PATH2
#valida si existe config.ini y si no existe lo crea
    fn_valida_configIni $PATH2/config.ini
    echo "validacion de config ini terminada"
    #directorioAValidar=$(echo ~ 2>&1)$directorioRaiz
   #valida que el directorio Raiz exista 
    directorioAValidar=$directorioRaiz
    echo "el directorio a validar es" $directorioAValidar

# Se valida el directorio Ppal y las subcarpetas
	fn_valida_directorio $directorioAValidar
	for i in "${subcarpetas[@]}"
	do
    	subCarpetasAValidar=$directorioAValidar/$i
		fn_valida_directorio $subCarpetasAValidar
	done
# Se valida si existe la carpeta con la fecha de ejecucion de apolo-11
    fecha=$(date +%d%m%y)
	ruta=$directorioRaiz/${subcarpetas[0]}/$fecha  
    fn_valida_directorio $ruta

# Se valida si existe la carpeta de logs con la fecha de ejecucion de apolo-11
    
    rutaOrigen=$directorioRaiz/${subcarpetas[0]}/$fecha/
    rutaDestino=$directorioRaiz/logsapolo11/bkmissions/$fecha/
    fn_valida_directorio $rutaOrigen
    fn_valida_directorio $rutaDestino
    echo "Ruta Origen" $rutaOrigen
    echo "RutaDestino" $rutaDestino 
   
    cd $rutaDestino
    let contadorBkMissions=$(ls | wc -l)

    cd $ruta
    let contadorTmp=$(ls | wc -l) +1

    let contador=$contadorBkMissions+contadorTmp

    
    let finalCiclo=($contador+$numeroArchivosGenera)-1
    cd $PATH2

}
clear
#Ejecutamos el procedimiento inicializar para garantizar el arbol del proyecto

fn_inicializar

#Mostramos el menu y capturamos el valor deseado
fn_menu

    echo
    echo "Se inicia operacion apolo-11.............."
    echo
    ruta=$directorioRaiz
    contadorArchivos=$contador
    nombreGrupo="nasa"
    sudo groupadd $nombreGrupo 2>/dev/null
# generador de numeros aleatorios entre 0 - 4 echo $(($RANDOM%4))
        if [ $contadorArchivos -le $maximoArchivosGenera ]; then
            while [ $contadorArchivos -le $finalCiclo ]; do

	            let indexSiglaProyecto=$(($RANDOM%${#siglaProyecto[@]}))
	            echo "Numero de proyectos : " ${#siglaProyecto[@]}
	            let indexOpcionesArchivo=$(($RANDOM%${#opcionesArchivo[@]}))
	            echo "Numero de resultados que puede contener el LOG : "${#opcionesArchivo[@]}
	            nombreArchivo="APL"${siglaProyecto[$indexSiglaProyecto]}"0000"$contadorArchivos".log"
	            sudo adduser ${siglaProyecto[$indexSiglaProyecto]}	2>/dev/null
        	    ruta=$directorioRaiz/${subcarpetas[0]}/$fecha
	            fn_crear_archivo $ruta ${opcionesArchivo[$indexOpcionesArchivo]} $nombreArchivo
	            let contadorArchivos=$contadorArchivos+1
	            ruta=$directorioRaiz
            done
        else
            echo ""
            echo "Numero maximo de archivos generados para $fecha"
            echo ""
        fi
        echo
        echo "Se finaliza operacion apolo-11.............."
        echo
    
    echo "Moviendo logs..."

    # Se valida si existe la carpeta con la fecha de ejecucion de apolo-11
    fecha=$(date +%d%m%y)
	rutaOrigen=$directorioRaiz/${subcarpetas[0]}/$fecha/
    rutaDestino=$directorioRaiz/logsapolo11/bkmissions/$fecha/
    fn_valida_directorio $rutaOrigen
    fn_valida_directorio $rutaDestino
    echo "Ruta Origen" $rutaOrigen
    echo "RutaDestino" $rutaDestino 
   
    
    cd $rutaOrigen
    sudo mv APL*.log $rutaDestino 
    cd $directorioRaiz
        
    echo "Se movieron los archivos satisfactoriamente!"
    
    
    echo ""
    echo "Finalizando sesion en mision apolo-11 !!!"
    echo
