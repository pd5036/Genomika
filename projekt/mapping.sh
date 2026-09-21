#!/bin/bash
set -e

source ~/miniconda3/etc/profile.d/conda.sh
conda activate mapping

mkdir -p mapped_data

for sample in WT_rep1 WT_rep2 WT_rep3 MT_rep1 MT_rep2 MT_rep3; do
  
    STAR --genomeDir reference/star_index \
        --readFilesIn trimmed_data/quality_trimmed/${sample}_final.fastq.gz \
        --readFilesCommand zcat \
        --outSAMtype BAM SortedByCoordinate \
        --quantMode GeneCounts \
        --outFileNamePrefix mapped_data/${sample}_ \
        --runThreadN 12

    
    samtools index mapped_data/${sample}_Aligned.sortedByCoord.out.bam
done

conda deactivate
echo "Mapowanie zakończone."
