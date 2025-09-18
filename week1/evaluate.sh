#!/bin/bash
# set -euxo pipefail
PATH=${PATH}:${HOME}/.codon/bin

data_dir="week1/data"
datasets="data1 data2 data3 data4"

ulimit -s 8192000

# --- Build Codon binary once for speed ---
codon_exe="./week1/code/codon/main_exe"
echo "Building Codon executable..."
codon build -release ./week1/code/codon/main.py -o "$codon_exe"
echo "Codon build complete."
echo ""

# Function to compute N50
compute_n50() {
    file="$1"

    lengths=($(awk 'NR>3 {print $2}' "$file" | sort -nr))
    if [ ${#lengths[@]} -eq 0 ]; then
        echo "0"
        return
    fi

    total=0
    for l in "${lengths[@]}"; do
        total=$((total + l))
    done
    half=$((total / 2))

    sum=0
    for l in "${lengths[@]}"; do
        sum=$((sum + l))
        if [ "$sum" -ge "$half" ]; then
            echo "$l"
            return
        fi
    done
}

# Format runtime as MM:SS:MS
format_time() {
    local ms=$1
    local total_s=$((ms / 1000))
    local ms_rem=$((ms % 1000))
    local min=$((total_s / 60))
    local sec=$((total_s % 60))
    printf "%02d:%02d:%03d" "$min" "$sec" "$ms_rem"
}

# Ensure test directory exists
mkdir -p ./week1/test

# Table Header
printf "\n%-10s │ %-9s │ %-17s │ %-10s\n" "Dataset" "Language" "Runtime(MM:SS:MS)" "N50"
printf "───────────┼───────────┼───────────────────┼──────────\n"

# Main Loop
for dataset in $datasets; do
    # --- Python ---
    start=$(date +%s%3N)
    python3 ./week1/code/python/main.py "$data_dir/$dataset" > "./week1/test/python_${dataset}"
    end=$(date +%s%3N)
    python_runtime=$(format_time $((end - start)))

    # --- Codon ---
    start=$(date +%s%3N)
    "$codon_exe" "$data_dir/$dataset" > "./week1/test/codon_${dataset}"
    end=$(date +%s%3N)
    codon_runtime=$(format_time $((end - start)))

    # --- Compute N50 ---
    python_n50=$(compute_n50 "./week1/test/python_${dataset}")
    codon_n50=$(compute_n50 "./week1/test/codon_${dataset}")

    # --- Print Results in Table ---
    printf "%-10s │ %-9s │ %-17s │ %-10s\n" "$dataset" "python" "$python_runtime" "$python_n50"
    printf "%-10s │ %-9s │ %-17s │ %-10s\n" "$dataset" "Ccdon" "$codon_runtime" "$codon_n50"
done