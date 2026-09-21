library(DESeq2)

dds2 <- readRDS("dds2.rds")

# Transformacja stabilizująca wariancję (do wizualizacji)
vsd <- vst(dds2, blind = TRUE)

# Macierz odległości między próbkami 
sample_dists <- dist(t(assay(vsd)))
sample_dist_matrix <- as.matrix(sample_dists)
cat("=== Macierz odległości między próbkami ===\n")
print(round(sample_dist_matrix, 1))

# Współrzędne PCA 
pca_data <- plotPCA(vsd, intgroup = "condition", returnData = TRUE)
cat("\n=== Dane PCA ===\n")
print(pca_data)

# Ile wariancji tłumaczą PC1 i PC2
percentVar <- round(100 * attr(pca_data, "percentVar"))
cat("\nPC1:", percentVar[1], "% wariancji\n")
cat("PC2:", percentVar[2], "% wariancji\n")

# Zapisz wykres PCA do pliku PNG
png("qc/pca_plot.png", width = 800, height = 600)
library(ggplot2)
ggplot(pca_data, aes(PC1, PC2, color = condition, label = name)) +
    geom_point(size = 4) +
    geom_text(vjust = -1) +
    xlab(paste0("PC1: ", percentVar[1], "% variance")) +
    ylab(paste0("PC2: ", percentVar[2], "% variance")) +
    theme_minimal()
dev.off()

# Sprawdź surowe sumy zliczeń per próbka 
cat("\n=== Sumy zliczeń (colSums) ===\n")
print(colSums(counts(dds2)))

# Sprawdź współczynniki normalizacji 
cat("\n=== Size factors ===\n")
print(sizeFactors(dds2))

# Sprawdź rozkład dyspersji
png("qc/dispersion_plot.png", width = 800, height = 600)
plotDispEsts(dds2)
dev.off()

cat("\nDiagnostyka zakończona - sprawdź qc/pca_plot.png i qc/dispersion_plot.png\n")
