#!/bin/bash

#objeto inicial



# Función para verificar la impresora y seleccionar una si no existe
function verificaImpresora {
    # Eliminar el archivo impresora.txt si existe
    if [ -f impresora.txt ]; then
        echo "Eliminando el archivo impresora.txt..."
        rm impresora.txt
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
    main
}

# Función para solicitar el número de serie
function solicitarNumeroSerie {
    local selecionado=$1
    serie=$(dialog --inputbox "Ingrese el número de serie para $selecionado:" 8 40 --output-fd 1)

       # Convertir la entrada a mayúsculas
    serie=${serie^^}

    if [ -z "$serie" ]; then
        dialog --msgbox "Debe ingresar un número de serie. Salida." 10 40
        exit 1
    fi

    echo "$serie"
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

    # Llama a la función imprimirZPL con el contenido ZPL
    imprimirZPL "$zpl"

}

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

    # Llama a la función imprimirZPL con el contenido ZPL
    imprimirZPL "$zpl"

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

    # Llama a la función imprimirZPL con el contenido ZPL
    imprimirZPL "$zpl"

}

# Función para manejar la selección de hardware y generar ZPL correspondiente
function selectorComputoZpl {
    local hardware=$1
    # partida 1 PC
    case $hardware in
    1)
        while true; do
            # Solicitar el número de serie
            seleccionado='HP  Pro SFF 400 G9 PC uso general'
            numero_serie=$(solicitarNumeroSerie "$seleccionado")

            declare -A equipo
            # Asignar valores al arreglo asociativo
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
                ["CPU"]="Intel Core i513500"

            )

            # Imprimir etiqueta con ZPL
            zplComputo "${equipo[NumeroContrato]}" "${equipo[TipoEquipo]}" "${equipo[MarcaModelo]}" "${equipo[Serie]}" "${equipo[Memoria]}" "${equipo[TamanoDiscoDuro]}" "${equipo[TarjetaVideo]}" "${equipo[TarjetaRed]}" "${equipo[Pantalla]}" "${equipo[Certificados]}" "${equipo[CPU]}"
            # Mostrar un mensaje de confirmación
            #dialog --title "Impresión final QR PEMEX P-61" --msgbox "Etiqueta impresa exitosamente." 10 40
            # Preguntar si se desea imprimir otra etiqueta
            #dialog --yesno "¿Deseas imprimir otra etiqueta?" 10 40
            #if [ $? -ne 0 ]; then
            #     break
            #fi
        done
        ;;
    2)
        while true; do
            # Opción seleccionada: HP Pro Book 450 G10 Lap top completa
            seleccionado='HP Pro Book 450 G10 Lap top completa'
            numero_serie=$(solicitarNumeroSerie "$seleccionado")
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
            )

            # Imprimir etiqueta con ZPL
            zplComputo "${equipo[NumeroContrato]}" "${equipo[TipoEquipo]}" "${equipo[MarcaModelo]}" "${equipo[Serie]}" "${equipo[Memoria]}" "${equipo[TamanoDiscoDuro]}" "${equipo[TarjetaVideo]}" "${equipo[TarjetaRed]}" "${equipo[Pantalla]}" "${equipo[Certificados]}" "${equipo[CPU]}"
        done
        ;;
    3)
        while true; do
            #Opción seleccionada: HP Z8 G5 Workstation Avanzada
            seleccionado='Workstation Avanzada'
            numero_serie=$(solicitarNumeroSerie "$seleccionado")
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
            )

            # Imprimir etiqueta con ZPL
            zplComputo "${equipo[NumeroContrato]}" "${equipo[TipoEquipo]}" "${equipo[MarcaModelo]}" "${equipo[Serie]}" "${equipo[Memoria]}" "${equipo[TamanoDiscoDuro]}" "${equipo[TarjetaVideo]}" "${equipo[TarjetaRed]}" "${equipo[Pantalla]}" "${equipo[Certificados]}" "${equipo[CPU]}"
        done
        ;;
    4)
        while true; do
            #Opción seleccionada: HP Elite C640 G3 Equipo Portátil Chromebook
            seleccionado='Equipo Portátil Chromebook'
            numero_serie=$(solicitarNumeroSerie "$seleccionado")

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
            )

            # Imprimir etiqueta con ZPL
            zplComputo "${equipo[NumeroContrato]}" "${equipo[TipoEquipo]}" "${equipo[MarcaModelo]}" "${equipo[Serie]}" "${equipo[Memoria]}" "${equipo[TamanoDiscoDuro]}" "${equipo[TarjetaVideo]}" "${equipo[TarjetaRed]}" "${equipo[Pantalla]}" "${equipo[Certificados]}" "${equipo[CPU]}"
        done
        ;;
    5)
        while true; do
            #Opción seleccionada: Replicador de Puertos para Laptop de Completa
            seleccionado='Replicador de Puertos para Laptop de Completa'
            numero_serie=$(solicitarNumeroSerie "$seleccionado")

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
            )

            # Imprimir etiqueta con ZPL
            zplDock "${equipo[NumeroContrato]}" "${equipo[TipoEquipo]}" "${equipo[MarcaModelo]}" "${equipo[Serie]}" "${equipo[Puertoa]}" "${equipo[Puertob]}" "${equipo[Puertoc]}" "${equipo[Puertod]}" "${equipo[Cargador]}"
        done
        ;;
    6)
        while true; do
            #Monitor PC de Uso General HP P 24 G4
            seleccionado='Monitor PC de Uso General HP E24mv G4'
            numero_serie=$(solicitarNumeroSerie "$seleccionado")

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
            )

            # Imprimir etiqueta con ZPL
            zplMonitor "${equipo[NumeroContrato]}" "${equipo[TipoEquipo]}" "${equipo[MarcaModelo]}" "${equipo[Serie]}" "${equipo[Tecnologia]}" "${equipo[Resolucion]}" "${equipo[Tamanodepantalla]}" "${equipo[Energystar]}"
        done
        ;;
    7)
        while true; do
            #Monitor de Workstation Avanzada HP P 24 G5
            seleccionado='Monitor PC de Uso General HP P 24 G5'
            numero_serie=$(solicitarNumeroSerie "$seleccionado")

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
            )

            # Imprimir etiqueta con ZPL
            zplMonitor "${equipo[NumeroContrato]}" "${equipo[TipoEquipo]}" "${equipo[MarcaModelo]}" "${equipo[Serie]}" "${equipo[Tecnologia]}" "${equipo[Resolucion]}" "${equipo[Tamanodepantalla]}" "${equipo[Energystar]}"
        done
        ;;
    8)
        while true; do
            #Monitor Replicador Laptop Completa HP P 24 G5
            seleccionado='Monitor Replicador Laptop Completa HP P 24 G5'
            numero_serie=$(solicitarNumeroSerie "$seleccionado")

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
            )

            # Imprimir etiqueta con ZPL
            zplMonitor "${equipo[NumeroContrato]}" "${equipo[TipoEquipo]}" "${equipo[MarcaModelo]}" "${equipo[Serie]}" "${equipo[Tecnologia]}" "${equipo[Resolucion]}" "${equipo[Tamanodepantalla]}" "${equipo[Energystar]}"
        done
        ;;
    9)
        while true; do
            #Monitor Replicador Laptop Completa HP P 24 G5
            seleccionado='Partida 13 Monitor adicional PC Uso General'
            numero_serie=$(solicitarNumeroSerie "$seleccionado")

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
            )

            # Imprimir etiqueta con ZPL
            zplMonitor "${equipo[NumeroContrato]}" "${equipo[TipoEquipo]}" "${equipo[MarcaModelo]}" "${equipo[Serie]}" "${equipo[Tecnologia]}" "${equipo[Resolucion]}" "${equipo[Tamanodepantalla]}" "${equipo[Energystar]}"
        done
        ;;
    10)
        while true; do
            #Monitor Replicador Laptop Completa HP P 24 G5
            seleccionado='Partida 14 Monitor Adicional para Laptop Completa'
            numero_serie=$(solicitarNumeroSerie "$seleccionado")

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
            )

            # Imprimir etiqueta con ZPL
            zplMonitor "${equipo[NumeroContrato]}" "${equipo[TipoEquipo]}" "${equipo[MarcaModelo]}" "${equipo[Serie]}" "${equipo[Tecnologia]}" "${equipo[Resolucion]}" "${equipo[Tamanodepantalla]}" "${equipo[Energystar]}"
        done
        ;;
    *)
        dialog --msgbox "Selección inválida. Salida." 10 40
        exit 1
        ;;
    esac
}

