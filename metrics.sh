#!/bin/bash

# Configuración
declare -a COMPILERS=("gcc" "clang")
declare -a FLAGS=("" "-O2" "-O3")
declare -a FLAGS2=("" "-funroll-loops" "-march=native")
OUTPUT_FILE="benchmark_results.csv"
EXECUTABLE="headless"
SOURCES="wtime.c photon.c tiny_mc.c"
LDFLAGS="-lm"
RUNS=10  # Número de veces que se ejecuta cada combinación

# Encabezado del archivo CSV
echo "Compiler,Flags,Best Time(s),Best Photons per second" > $OUTPUT_FILE

# Compilación y ejecución
for CC in "${COMPILERS[@]}"; do
    for FLAG in "${FLAGS[@]}"; do
        for EXTRA_FLAG in "${FLAGS2[@]}"; do
            FULL_FLAG="$FLAG $EXTRA_FLAG"
            echo "Compilando con $CC $FULL_FLAG..."
            $CC $FULL_FLAG -std=c11 -Wall -Wextra -o $EXECUTABLE $SOURCES $LDFLAGS
            
            if [ $? -eq 0 ]; then
                BEST_TIME=9999999  # Inicializamos con un valor alto
                BEST_PHOTONS=0     # Inicializamos con un valor bajo
                
                for ((i=1; i<=RUNS; i++)); do
                    echo "Ejecución $i de $CC $FULL_FLAG..."
                    OUTPUT=$(./$EXECUTABLE)
                    
                    TIME=$(echo "$OUTPUT" | grep -oP "\d+\.\d+ seconds" | grep -oP "\d+\.\d+")
                    PHOTONS=$(echo "$OUTPUT" | grep -oP "\d+\.\d+ K photons per second" | grep -oP "\d+\.\d+")
                    
                    if [[ ! -z "$TIME" && ! -z "$PHOTONS" ]]; then
                        if (( $(echo "$TIME < $BEST_TIME" | bc -l) )); then
                            BEST_TIME=$TIME
                        fi
                        if (( $(echo "$PHOTONS > $BEST_PHOTONS" | bc -l) )); then
                            BEST_PHOTONS=$PHOTONS
                        fi
                    fi
                done
                
                echo "$CC,$FULL_FLAG,$BEST_TIME,$BEST_PHOTONS" >> $OUTPUT_FILE
            else
                echo "Error en la compilación con $CC $FULL_FLAG."
            fi
        done
        
        # Iteraciones con combinaciones múltiples de FLAGS2
        for ((i=0; i<${#FLAGS2[@]}; i++)); do
            for ((j=i+1; j<${#FLAGS2[@]}; j++)); do
                MULTI_FLAGS="${FLAGS2[i]} ${FLAGS2[j]}"
                FULL_FLAG="$FLAG $MULTI_FLAGS"
                echo "Compilando con $CC $FULL_FLAG..."
                $CC $FULL_FLAG -std=c11 -Wall -Wextra -o $EXECUTABLE $SOURCES $LDFLAGS
                
                if [ $? -eq 0 ]; then
                    BEST_TIME=9999999  # Inicializamos con un valor alto
                    BEST_PHOTONS=0     # Inicializamos con un valor bajo
                    
                    for ((k=1; k<=RUNS; k++)); do
                        echo "Ejecución $k de $CC $FULL_FLAG..."
                        OUTPUT=$(./$EXECUTABLE)
                        
                        TIME=$(echo "$OUTPUT" | grep -oP "\d+\.\d+ seconds" | grep -oP "\d+\.\d+")
                        PHOTONS=$(echo "$OUTPUT" | grep -oP "\d+\.\d+ K photons per second" | grep -oP "\d+\.\d+")
                        
                        if [[ ! -z "$TIME" && ! -z "$PHOTONS" ]]; then
                            if (( $(echo "$TIME < $BEST_TIME" | bc -l) )); then
                                BEST_TIME=$TIME
                            fi
                            if (( $(echo "$PHOTONS > $BEST_PHOTONS" | bc -l) )); then
                                BEST_PHOTONS=$PHOTONS
                            fi
                        fi
                    done
                    
                    echo "$CC,$FULL_FLAG,$BEST_TIME,$BEST_PHOTONS" >> $OUTPUT_FILE
                else
                    echo "Error en la compilación con $CC $FULL_FLAG."
                fi
            done
        done
    done
done

echo "Resultados guardados en $OUTPUT_FILE"
