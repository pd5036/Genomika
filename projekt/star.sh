mkdir -p reference/star_index

conda activate mapping
nohup STAR --runThreadN 4 \
    --runMode genomeGenerate \
    --genomeDir reference/star_index \
    --genomeFastaFiles reference/GRCh38.primary_assembly.genome.fa \
    --sjdbGTFfile reference/Homo_sapiens.GRCh38.111.gtf \
    --sjdbOverhang 150 \
    > reference/star_index.log 2>&1 &
conda deactivate

jobs
