# Wczytanie macierzy zliczeń
raw_counts <- read.table("counts_matrix.tabular", sep = "\t", header = TRUE,
                          row.names = 1, check.names = FALSE, stringsAsFactors = FALSE)

# Sprawdzenie wczytanych danych
cat("Wymiary macierzy:", dim(raw_counts), "\n")
cat("Nazwy kolumn:", colnames(raw_counts), "\n")

# Kolumny są już w kolejności WT_rep1-3, MT_rep1-3 (ustawione w Kroku 7)
counts <- raw_counts

# Określenie warunków eksperymentu
condition <- factor(c(rep("WT", 3), rep("MT", 3)))

# Przygotowanie ramki danych coldata
coldata <- data.frame(
    sample_name = colnames(counts),
    condition = condition,
    row.names = colnames(counts)
)

print(coldata)

# Usunięcie numerów wersji z Ensembl ID (np. ENSG00000279928.1 -> ENSG00000279928)
ensembl_ids <- rownames(counts)
no_ensembl_ids <- gsub("\\..*$", "", ensembl_ids)
rownames(counts) <- no_ensembl_ids

cat("Przykładowe ID po czyszczeniu:", head(rownames(counts)), "\n")

# Zapis obiektów do wykorzystania w kolejnym skrypcie
saveRDS(counts, "counts_clean.rds")
saveRDS(coldata, "coldata.rds")

cat("zakończony - dane przygotowane.\n")
