# Ex17 pd5036 Łukasz KRZOWSKI

# Analiza różnicowa z DESeq2 cz.1

# 1. Wczytanie macierzy zliczeń
raw_counts <- read.table("Ex_16_Galaxy40-[Column join on data 33, data 30, and others].tabular",
                         header = TRUE, row.names = 1, sep = "\t")

# 2. Usunięcie niepotrzebnych końcówek z nazw kolumn
colnames(raw_counts) <- gsub("\\.(bam|fastq|fastq\\.gz)$", "", colnames(raw_counts))

# 3. Określenie próbek WT i MT na podstawie nazw kolumn
WT <- grep("^WT", colnames(raw_counts), value = TRUE)
MT <- grep("^MT", colnames(raw_counts), value = TRUE)

# 4. Nadanie prostych nazw kolumn: WT_rep1, WT_rep2, MT_rep1, MT_rep2
new_colnames <- c("WT_rep1", "WT_rep2", "MT_rep1", "MT_rep2")
counts <- raw_counts[, c(WT, MT)]
colnames(counts) <- new_colnames

# 5. Tworzenie ramki metadanych coldata
condition <- factor(c(rep("WT", 2), rep("MT", 2)))
coldata <- data.frame(row.names = colnames(counts),
                      condition = condition)

# 6. Usunięcie wersji Ensembl ID z nazw wierszy
ensembl_ids <- rownames(counts)
no_ensembl_ids <- gsub("\\..*$", "", ensembl_ids)
rownames(counts) <- no_ensembl_ids

# 7. Podejrzenie wyników
head(counts)
head(coldata)

# 8. Zapis do pliku .csv
write.csv(counts, file = "counts_matrix.csv")
