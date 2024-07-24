#!/bin/bash

# Función para verificar la impresora y seleccionar una si no existe
function verificaImpresora {
    # Eliminar el archivo impresora.txt si existe
    if [ -f impresora.txt ]; then
        echo "Eliminando el archivo impresora.txt..."
        rm impresora.txt
    fi

    if [ ! -f bd-pemex-61.json ]; then
        echo "El archivo bd-pemex-61.json no existe."
        curl -H 'X-DataSource-Auth: true' 'https://docs.google.com/spreadsheets/d/1oSgnO8IrOe630KjcT4Vz3jFXJHnUOL8Wm9RpUShsIyY/gviz/tq?tqx=out:json&tq&gid=0' >>bd-pemex-61.json  
        sed -i '1d' bd-pemex-61.json

        # Realiza las acciones necesarias cuando el archivo no existe
    fi

    # Si no existe el archivo impresora.txt, solicitar la selección de la impresora
    if [ ! -f impresora.txt ]; then
        # Obtener la lista de dispositivos en /dev/usb/
        directorios=$(ls /dev/usb/)
        opciones=""
        for dir in $directorios; do
            opciones="$opciones $dir $dir off"
        done

        # Usar dialog para seleccionar la impresora
        respuesta=$(dialog --title "Selecciona la impresora Zebra" \
            --stdout \
            --radiolist "Lista de impresoras:" 0 0 0 $opciones)

        # Guardar la selección en el archivo impresora.txt
        echo "$respuesta" >impresora.txt

        # Verificar si la selección es válida
        if [ -z "$respuesta" ]; then
            dialog --msgbox "No se seleccionó ninguna impresora. Salida." 10 40
            exit 1
        fi
    fi
    selectorOs
}

# Función para obtener números de serie únicos basada en la fase seleccionada
function obtenerOsUnicas {
    local faseSelecionada=$1
    jq -r --arg fase "$faseSelecionada" '.table.rows[] | select(.c[4].v == ($fase | tonumber)) | "\(.c[2].v)"' bd-pemex-61.json | sort | uniq
}

# Función para obtener los IDS unicos
function obtenerIdsUnicas {
    local oSimpresion=$1
    jq -r --arg os "$oSimpresion" '.table.rows[] | select(.c[2].v == $os) | "\(.c[1].v),\(.c[16].v),\(.c[30].v),\(.c[17].v),\(.c[31].v),\(.c[18].v),\(.c[32].v),\(.c[19].v),\(.c[33].v),\(.c[20].v),\(.c[34].v),\(.c[21].v),\(.c[35].v),\(.c[22].v),\(.c[36].v),\(.c[23].v),\(.c[37].v),\(.c[24].v),\(.c[38].v),\(.c[25].v),\(.c[39].v),\(.c[26].v),\(.c[40].v),\(.c[27].v),\(.c[41].v),\(.c[28].v),\(.c[42].v),\(.c[43].v),\(.c[44].v),"' bd-pemex-61.json
}

function fun_p1_pc_6213_opg {
    local oSimpresion=$1
    jq -r --arg os "$oSimpresion" '.table.rows[] | select(.c[2].v == $os) | "\(.c[1].v),\(.c[16].v),\(.c[30].v)"' bd-pemex-61.json |
        awk -F',' '
    {
        modelo=$1
        serie=$2
        tarima=$3
        if (serie != "null") {
            print modelo "," serie "," tarima,",pc_6213_opg",",1"
        }
    }'
}

function func_p1_mnl_2610_opg {
    local oSimpresion=$1
    jq -r --arg os "$oSimpresion" '.table.rows[] | select(.c[2].v == $os) | "\(.c[1].v),\(.c[17].v),\(.c[31].v)"' bd-pemex-61.json |
        awk -F',' '
    {
        modelo=$1
        serie=$2
        tarima=$3
        if (serie != "null") {
            print modelo "," serie "," tarima,",mnl_2610_opg",",6"
        }
    }'
}

function func_p1_pc_6257_opg {
    local oSimpresion=$1
    jq -r --arg os "$oSimpresion" '.table.rows[] | select(.c[2].v == $os) | "\(.c[1].v),\(.c[18].v),\(.c[32].v)"' bd-pemex-61.json |
        awk -F',' '
    {
        modelo=$1
        serie=$2
        tarima=$3
        if (serie != "null") {
            print modelo "," serie "," tarima,",pc_6257_opg",",1"
        }
    }'
}

