#!/bin/bash
# set -euxo pipefail
PATH=${PATH}:${HOME}/.codon/bin

# pwd
# ls -R


data_dir="week1/data"
datasets="data1 data2 data3 data4"

# Input: file with contig lengths as second column
function compute_n50() {
    file="$1"

    # Extract lengths, skip first 3 lines, sort descending
    lengths=($(awk 'NR>3 {print $2}' "$file" | sort -nr))

    # Check if lengths array is empty
    if [ ${#lengths[@]} -eq 0 ]; then
        echo "0"
        return
    fi

    # Compute total sum
    total=0
    for l in "${lengths[@]}"; do
        total=$((total + l))
    done
    half=$((total / 2))

    # Compute N50
    sum=0
    for l in "${lengths[@]}"; do
        sum=$((sum + l))
        if [ "$sum" -ge "$half" ]; then
            echo "$l"
            return
        fi
    done
}

format_time() {
    local ms=$1
    local s=$((ms / 1000))
    local ms_rem=$((ms % 1000))
    printf "%02d:%03d" "$s" "$ms_rem"
}

echo "Dataset Language Runtime(s) N50"
echo "--------------------------------"

for dataset in $datasets; do
    # --- Python ---
    start=$(date +%s%3N)
    python3 ./week1/code/Python/main.py "$data_dir/$dataset" > "./week1/test/python_${dataset}"
    end=$(date +%s%3N)
    python_runtime=$(format_time $((end - start)))

    # --- Codon ---

    start=$(date +%s%3N)
    codon run -release ./week1/code/codon/main.py "$data_dir/$dataset" > "./week1/test/codon_${dataset}"
    end=$(date +%s%3N)
    codon_runtime=$(format_time $((end - start)))

    # --- Print Results ---
    python_n50=$(compute_n50 "./week1/test/python_${dataset}")
    codon_n50=$(compute_n50 "./week1/test/codon_${dataset}")
    echo "$dataset Python $python_runtime $python_n50"
    echo "$dataset Codon $codon_runtime $codon_n50"
done