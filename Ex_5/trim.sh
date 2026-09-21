
#!/bin/bash

THREADS=4
DATA_DIR="/mnt/c/Users/defaultuser0.DESKTOP-9B20QHN/Desktop/PJATK/Bioinformatyka_w_genomice/Dane"

SAMPLES=("SRR25629154" "SRR25629153")

for SAMPLE in "${SAMPLES[@]}"
do
    echo "Analiza: $SAMPLE"

    trimmomatic PE \
    -threads $THREADS \
    -phred33 \
    ${DATA_DIR}/${SAMPLE}_1.fastq.gz \
    ${DATA_DIR}/${SAMPLE}_2.fastq.gz \
    ${SAMPLE}_1_trimmed.fastq.gz ${SAMPLE}_1_unpaired.fastq.gz \
    ${SAMPLE}_2_trimmed.fastq.gz ${SAMPLE}_2_unpaired.fastq.gz \
    LEADING:20 \
    TRAILING:20 \
    SLIDINGWINDOW:5:20 \
    MINLEN:50

    echo "Zakończono: $SAMPLE"
done

echo "Zakończono wszelkie analizy"
