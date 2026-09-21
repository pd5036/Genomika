#!/bin/bash
set -e

# Przejście do katalogu projektu i utworzenie czystego folderu na nowe dane
cd ~/ngs_projekt
mkdir -p raw_data_rna
cd raw_data_rna

echo "Rozpoczynam pobieranie danych dla projektu GSE147507 (RNA-seq)..."

# Lista numerów SRA do pobrania
SRA_LIST=("SRR11412215" "SRR11412216" "SRR11412217" "SRR11412218" "SRR11412219" "SRR11412220")

for srr in "${SRA_LIST[@]}"; do
    echo "Pobieranie: ${srr}"
    # Pobranie pliku .sra z serwerów NCBI
    prefetch ${srr}
    
    echo "Konwersja ${srr} do formatu FASTQ..."
    # Ekstrakcja do FASTQ (używa 6 wątków dla przyspieszenia)
    fasterq-dump ${srr} --threads 6 --split-3
    
    echo "Kompresja pliku ${srr}..."
    # Kompresja do .gz (wymagana przez większość narzędzi NGS)
    gzip ${srr}*.fastq
done

echo "Zmieniam nazwy plików na zgodne z dotychczasowymi skryptami..."

# Przypisanie próbek kontrolnych (Mock)
mv SRR11412215.fastq.gz WT_rep1.fastq.gz
mv SRR11412216.fastq.gz WT_rep2.fastq.gz
mv SRR11412217.fastq.gz WT_rep3.fastq.gz

# Przypisanie próbek zainfekowanych SARS-CoV-2
mv SRR11412218.fastq.gz MT_rep1.fastq.gz
mv SRR11412219.fastq.gz MT_rep2.fastq.gz
mv SRR11412220.fastq.gz MT_rep3.fastq.gz

# Przeniesienie gotowych plików do głównego folderu raw_data (podmiana)
cd ..
rm -rf raw_data/*  # Usunięcie starych, błędnych danych metagenomowych
mv raw_data_rna/* raw_data/
rm -rf raw_data_rna

echo "Pobieranie zakończone!"
