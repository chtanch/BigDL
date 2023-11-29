#!/bin/bash
# Run benchmark for NUM_ITERATIONS over all repo_id. Each run with one repo_id.
# Set config in config_master.yaml

CMD=run-arc.sh
ENV=cheenhau
NUM_ITERATIONS=1
OUTPUT_DIR=/home/arda/cheenhau/BigDL/.idea/$ENV-$(date -d "$datetime 16 hours" '+%Y-%m-%d %H:%M:%S' | sed 's/ /_/g')

# Read the values from YAML file into arrays
config_master=config_master.yaml  # configure all experiments in this file
readarray -t repo_id_list < <(yq eval '.repo_id[]' $config_master)
cp $config_master config.yaml

# ensures no csv file in folder
if ls *.csv 1> /dev/null 2>&1; then
    echo "csv file exists. Stopping." 
    exit 1
fi

############################################################
# Function to update the YAML file with new values for fields
update_yaml() {
    local repo_id="$1"
    local yaml_file="$2"

    # Update the Yaml file with new values for repo_id
    yq eval ".repo_id = [\"$repo_id\"]" -i "$yaml_file"
}

source activate base
conda activate $ENV
mkdir -p $OUTPUT_DIR
pip list > "$OUTPUT_DIR/requirements.txt"

for ((i=1; i<=$NUM_ITERATIONS; i++)); do
    echo "************************************************************ Iteration $i"

    # Loop over every repo_id_list, in_out_pairs_list, update config, and run benchmark
    for repo_id in "${repo_id_list[@]}"
    do
        update_yaml "$repo_id" config.yaml
        bash $CMD
        mv *.csv $OUTPUT_DIR
        sleep 10
    done
done

echo "Results saved to $OUTPUT_DIR"