function func_p2_not_9582_opg {
    local oSimpresion=$1
    jq -r --arg os "$oSimpresion" '.table.rows[] | select(.c[2].v == $os) | "\(.c[1].v),\(.c[19].v),\(.c[33].v)"' bd-pemex-61.json |
        awk -F',' '
    {
        modelo=$1
        serie=$2
        tarima=$3
        if (serie != "null") {
            print modelo "," serie "," tarima,",not_9582_opg",",2"
        }
    }'
}

function func_p2_not_9654_opg {
    local oSimpresion=$1
    jq -r --arg os "$oSimpresion" '.table.rows[] | select(.c[2].v == $os) | "\(.c[1].v),\(.c[20].v),\(.c[34].v)"' bd-pemex-61.json |
        awk -F',' '
    {
        modelo=$1
        serie=$2
        tarima=$3
        if (serie != "null") {
            print modelo "," serie "," tarima,",not_9654_opg",",2"
        }
    }'
}

function func_p5_pc_6186_opg {
    local oSimpresion=$1
    jq -r --arg os "$oSimpresion" '.table.rows[] | select(.c[2].v == $os) | "\(.c[1].v),\(.c[21].v),\(.c[35].v)"' bd-pemex-61.json |
        awk -F',' '
    {
        modelo=$1
        serie=$2
        tarima=$3
        if (serie != "null") {
            print modelo "," serie "," tarima,",pc_6186_opg",",3"
        }
    }'
}

function func_p5_mnl_2254_opg {
    local oSimpresion=$1
    jq -r --arg os "$oSimpresion" '.table.rows[] | select(.c[2].v == $os) | "\(.c[1].v),\(.c[22].v),\(.c[36].v)"' bd-pemex-61.json |
        awk -F',' '
    {
        modelo=$1
        serie=$2
        tarima=$3
        if (serie != "null") {
            print modelo "," serie "," tarima,",mnl_2254_opg",",7"
        }
    }'
}

function func_p6_not_9548_opg {
    local oSimpresion=$1
    jq -r --arg os "$oSimpresion" '.table.rows[] | select(.c[2].v == $os) | "\(.c[1].v),\(.c[23].v),\(.c[37].v)"' bd-pemex-61.json |
        awk -F',' '
    {
        modelo=$1
        serie=$2
        tarima=$3
        if (serie != "null") {
            print modelo "," serie "," tarima,",not_9548_opg",",4"
        }
    }'
}

function func_p10_ac_9132_opg {
    local oSimpresion=$1
    jq -r --arg os "$oSimpresion" '.table.rows[] | select(.c[2].v == $os) | "\(.c[1].v),\(.c[24].v),\(.c[38].v)"' bd-pemex-61.json |
        awk -F',' '
    {
        modelo=$1
        serie=$2
        tarima=$3
        if (serie != "null") {
            print modelo "," serie "," tarima,",ac_9132_opg",",5"
        }
    }'
}

function func_p10_kb_880_opg {
    local oSimpresion=$1
    jq -r --arg os "$oSimpresion" '.table.rows[] | select(.c[2].v == $os) | "\(.c[1].v),\(.c[25].v),\(.c[39].v)"' bd-pemex-61.json |
        awk -F',' '
    {
        modelo=$1
        serie=$2
        tarima=$3
        if (serie != "null") {
            print modelo "," serie "," tarima,",kb_880_opg",",0"
        }
    }'
}

function func_p10_mnl_2254_opg {
    local oSimpresion=$1
    jq -r --arg os "$oSimpresion" '.table.rows[] | select(.c[2].v == $os) | "\(.c[1].v),\(.c[26].v),\(.c[40].v)"' bd-pemex-61.json |
        awk -F',' '
    {
        modelo=$1
        serie=$2
        tarima=$3
        if (serie != "null") {
            print modelo "," serie "," tarima,",mnl_2254_opg",",8"
        }
    }'
}

function func_p13_mnl_2254_opg {
    local oSimpresion=$1
    jq -r --arg os "$oSimpresion" '.table.rows[] | select(.c[2].v == $os) | "\(.c[1].v),\(.c[27].v),\(.c[41].v)"' bd-pemex-61.json |
        awk -F',' '
    {
        modelo=$1
        serie=$2
        tarima=$3
        if (serie != "null") {
            print modelo "," serie "," tarima,",mnl_2254_opg",",9"
        }
    }'
}

