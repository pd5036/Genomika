#!/bin/bash


# Analiza wariantow SNV z poprawnymi plikami BAM

# Plik referencyjny: Ecoli_reference.fasta


# 1. Zlicz wszystkie warianty
echo "Liczba wszystkich wariantów w variants_1.vcf:"
grep -v "^#" variants_1.vcf | wc -l

# 2. Zlicz SNP-y
echo "Liczba SNP w variants_1.vcf:"
bcftools view -v snps variants_1.vcf | grep -v "^#" | wc -l

# 3a. SRR25629154
bcftools mpileup \
  -O b \
  -o raw_2.bcf \
  -f Ecoli_reference.fasta \
  -q 20 \
  -Q 30 \
  Ecoli_rep2_sorted.bam

bcftools call \
  -m \
  -v \
  --ploidy 1 \
  -o variants_2.vcf \
  raw_2.bcf

# 3b. SRR25629153
bcftools mpileup \
  -O b \
  -o raw_3.bcf \
  -f Ecoli_reference.fasta \
  -q 20 \
  -Q 30 \
  Ecoli_rep3_sorted.bam

bcftools call \
  -m \
  -v \
  --ploidy 1 \
  -o variants_3.vcf \
  raw_3.bcf

# 4. Kompresuj pliki VCF
bgzip -f variants_1.vcf
bgzip -f variants_2.vcf
bgzip -f variants_3.vcf

# 4a. Indeksuj VCF-y
bcftools index -f variants_1.vcf.gz
bcftools index -f variants_2.vcf.gz
bcftools index -f variants_3.vcf.gz

# 4b. Scal VCF-y
bcftools merge variants_1.vcf.gz variants_2.vcf.gz variants_3.vcf.gz -o merged.vcf

echo "Wszystko gotowe. Utworzono plik merged.vcf"
