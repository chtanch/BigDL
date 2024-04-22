#!/bin/bash
# This script runs benchmarks on the same set of models as nightly benchmark.
# The benchmark is run in a **separate bash shell** for each model in config.yaml.
# This prevents any model OOM from interrupting the rest of the benchmarks.
# The script requires yq package. Download yq from https://github.com/mikefarah/yq and copy it to /usr/bin (follow the install instructions).

CMD=run-arc.sh
OUTPUT_DIR=/home/arda/cheenhau/BigDL/.idea/$(date -d "$datetime 16 hours" '+%Y-%m-%d %H:%M:%S' | sed 's/ /_/g')

############################################################
# Function to update the YAML file with new values for fields
update_yaml() {
    local repo_id="$1"
    local yaml_file="$2"

    # Update the Yaml file with new values for repo_id
    yq eval ".repo_id = [\"$repo_id\"]" -i "$yaml_file"
}

run_benchmark_loop(){
    local config_master="$1"

    # Read the values from YAML file into arrays
    readarray -t repo_id_list < <(yq eval '.repo_id[]' $config_master)
    cp $config_master config.yaml

    # Loop over every repo_id_list, in_out_pairs_list, update config, and run benchmark
    for repo_id in "${repo_id_list[@]}"
    do
        echo $repo_id
        update_yaml "$repo_id" config.yaml
        bash $CMD
        mv *.csv $OUTPUT_DIR
        sleep 10
    done
}

############################################################
# ensures no csv file in folder
if ls *.csv 1> /dev/null 2>&1; then
    echo "csv file exists. Stopping." 
    exit 1
fi
mkdir -p $OUTPUT_DIR

# Test on xpu(transformers==4.31.0)
CONFIG_MASTER=/home/arda/cheenhau/BigDL/python/llm/test/benchmark/arc-perf-test.yaml # configure all experiments in this file
python -m pip install transformers==4.31.0
pip list > "$OUTPUT_DIR/$(basename "$CONFIG_MASTER")-requirements.txt"
run_benchmark_loop "$CONFIG_MASTER"

# exit

# Test on xpu(transformers==4.34.0)
CONFIG_MASTER=/home/arda/cheenhau/BigDL/python/llm/test/benchmark/arc-perf-transformers-434.yaml # configure all experiments in this file
python -m pip install transformers==4.34.0
pip list > "$OUTPUT_DIR/$(basename "$CONFIG_MASTER")-requirements.txt"
run_benchmark_loop "$CONFIG_MASTER"

# Test on xpu(transformers==4.37.0)
CONFIG_MASTER=/home/arda/cheenhau/BigDL/python/llm/test/benchmark/arc-perf-transformers-437.yaml # configure all experiments in this file
python -m pip install transformers==4.37.0
pip list > "$OUTPUT_DIR/$(basename "$CONFIG_MASTER")-requirements.txt"
run_benchmark_loop "$CONFIG_MASTER"
python -m pip install transformers==4.31.0

echo "Results saved to $OUTPUT_DIR"