function func_p14_mnl_2254_opg {
    local oSimpresion=$1
    jq -r --arg os "$oSimpresion" '.table.rows[] | select(.c[2].v == $os) | "\(.c[1].v),\(.c[28].v),\(.c[42].v)"' bd-pemex-61.json |
        awk -F',' '
    {
        modelo=$1
        serie=$2
        tarima=$3
        if (serie != "null") {
            print modelo "," serie "," tarima,",mnl_2254_opg",",10"
        }
    }'
}

function func_p5_mnl_2254_opg_2 {
    local oSimpresion=$1
    jq -r --arg os "$oSimpresion" '.table.rows[] | select(.c[2].v == $os) | "\(.c[1].v),\(.c[43].v),\(.c[44].v)"' bd-pemex-61.json |
        awk -F',' '
    {
        modelo=$1
        serie=$2
        tarima=$3
        if (serie != "null") {
            print modelo "," serie "," tarima,",mnl_2254_opg_2",",7"
        }
    }'
}

#seccion de modelos de zpl

# Función para generar el ZPL para monitor
function zplMonitor {

    local NumeroContrato=$1
    local TipoEquipo=$2
    local MarcaModelo=$3
    local Serie=$4
    local Tecnologia=$5
    local Resolucion=$6
    local Tamanodepantalla=$7
    local Energystar=$8
    local Tarima=${9}
    local ID=${10}

    local zpl=$(
        cat <<EOF
^XA
^LH5,5
^PW800   // Ancho de impresión de 296 puntos
^LL324    // Longitud de la etiqueta de 177 puntos
^FO250,170
^A0,20,20
^FD Contrato: $NumeroContrato ^FS
^FO280,8
^A0,24,15
^FD $TipoEquipo ^FS
^FO5,50
^A0,20,20
^FD Marca y modelo: $MarcaModelo ^FS
^FO5,10
^A0,30,30
^FD Serie: $Serie ^FS
^FO5,70
^A0,20,20
^FD Tecnologia: $Tecnologia ^FS
^FO5,90
^A0,20,20
^FD Resolucion: $Resolucion ^FS
^FO5,110
^A0,20,20
^FD Tamano de pantalla: $Tamanodepantalla ^FS
^FO5,130
^A0,20,20
^FD Energy Star: $Energystar ^FS
^FO550,25
^BQN,2,2
^FDQA,N° contrato:$NumeroContrato/Tipo de equipo:$TipoEquipo/Marca y modelo:$MarcaModelo/Serie:$Serie/Tecnologia:$Tecnologia/Resolucion:$Resolucion/Energy Star:$Energystar/^FS
^XZ
EOF
    )
    local zplControl=$(
        cat <<EOF
^XA
^LH5,5
^PW800   // Ancho de impresión de 296 puntos
^LL324    // Longitud de la etiqueta de 177 puntos
^FO10,100
^A0,50,50
^FD Tarima: $Tarima^FS
^FO5,10
^A0,50,50
^FD ID: $ID y Serie $Serie^FS
^XZ
EOF
    )

    # Llama a la función imprimirZPL con el contenido ZPL
    imprimirZPL "$zplControl" && imprimirZPL "$zpl"

}

# Función para generar el ZPL para DOCK
function zplDock {

    local NumeroContrato=$1
    local TipoEquipo=$2
    local MarcaModelo=$3
    local Serie=$4
    local Puertoa=$5
    local Puertob=$6
    local Puertoc=$7
    local Puertod=$8
    local Cargador=$9
    local Tarima=${10}
    local ID=${11}

    local zpl=$(
        cat <<EOF
^XA
^LH5,5
^PW800   // Ancho de impresión de 296 puntos
^LL324    // Longitud de la etiqueta de 177 puntos
^FO250,170
^A0,20,20
^FD Contrato: $NumeroContrato ^FS
^FO300,8
^A0,24,17
^FD $TipoEquipo ^FS
^FO5,50
^A0,20,20
^FD Marca y modelo: $MarcaModelo ^FS
^FO5,10
^A0,30,30
^FD Serie: $Serie ^FS
^FO5,70
^A0,20,20
^FD Puertos: $Puertoa ^FS
^FO5,90
^A0,20,20
^FD Puertos: $Puertob ^FS
^FO5,110
^A0,20,20
^FD Puertos: $Puertoc ^FS
^FO5,130
^A0,20,20
^FD Puertos: $Puertod ^FS
^FO5,150
^A0,20,20
^FD Cargador: $Cargador ^FS
^FO550,25
^BQN,2,2
^FDQA,N° contrato:$NumeroContrato/Tipo de equipo:$TipoEquipo/Marca y modelo:$MarcaModelo/Serie:$Serie/Puertos:$Puertoa-$Puertob-$Puertoc-$Puertod/Cargador:$Cargador/^FS
^XZ
EOF
    )
    local zplControl=$(
        cat <<EOF
^XA
^LH5,5
^PW800   // Ancho de impresión de 296 puntos
^LL324    // Longitud de la etiqueta de 177 puntos
^FO10,100
^A0,50,50
^FD Tarima: $Tarima^FS
^FO5,10
^A0,50,50
^FD ID: $ID y Serie $Serie^FS
^XZ
EOF
    )

    # Llama a la función imprimirZPL con el contenido ZPL
    imprimirZPL "$zplControl" && imprimirZPL "$zpl"

}

