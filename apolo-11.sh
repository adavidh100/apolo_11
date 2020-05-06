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

	echo "Se crea el archivo : "$vNombreArchivo" en la ruta "$vRutaArchivo/$vNombreArchivo
    sudo touch $vRutaArchivo/$vNombreArchivo
    sudo chown :$nombreGrupo $vRutaArchivo/$vNombreArchivo
	sudo chown ${siglaProyecto[$indexSiglaProyecto]} $vRutaArchivo/$vNombreArchivo
    sudo chmod 777 $vRutaArchivo/$vNombreArchivo
	sudo echo $vContenidoArchivo > $vRutaArchivo/$vNombreArchivo
	
}

fn_valida_directorio(){

	echo "Ruta enviada a la funcion fn_valida_directorio : "$1

	vRuta=$1

	if [ -d $vRuta ]; then
		echo "El directorio ya existe"	
	else 
		sudo mkdir -p $vRuta
        echo "Se creara la ruta $vRuta [OK]"
	fi
}

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
    echo -e "Digite una opcion : \n\n 1. Ejecutar apolo-11 \n 2. Salir"
    echo
    read -p "Digite opcion deseada: " opcion
}

fn_inicializar(){

    PATH2=$(pwd)
    echo $PATH2
    source $PATH2/config.ini
	directorioAValidar=$(echo ~ 2>&1)$directorioRaiz
    echo $directorioAValidar

# Se valida el directorio Ppal y las subcarpetas
	fn_valida_directorio $directorioAValidar
	for i in "${subcarpetas[@]}"
	do
    	subCarpetasAValidar=$directorioAValidar/$i
		fn_valida_directorio $subCarpetasAValidar
	done
# Se valida si existe la carpeta con la fecha de ejecucion de apolo-11
    fecha=$(date +%d-%m-%y)
	ruta=$directorioRaiz/${subcarpetas[0]}/$fecha
    fn_valida_directorio $ruta
    cd $ruta
    let contador=$(ls | wc -l)+1
    let finalCiclo=$(ls | wc -l)+$numeroArchivosGenera
    cd $PATH2

}
#Ejecutamos el procedimiento inicializar para garantizar el arbol del proyecto
fn_inicializar

#Mostramos el menu y capturamos el valor deseado
fn_menu

while [ $opcion -ne 2 ]; do
    case $opcion in 
    1) 
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
    ;;
    *)
        echo
        echo "Opcion invalida!!!!"    
    esac
    echo
    read -p "Desea Continuar S/N: " continuar

    if [ $continuar == "S" ] | [ $continuar == "s" ]; then
        fn_inicializar
        fn_menu
    else
        opcion=2
    fi
done

if [ $opcion -eq 2 ]; then
        clear
        echo ""
        echo "Finalizando sesion en mision apolo-11 !!!"
        echo
fi
