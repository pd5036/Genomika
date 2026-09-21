mkdir -p fastqc_reports/raw
conda activate FastQC

fastqc -o fastqc_reports/raw -f fastq --noextract -t 4 \
    raw_data/WT_rep1.fastq.gz raw_data/WT_rep2.fastq.gz raw_data/WT_rep3.fastq.gz \
    raw_data/MT_rep1.fastq.gz raw_data/MT_rep2.fastq.gz raw_data/MT_rep3.fastq.gz

conda deactivate