# Función para generar el ZPL para Computo
function zplComputo {
    local NumeroContrato=$1
    local TipoEquipo=$2
    local MarcaModelo=$3
    local Serie=$4
    local Memoria=$5
    local TamanoDiscoDuro=$6
    local TarjetaVideo=$7
    local TarjetaRed=$8
    local Pantalla=$9
    local Certificados=${10}
    local CPU=${11}
    local Tarima=${12}
    local ID=${13}

    local zpl=$(
        cat <<EOF
^XA
^LH5,5
^PW800   // Ancho de impresión de 296 puntos
^LL324    // Longitud de la etiqueta de 177 puntos
^FO250,170
^A0,20,20
^FD Contrato: $NumeroContrato ^FS
^FO350,8
^A0,24,20
^FD $TipoEquipo ^FS
^FO5,50
^A0,20,20
^FD Marca y modelo: $MarcaModelo ^FS
^FO5,10
^A0,30,30
^FD Serie: $Serie ^FS
^FO5,70
^A0,20,20
^FD Memoria: $Memoria / $CPU ^FS
^FO5,90
^A0,20,20
^FD Tam. Disco Duro: $TamanoDiscoDuro ^FS
^FO5,110
^A0,20,20
^FD T. de Video: $TarjetaVideo ^FS
^FO5,130
^A0,20,20
^FD T. de Red: $TarjetaRed ^FS
^FO5,150
^A0,20,20
^FD Pantalla: $Pantalla ^FS
^FO5,170
^A0,20,20
^FD Certificados: $Certificados ^FS
^FO525,25
^BQN,2,2
^FDQA,N° contrato:$NumeroContrato/Equipo:$TipoEquipo/Marca y modelo:$MarcaModelo/Serie:$Serie/Mem.:$Memoria/Disco Duro:$TamanoDiscoDuro/T. de Video:$TarjetaVideo/T. Red:$TarjetaRed/Pantalla:$Pantalla/Cert:$Certificados /:$CPU^FS
^XZ
EOF
    )

    local zplControl=$(
        cat <<EOF
^XA
^LH5,5
^PW800   // Ancho de impresión de 296 puntos
^LL324    // Longitud de la etiqueta de 177 puntos
^FO10,100
^A0,50,50
^FD Tarima: $Tarima^FS
^FO5,10
^A0,50,50
^FD ID: $ID y Serie $Serie^FS
^XZ
EOF
    )

    # Llama a la función imprimirZPL con el contenido ZPL
    imprimirZPL "$zplControl" && imprimirZPL "$zpl"

}

