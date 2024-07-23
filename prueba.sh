#!/bin/bash

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

function PC-6213-OPG {
    local oSimpresion=$1
    jq -r --arg os "$oSimpresion" '.table.rows[] | select(.c[2].v == $os) | "\(.c[1].v),\(.c[16].v),\(.c[30].v)"' bd-pemex-61.json
}

function MNL-2610-OPG {
    local oSimpresion=$1
    jq -r --arg os "$oSimpresion" '.table.rows[] | select(.c[2].v == $os) | "\(.c[1].v),\(.c[17].v),\(.c[31].v)"' bd-pemex-61.json
}

function PC-6257-OPG {
    local oSimpresion=$1
    jq -r --arg os "$oSimpresion" '.table.rows[] | select(.c[2].v == $os) | "\(.c[1].v),\(.c[18].v),\(.c[32].v)"' bd-pemex-61.json
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
    p1_PC_6213_OPG=$(PC-6213-OPG "$oSimpresion")
    p1_MNL_2610_OPG=$(MNL-2610-OPG "$oSimpresion")

    echo "$p1_PC_6213_OPG"
    echo "$p1_MNL_2610_OPG"
}

# Llama a la función principal
selectorOs
