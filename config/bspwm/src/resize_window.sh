#!/usr/bin/env bash

# Cantidad de píxeles para redimensionar
RESIZE_AMOUNT=20

# Obtener la ventana enfocada
focused_window=$(bspc query -N -n focused)

# Verificar si hay una ventana enfocada
if [[ -n "$focused_window" ]]; then
    # Comprobar si Shift está presionado
    if [[ "$1" == "shift" ]]; then
        # Contraer la ventana (mover los bordes hacia adentro)
        case "$2" in
            left)
                bspc node "$focused_window" -z left -$RESIZE_AMOUNT 0
                ;;
            right)
                bspc node "$focused_window" -z right -$RESIZE_AMOUNT 0
                ;;
            up)
                bspc node "$focused_window" -z top 0 -$RESIZE_AMOUNT
                ;;
            down)
                bspc node "$focused_window" -z bottom 0 -$RESIZE_AMOUNT
                ;;
            *)
                echo "Dirección inválida: $2. Usa left, right, up o down."
                exit 1
                ;;
        esac
    else
        # Expandir la ventana (mover los bordes hacia afuera)
        case "$1" in
            left)
                bspc node "$focused_window" -z left $RESIZE_AMOUNT 0
                ;;
            right)
                bspc node "$focused_window" -z right $RESIZE_AMOUNT 0
                ;;
            up)
                bspc node "$focused_window" -z top 0 $RESIZE_AMOUNT
                ;;
            down)
                bspc node "$focused_window" -z bottom 0 $RESIZE_AMOUNT
                ;;
            *)
                echo "Dirección inválida: $1. Usa left, right, up o down."
                exit 1
                ;;
        esac
    fi
else
    echo "No hay ninguna ventana enfocada."
    exit 1
fi