#!/bin/bash
# Ex_7 pd4768 Damian Szkudlarek

for sample in SRR25629154 SRR25629153
do
  echo "Mapowanie: $sample"
  bwa mem genome_index/Ecoli_K12.fasta ${sample}_1_trimmed.fastq.gz ${sample}_2_trimmed.fastq.gz > ${sample}.sam
  samtools view -bS ${sample}.sam > ${sample}.bam
done