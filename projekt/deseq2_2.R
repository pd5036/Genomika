library(DESeq2)

# Wczytanie przygotowanych danych z 
counts <- readRDS("counts_clean.rds")
coldata <- readRDS("coldata.rds")

# Utworzenie obiektu DESeqDataSet
dds <- DESeqDataSetFromMatrix(countData = counts,
                                colData = coldata,
                                design = ~ condition)

# Wykonanie analizy różnicowej ekspresji
dds2 <- DESeq(dds)

# Wyniki z odwróconym porównaniem - MT vs WT (zakażone vs kontrola)
deseq_results <- results(dds2, contrast = c("condition", "MT", "WT"))

# Podsumowanie wyników
summary(deseq_results)
head(deseq_results)

# Zapis pełnych wyników (przed filtrowaniem)
write.table(as.data.frame(deseq_results), "deseq_results_full.tabular",
            sep = "\t", quote = FALSE, col.names = NA)

# Filtrowanie wyników istotnych statystycznie (padj < 0.05, |log2FC| > 2)
filtered_results <- deseq_results[which(deseq_results$padj < 0.05 &
                                          abs(deseq_results$log2FoldChange) > 2), ]

cat("\nLiczba istotnych statystycznie DEG (padj<0.05, |log2FC|>2):", nrow(filtered_results), "\n")

# Zapis wyników po filtrowaniu
write.table(as.data.frame(filtered_results), "deseq_results_filtered.tabular",
            sep = "\t", quote = FALSE, col.names = NA)

# Zapis obiektów do dalszej analizy (adnotacja, GO/KEGG)
saveRDS(dds2, "dds2.rds")
saveRDS(deseq_results, "deseq_results.rds")

cat("zakończony.\n")