# Función principal para ejecutar el flujo
function selectorOs {
    fase=$(
        dialog --title "Selecciona la Ordenes a imprimir" \
            --stdout \
            --radiolist "Selecciona una opción:" 0 0 10 \
            1 "FASE 1" off \
            2 "FASE 2" off \
            3 "FASE 3" off \
            4 "FASE 4" off \
            5 "FASE 5" off \
            6 "FASE 6" off \
            7 "FASE 7" off \
            8 "FASE 8" off \
            9 "FASE 9" off \
            10 "FASE 10" off
    )

    if [ -z "$fase" ]; then
        dialog --msgbox "No se seleccionó ninguna fase. Salida." 10 40
        exit 1
    fi

    series_unicas=$(obtenerOsUnicas "$fase")

    # Generar la lista para el dialog
    opciones=""
    while read -r serie; do
        opciones+=" \"$serie\" \"$serie\" off"
    done <<<"$series_unicas"

    oSimpresion=$(
        eval dialog --title \"Selecciona la Ordenes a imprimir\" \
            --stdout \
            --radiolist \"Selecciona una opción:\" 0 0 10 $opciones
    )

    if [ -z "$oSimpresion" ]; then
        dialog --msgbox "No se seleccionó ninguna partida. Salida." 10 40
        exit 1
    fi

    #ids_unicas=$(obtenerIdsUnicas "$oSimpresion")
    p1_pc_6213_opg=$(fun_p1_pc_6213_opg "$oSimpresion")
    p1_mnl_2610_opg=$(func_p1_mnl_2610_opg "$oSimpresion")
    p1_pc_6257_opg=$(func_p1_pc_6257_opg "$oSimpresion")
    p2_not_9582_opg=$(func_p2_not_9582_opg "$oSimpresion")
    p2_not_9654_opg=$(func_p2_not_9654_opg "$oSimpresion")
    p5_pc_6186_opg=$(func_p5_pc_6186_opg "$oSimpresion")
    p5_mnl_2254_opg=$(func_p5_mnl_2254_opg "$oSimpresion")
    p5_mnl_2254_opg_2=$(func_p5_mnl_2254_opg_2 "$oSimpresion")
    p6_not_9548_opg=$(func_p6_not_9548_opg "$oSimpresion")
    p10_ac_9132_opg=$(func_p10_ac_9132_opg "$oSimpresion")
    p10_kb_880_opg=$(func_p10_kb_880_opg "$oSimpresion")
    p10_mnl_2254_opg=$(func_p10_mnl_2254_opg "$oSimpresion")
    p13_mnl_2254_opg=$(func_p13_mnl_2254_opg "$oSimpresion")
    p14_mnl_2254_opg=$(func_p14_mnl_2254_opg "$oSimpresion")

    # Debugging output: Verifica los valores recibidos
    #echo "Salida de p14_mnl_2254_opg: $p1_pc_6213_opg"

    # Asegurarse de que los valores no tengan espacios innecesarios
    #p14_mnl_2254_opg=$(echo "$p1_pc_6213_opg" | sed 's/ *//g')

    preProcesadorsalida "$p1_pc_6213_opg"
    preProcesadorsalida "$p1_mnl_2610_opg"
    preProcesadorsalida "$p1_pc_6257_opg"
    preProcesadorsalida "$p2_not_9582_opg"
    preProcesadorsalida "$p2_not_9654_opg"
    preProcesadorsalida "$p5_pc_6186_opg"
    preProcesadorsalida "$p5_mnl_2254_opg"
    preProcesadorsalida "$p5_mnl_2254_opg_2"
    preProcesadorsalida "$p6_not_9548_opg"
    preProcesadorsalida "$p10_ac_9132_opg"
    preProcesadorsalida "$p10_kb_880_opg"
    preProcesadorsalida "$p10_mnl_2254_opg"
    preProcesadorsalida "$p13_mnl_2254_opg"
    preProcesadorsalida "$p14_mnl_2254_opg"

}

function preProcesadorsalida {
    local salida=$1
    echo "$salida" | while IFS=',' read -r id_bundle numero_serie tarima modelo id_modelo; do
        # Convertir id_modelo a número y eliminar espacios en blanco
        id_modelo=$(echo "$id_modelo" | tr -d '[:space:]')

        # Para depuración: imprimir el valor de id_modelo
        echo "ID del Bundle: $id_bundle"
        echo "Número de Serie: $numero_serie"
        echo "Tarima: $tarima"
        echo "Último Número (Modelo): $id_modelo"

        # Llamar a la función con los parámetros adecuados
        selectorComputoZpl "$id_bundle" "$numero_serie" "$tarima" "$id_modelo"

    done
}

