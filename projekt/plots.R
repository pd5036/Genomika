library(DESeq2)
library(EnhancedVolcano)
library(ggplot2)

dds_filtered <- readRDS("dds_filtered.rds")
results_filtered <- readRDS("results_filtered.rds")

# 1. MA-plot
png("qc/MA_plot.png", width = 900, height = 700)
plotMA(results_filtered, ylim = c(-8, 8),
       main = "MA-plot: SARS-CoV-2 (MT) vs Mock (WT)")
dev.off()

# 2. Volcano plot
png("qc/volcano_plot.png", width = 1000, height = 900)
print(EnhancedVolcano(results_filtered,
    lab = rownames(results_filtered),
    x = 'log2FoldChange',
    y = 'padj',
    title = 'SARS-CoV-2 vs Mock (A549)',
    subtitle = 'DESeq2 (bez MT_rep1)',
    pCutoff = 0.05,
    FCcutoff = 1,
    pointSize = 2.0,
    labSize = 3.0))
dev.off()

# 3. Heatmap top 30 najbardziej istotnych genów
library(pheatmap)
vsd <- vst(dds_filtered, blind = FALSE)
res_ordered <- results_filtered[order(results_filtered$padj), ]
top_genes <- rownames(res_ordered)[1:30]

mat <- assay(vsd)[top_genes, ]
mat_scaled <- t(scale(t(mat)))  # standaryzacja per gen (z-score)

annotation_col <- data.frame(condition = colData(dds_filtered)$condition)
rownames(annotation_col) <- colnames(mat_scaled)

png("qc/heatmap_top30.png", width = 800, height = 1000)
pheatmap(mat_scaled,
         annotation_col = annotation_col,
         show_rownames = TRUE,
         cluster_cols = TRUE,
         main = "Top 30 DEG (z-score, VST)")
dev.off()

cat("Wykresy zapisane: qc/MA_plot.png, qc/volcano_plot.png, qc/heatmap_top30.png\n")
