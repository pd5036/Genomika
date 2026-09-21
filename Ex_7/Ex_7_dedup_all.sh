#!/bin/bash
# Ex_7 pd4768 Damian Szkudlarek

for sample in Ecoli_rep1 SRR25629154 SRR25629153
do
  echo "Fixmate: $sample"
  samtools fixmate -m ${sample}.bam ${sample}_fixmate.bam

  echo "Sortowanie: $sample"
  samtools sort ${sample}_fixmate.bam -o ${sample}_fixmate_sorted.bam

  echo "Indeksowanie: $sample"
  samtools index ${sample}_fixmate_sorted.bam

  echo "Usuwanie duplikatów: $sample"
  samtools markdup -r ${sample}_fixmate_sorted.bam ${sample}_dedup.bam
done