#version 2.0
fn_crearEstructura(){
	echo "Iniciando crearEstructura con directorio raiz: " $1


	for ((i=0; i < ${#subcarpetas[@]}; i++))
    do
        rutaCompleta=$1${subcarpetas[$i]}
        echo "creando" ${subcarpetas[$i] "en "$1}
        if [ -d $rutaCompleta ]; then
            echo $rutaCompleta "Resultado: ya existia"
        else
            mkdir $rutaCompleta 
            echo $rutaCompleta "Resultado:  no existia y lo cree"
        fi
    done 
}

fn_valida_directorio(){
	echo "Recibi como parametro: " $1

	vRuta=$1

	if [ -d $vRuta ]; then
		echo "El directorio raiz existe y por lo tanto no fue creado"	
        echo "procedemos a validar estructuras internas..."	
        fn_crearEstructura $vRuta
	else 
		mkdir -p $vRuta
        echo "El directorio no existia y ya lo cree"
        echo "procedemos a crear estructuras internas..."	
        fn_crearEstructura $vRuta
	fi
}

fn_cargarConfigIni(){
PATH2=$(pwd)
source $PATH2/config.ini
#echo ${siglaProyecto[@]}
#echo ${opcionesArchivo[@]}
#echo ${subcarpetas[@]}
}
clear
echo "Empezando Programa Prueba"
echo "1. Carga de parametros archivo config.ini"
fn_cargarConfigIni
echo "2. Validar Directorio Starting..."
directorioRaiz="/mnt/hgfs/apolo_11/carlos/"
fn_valida_directorio $directorioRaiz