#!/bin/bash
set -e


source ~/miniconda3/etc/profile.d/conda.sh
conda activate cutadapt_env

mkdir -p trimmed_data
ADAPTER="AGATCGGAAGAGCACACGTCTGAACTCCAGTCA"

for sample in WT_rep1 WT_rep2 WT_rep3 MT_rep1 MT_rep2 MT_rep3; do
    
    cutadapt -a ${ADAPTER} \
             -m 30 \
             -o trimmed_data/${sample}_trimmed.fastq.gz \
             raw_data/${sample}.fastq.gz \
             > trimmed_data/${sample}_cutadapt.log
done

echo "zakończony."
