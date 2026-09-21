#!/bin/bash
set -e

source ~/miniconda3/etc/profile.d/conda.sh
conda activate rseqc_env

mkdir -p qc/infer_experiment

for sample in WT_rep1 WT_rep2 WT_rep3 MT_rep1 MT_rep2 MT_rep3; do
   
    infer_experiment.py \
        -i mapped_data/${sample}_Aligned.sortedByCoord.out.bam \
        -r reference/annotation.bed12 \
        -s 200000 \
        > qc/infer_experiment/${sample}_infer_experiment.txt
done

conda deactivate
echo "proces  zakończony"
