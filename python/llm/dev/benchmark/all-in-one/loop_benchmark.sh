#!/bin/bash
# Run benchmark for NUM_ITERATIONS
# Set config in config_master.yaml


CMD=run-arc.sh
ENV=cheenhau
NUM_ITERATIONS=1
OUTPUT_DIR=/home/arda/cheenhau/BigDL/.idea/$ENV-$(date -d "$datetime 16 hours" '+%Y-%m-%d %H:%M:%S' | sed 's/ /_/g')

config_master=config_master.yaml 
cp $config_master config.yaml

# ensures no csv file in folder
if ls *.csv 1> /dev/null 2>&1; then
    echo "csv file exists. Stopping." # ensures no csv file in output folder
    exit 1
fi

# run benchmark in loop
source activate base
conda activate $ENV
mkdir -p $OUTPUT_DIR
pip list > "$OUTPUT_DIR/requirements.txt"

for ((i=1; i<=$NUM_ITERATIONS; i++)); do
    echo "************************************************************ Iteration $i"
    bash $CMD
    mv *.csv $OUTPUT_DIR
done

echo "Results saved to $OUTPUT_DIR"
