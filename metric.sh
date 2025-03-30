#!/bin/bash

# Cantidad de veces que se ejecutará el programa
NUM_EJECUCIONES=10

# Array para almacenar los resultados
resultados=()

# Bucle para ejecutar el programa y extraer el resultado
for ((i=1; i<=NUM_EJECUCIONES; i++)); do
  # Ejecuta el programa headless y guarda la salida en una variable
  salida=$(./headless)

  # Extrae la línea que contiene "photons per second" usando grep
  linea_resultado=$(echo "$salida" | grep "photons per second")

  # Extrae el número usando grep y expresiones regulares
  numero_photons=$(echo "$linea_resultado" | grep -oE '[0-9]+\.[0-9]+')

  # Almacena el resultado en el array
  resultados+=("$numero_photons")

  # Imprime el resultado de cada ejecución
  echo "Ejecución $i: $numero_photons K photons per second"
done

# Encuentra el valor máximo
maximo=$(echo "${resultados[@]}" | awk '{max=$1; for(i=2; i<=NF; i++) if($i>max) max=$i; print max}')

# Imprime el valor máximo
echo "Valor máximo: $maximo K photons per second"