# Función principal para ejecutar el flujo
function main {
    partida=$(
        dialog --title "Selecciona el Hardware" \
            --stdout \
            --radiolist "Selecciona una opción:" 0 0 7 \
            1 "Partida 1 Computo - HP Pro SFF 400 G9 PC uso general" off \
            2 "Partida 2 Computo - HP Pro Book 450 G10 Lap top completa" off \
            3 "Partida 5 Computo - HP Z8 G5 Workstation Avanzada" off \
            4 "Partida 6 Computo - HP Elite C640 G3 Equipo Portátil Chromebook" off \
            5 "Partida 10 Docking USB" off \
            6 "Partida 1 Monitor PC de Uso General - HP E24mv G4" off \
            7 "Partida 5 Monitor de Workstation Avanzada - HP P 24 G5" off \
            8 "Partida 10 Monitor Replicador Laptop Completa - HP P 24 G5" off \
            9 "Partida 13 Monitor Adicional PC Uso General - HP P24v G5" off \
            10 "Partida 14 Monitor  Adicional para Laptop Completa - HP P 24 G5" off
    )

    if [ -z "$partida" ]; then
        dialog --msgbox "No se seleccionó ninguna partida. Salida." 10 40
        exit 1
    fi

    selectorComputoZpl "$partida"
}

# Ejecutar la función principal

# Función para imprimir el ZPL
function imprimirZPL {
    contenido_zpl=$1
    impresora=$(cat impresora.txt)

    # Enviar el contenido ZPL a la impresora
    echo -e "$contenido_zpl" >"/dev/usb/$impresora"

}

# Ejecutar la verificación de la impresora
verificaImpresora