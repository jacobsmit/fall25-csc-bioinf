#!/bin/bash
# set -euxo pipefail
PATH=${PATH}:${HOME}/.codon/bin

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

echo "Dataset Language Runtime(s) N50"
echo "--------------------------------"

for dataset in $datasets; do
    # --- Python ---
    start_sec=$(date +%s)
    start_ms=$(date +%N)  # nanoseconds
    start_ms=$((start_ms / 1000000))  # convert to milliseconds

    python3 ./week1/code/python/main.py "$data_dir/$dataset" > "./week1/test/python_${dataset}"

    end_sec=$(date +%s)
    end_ms=$(date +%N)
    end_ms=$((end_ms / 1000000))

    # total elapsed time in milliseconds
    runtime_ms=$(((end_sec - start_sec) * 1000 + (end_ms - start_ms)))

    seconds=$((runtime_ms / 1000))
    milliseconds=$((runtime_ms % 1000))
    python_runtime=$(printf "%02d:%03d" $seconds $milliseconds)

    # --- Codon ---
    start_sec=$(date +%s)
    start_ms=$(date +%N)
    start_ms=$((start_ms / 1000000))

    codon run -release ./week1/code/codon/main.py "$data_dir/$dataset" > "./week1/test/codon_${dataset}"

    end_sec=$(date +%s)
    end_ms=$(date +%N)
    end_ms=$((end_ms / 1000000))

    runtime_ms=$(((end_sec - start_sec) * 1000 + (end_ms - start_ms)))
    seconds=$((runtime_ms / 1000))
    milliseconds=$((runtime_ms % 1000))
    codon_runtime=$(printf "%02d:%03d" $seconds $milliseconds)

    # --- Print Results ---
    python_n50=$(compute_n50 "./week1/test/python_${dataset}")
    codon_n50=$(compute_n50 "./week1/test/codon_${dataset}")
    echo "$dataset Python $python_runtime $python_n50"
    echo "$dataset Codon $codon_runtime $codon_n50"
done