function selectorComputoZpl {
    local id_bundle=$1
    local numero_serie=$2
    local tarima=$3
    local id_modelo=$4

    # Elimina espacios y asegura que el valor sea numérico
    id_modelo=$(echo "$id_modelo" | tr -d '[:space:]')

    # Para depuración: imprimir el valor de id_modelo
    echo "Valor de id_modelo: '$id_modelo'"

    case $id_modelo in
    1)
        seleccionado='HP Pro SFF 400 G9 PC uso general'
        echo "IDBundle del serie: $id_bundle"
        echo "Número de Serie: $numero_serie"
        echo "Modelo ID Seleccionado: $id_modelo"
        # Aquí puedes hacer algo con los datos, como asignarlos a un arreglo asociativo
        declare -A equipo
        equipo=(
            ["NumeroContrato"]="PMX-2024-15-5"
            ["TipoEquipo"]="Partida 1 PC de uso General"
            ["MarcaModelo"]="HP Pro SFF 400 G9"
            ["Serie"]=$numero_serie
            ["Memoria"]="16 GB DDR4 a 3200MHZ"
            ["TamanoDiscoDuro"]="512 GB SSD"
            ["TarjetaVideo"]="No aplica"
            ["TarjetaRed"]="No aplica"
            ["Pantalla"]="No aplica"
            ["Certificados"]="-"
            ["CPU"]="Intel Core i5-13500"
            ["Tarima"]=$tarima
            ["ID"]=$id_bundle
        )
        zplComputo "${equipo[NumeroContrato]}" "${equipo[TipoEquipo]}" "${equipo[MarcaModelo]}" "${equipo[Serie]}" "${equipo[Memoria]}" "${equipo[TamanoDiscoDuro]}" "${equipo[TarjetaVideo]}" "${equipo[TarjetaRed]}" "${equipo[Pantalla]}" "${equipo[Certificados]}" "${equipo[CPU]}" "${equipo[Tarima]}" "${equipo[ID]}"

        # Puedes agregar más lógica aquí para manejar este caso
        ;;
        # Agrega más casos según sea necesario

    2)

        # Opción seleccionada: HP Pro Book 450 G10 Lap top completa
        seleccionado='HP Pro Book 450 G10 Lap top completa'

        # Partida 2 Laptop completa
        declare -A equipo
        # Asignar valores al arreglo asociativo
        equipo=(
            ["NumeroContrato"]="PMX-2024-15-5"
            ["TipoEquipo"]="Partida 2 Laptop Completa"
            ["MarcaModelo"]="HP Pro Book 450 G10"
            ["Serie"]=$numero_serie
            ["Memoria"]="16 GB DDR4 a 3200MHZ"
            ["TamanoDiscoDuro"]="512 PCIe NVMe SSD Gen 4"
            ["TarjetaVideo"]="No aplica"
            ["TarjetaRed"]="Wireless 802.11 ax"
            ["Pantalla"]="15.5 1920 x 1080 o FHD"
            ["Certificados"]="-"
            ["CPU"]="Intel Core I5-1334U"
            ["Tarima"]=$tarima
            ["ID"]=$id_bundle
        )

        # Imprimir etiqueta con ZPL
        zplComputo "${equipo[NumeroContrato]}" "${equipo[TipoEquipo]}" "${equipo[MarcaModelo]}" "${equipo[Serie]}" "${equipo[Memoria]}" "${equipo[TamanoDiscoDuro]}" "${equipo[TarjetaVideo]}" "${equipo[TarjetaRed]}" "${equipo[Pantalla]}" "${equipo[Certificados]}" "${equipo[CPU]}" "${equipo[Tarima]}" "${equipo[ID]}"

        ;;
    3)

        #Opción seleccionada: HP Z8 G5 Workstation Avanzada
        seleccionado='Workstation Avanzada'

        #Partida 3
        declare -A equipo
        # Asignar valores al arreglo asociativo
        equipo=(
            ["NumeroContrato"]="PMX-2024-15-5"
            ["TipoEquipo"]="Partida 5 Workstation Avanzada"
            ["MarcaModelo"]="HP Z8 G5"
            ["Serie"]=$numero_serie
            ["Memoria"]="128 GB DDR5 a 4800 MHZ"
            ["TamanoDiscoDuro"]="3x 512 PCIe NVMe SSD Gen 4"
            ["TarjetaVideo"]="2x NVidia RTX A5000 24 GB"
            ["TarjetaRed"]="No aplica"
            ["Pantalla"]="No aplica"
            ["Certificados"]="-"
            ["CPU"]="2x Intel xeon 5416s"
            ["Tarima"]=$tarima
            ["ID"]=$id_bundle
        )

        # Imprimir etiqueta con ZPL
        zplComputo "${equipo[NumeroContrato]}" "${equipo[TipoEquipo]}" "${equipo[MarcaModelo]}" "${equipo[Serie]}" "${equipo[Memoria]}" "${equipo[TamanoDiscoDuro]}" "${equipo[TarjetaVideo]}" "${equipo[TarjetaRed]}" "${equipo[Pantalla]}" "${equipo[Certificados]}" "${equipo[CPU]}" "${equipo[Tarima]}" "${equipo[ID]}"

        ;;
    4)

        #Opción seleccionada: HP Elite C640 G3 Equipo Portátil Chromebook
        seleccionado='Equipo Portátil Chromebook'

        declare -A equipo
        # Asignar valores al arreglo asociativo
        equipo=(
            ["NumeroContrato"]="PMX-2024-15-5"
            ["TipoEquipo"]="Partida 6 Equipo Portatil Chromebook"
            ["MarcaModelo"]="HP Elite C640 G3"
            ["Serie"]=$numero_serie
            ["Memoria"]="8 GB LPDDR4X a 4266 MHZ"
            ["TamanoDiscoDuro"]="128 GB"
            ["TarjetaVideo"]="No aplica"
            ["TarjetaRed"]="Wireless 802.11 ax"
            ["Pantalla"]="14 1920 x 1080 o FHD"
            ["Certificados"]="-"
            ["CPU"]="Intel Core i3 1215U"
            ["Tarima"]=$tarima
            ["ID"]=$id_bundle
        )

        # Imprimir etiqueta con ZPL
        zplComputo "${equipo[NumeroContrato]}" "${equipo[TipoEquipo]}" "${equipo[MarcaModelo]}" "${equipo[Serie]}" "${equipo[Memoria]}" "${equipo[TamanoDiscoDuro]}" "${equipo[TarjetaVideo]}" "${equipo[TarjetaRed]}" "${equipo[Pantalla]}" "${equipo[Certificados]}" "${equipo[CPU]}" "${equipo[Tarima]}" "${equipo[ID]}"

        ;;
    5)

        #Opción seleccionada: Replicador de Puertos para Laptop de Completa
        seleccionado='Replicador de Puertos para Laptop de Completa'

        declare -A equipo
        # Asignar valores al arreglo asociativo
        equipo=(
            ["NumeroContrato"]="PMX-2024-15-5"
            ["TipoEquipo"]="Partida 10 Replicador de Puertos para Laptop Completa"
            ["MarcaModelo"]="HP USB-C G5 Essential Dock"
            ["Serie"]=$numero_serie
            ["Puertoa"]="2 Display Port"
            ["Puertob"]="1 HDMI 2 Superspeed tipo A"
            ["Puertoc"]="1 USB C 1 Puerto RJ-45"
            ["Puertod"]="RJ-45"
            ["Cargador"]="SI"
            ["Tarima"]=$tarima
            ["ID"]=$id_bundle
        )

        # Imprimir etiqueta con ZPL
        zplDock "${equipo[NumeroContrato]}" "${equipo[TipoEquipo]}" "${equipo[MarcaModelo]}" "${equipo[Serie]}" "${equipo[Puertoa]}" "${equipo[Puertob]}" "${equipo[Puertoc]}" "${equipo[Puertod]}" "${equipo[Cargador]}" "${equipo[Tarima]}" "${equipo[ID]}"

        ;;
    6)

        #Monitor PC de Uso General HP P 24 G4
        seleccionado='Monitor PC de Uso General HP E24mv G4'

        declare -A equipo
        # Asignar valores al arreglo asociativo
        equipo=(
            ["NumeroContrato"]="PMX-2024-15-5"
            ["TipoEquipo"]="Partida 1 Monitor PC de Uso General"
            ["MarcaModelo"]="HP E24mv G4"
            ["Serie"]=$numero_serie
            ["Tecnologia"]="LED"
            ["Resolucion"]="1920x 1080"
            ["Tamanodepantalla"]="23.8 pulgadas"
            ["Energystar"]="SI"
            ["Tarima"]=$tarima
            ["ID"]=$id_bundle
        )

        # Imprimir etiqueta con ZPL
        zplMonitor "${equipo[NumeroContrato]}" "${equipo[TipoEquipo]}" "${equipo[MarcaModelo]}" "${equipo[Serie]}" "${equipo[Tecnologia]}" "${equipo[Resolucion]}" "${equipo[Tamanodepantalla]}" "${equipo[Energystar]}" "${equipo[Tarima]}" "${equipo[ID]}"

        ;;
    7)

        #Monitor de Workstation Avanzada HP P 24 G5
        seleccionado='Monitor PC de Uso General HP P 24 G5'

        declare -A equipo
        # Asignar valores al arreglo asociativo
        equipo=(
            ["NumeroContrato"]="PMX-2024-15-5"
            ["TipoEquipo"]="Partida 5 Workstation Avanzada (Monitor)"
            ["MarcaModelo"]="HP P 24 G5"
            ["Serie"]=$numero_serie
            ["Tecnologia"]="LED"
            ["Resolucion"]="1920x 1080"
            ["Tamanodepantalla"]="23.8 pulgadas"
            ["Energystar"]="SI"
            ["Tarima"]=$tarima
            ["ID"]=$id_bundle
        )

        # Imprimir etiqueta con ZPL
        zplMonitor "${equipo[NumeroContrato]}" "${equipo[TipoEquipo]}" "${equipo[MarcaModelo]}" "${equipo[Serie]}" "${equipo[Tecnologia]}" "${equipo[Resolucion]}" "${equipo[Tamanodepantalla]}" "${equipo[Energystar]}" "${equipo[Tarima]}" "${equipo[ID]}"

        ;;
    8)

        #Monitor Replicador Laptop Completa HP P 24 G5
        seleccionado='Monitor Replicador Laptop Completa HP P 24 G5'

        declare -A equipo
        # Asignar valores al arreglo asociativo
        equipo=(
            ["NumeroContrato"]="PMX-2024-15-5"
            ["TipoEquipo"]="Partida 10 Replicador de Puertos para Laptop Completa (Monitor)"
            ["MarcaModelo"]="HP P 24 G5"
            ["Serie"]=$numero_serie
            ["Tecnologia"]="LED"
            ["Resolucion"]="1920x 1080"
            ["Tamanodepantalla"]="23.8 pulgadas"
            ["Energystar"]="SI"
            ["Tarima"]=$tarima
            ["ID"]=$id_bundle
        )

        # Imprimir etiqueta con ZPL
        zplMonitor "${equipo[NumeroContrato]}" "${equipo[TipoEquipo]}" "${equipo[MarcaModelo]}" "${equipo[Serie]}" "${equipo[Tecnologia]}" "${equipo[Resolucion]}" "${equipo[Tamanodepantalla]}" "${equipo[Energystar]}" "${equipo[Tarima]}" "${equipo[ID]}"

        ;;
    9)

        #Monitor Replicador Laptop Completa HP P 24 G5
        seleccionado='Partida 13 Monitor adicional PC Uso General'

        declare -A equipo
        # Asignar valores al arreglo asociativo
        equipo=(
            ["NumeroContrato"]="PMX-2024-15-5"
            ["TipoEquipo"]="Partida 13 Monitor Adicional Para PC De Uso General"
            ["MarcaModelo"]="HP P24v G5"
            ["Serie"]=$numero_serie
            ["Tecnologia"]="LED"
            ["Resolucion"]="1920x 1080"
            ["Tamanodepantalla"]="23.8 pulgadas"
            ["Energystar"]="SI"
            ["Tarima"]=$tarima
            ["ID"]=$id_bundle
        )

        # Imprimir etiqueta con ZPL
        zplMonitor "${equipo[NumeroContrato]}" "${equipo[TipoEquipo]}" "${equipo[MarcaModelo]}" "${equipo[Serie]}" "${equipo[Tecnologia]}" "${equipo[Resolucion]}" "${equipo[Tamanodepantalla]}" "${equipo[Energystar]}" "${equipo[Tarima]}" "${equipo[ID]}"

        ;;
    10)

        #Monitor Replicador Laptop Completa HP P 24 G5
        seleccionado='Partida 14 Monitor Adicional para Laptop Completa'

        declare -A equipo
        # Asignar valores al arreglo asociativo
        equipo=(
            ["NumeroContrato"]="PMX-2024-15-5"
            ["TipoEquipo"]="Partida 14 Monitor  Adicional para Laptop Completa"
            ["MarcaModelo"]="HP P 24 G5"
            ["Serie"]=$numero_serie
            ["Tecnologia"]="LED"
            ["Resolucion"]="1920x 1080"
            ["Tamanodepantalla"]="23.8 pulgadas"
            ["Energystar"]="SI"
            ["Tarima"]=$tarima
            ["ID"]=$id_bundle
        )

        # Imprimir etiqueta con ZPL
        zplMonitor "${equipo[NumeroContrato]}" "${equipo[TipoEquipo]}" "${equipo[MarcaModelo]}" "${equipo[Serie]}" "${equipo[Tecnologia]}" "${equipo[Resolucion]}" "${equipo[Tamanodepantalla]}" "${equipo[Energystar]}" "${equipo[Tarima]}" "${equipo[ID]}"

        ;;
    *)
        #dialog --msgbox "Selección inválida. Salida." 10 40
        #exit 1
        echo "modelo no soportado"
        ;;
    esac
}

# Función para imprimir el ZPL
function imprimirZPL {
    contenido_zpl=$1
    impresora=$(cat impresora.txt)

    # Enviar el contenido ZPL a la impresora
    echo -e "$contenido_zpl" >"/dev/usb/$impresora"

}
# Llama a la función principal
verificaImpresora
