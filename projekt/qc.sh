#!/bin/bash
set -e

mkdir -p fastqc_reports/raw
mkdir -p reports/multiqc_raw

fastqc --threads 6 --outdir fastqc_reports/raw raw_data/*.fastq.gz


multiqc fastqc_reports/raw --outdir reports/multiqc_raw --filename multiqc_raw.html --force

echo "Kzakończone."
