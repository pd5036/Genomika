library(clusterProfiler)
library(org.Hs.eg.db)
library(ggplot2)

res_annotated <- readRDS("res_annotated.rds")

# Lista istotnych DEG (padj < 0.05) z Entrez ID
sig_genes <- res_annotated[!is.na(res_annotated$padj) & res_annotated$padj < 0.05, ]
cat("Liczba istotnych DEG do analizy GO/KEGG:", nrow(sig_genes), "\n")

entrez_ids <- na.omit(sig_genes$entrez_id)
cat("Liczba genów z prawidłowym Entrez ID:", length(entrez_ids), "\n")

# Tło (universe) - wszystkie testowane geny, nie tylko istotne
background_entrez <- na.omit(res_annotated$entrez_id[!is.na(res_annotated$padj)])

# ==== Analiza GO (Biological Process) ====
ego <- enrichGO(gene = entrez_ids,
                 universe = background_entrez,
                 OrgDb = org.Hs.eg.db,
                 keyType = "ENTREZID",
                 ont = "BP",                  # Biological Process
                 pAdjustMethod = "BH",
                 pvalueCutoff = 0.05,
                 qvalueCutoff = 0.2,
                 readable = TRUE)

cat("\n=== TOP 15 wzbogaconych procesów biologicznych (GO:BP) ===\n")
print(head(as.data.frame(ego), 15))

write.table(as.data.frame(ego), "GO_BP_enrichment.tabular", sep = "\t", quote = FALSE, row.names = FALSE)

# Wykres dotplot dla GO
if (nrow(as.data.frame(ego)) > 0) {
    png("qc/GO_dotplot.png", width = 1000, height = 800)
    print(dotplot(ego, showCategory = 15) + ggtitle("Wzbogacenie GO: Biological Process"))
    dev.off()
}

# ==== Analiza KEGG ====
ekegg <- enrichKEGG(gene = entrez_ids,
                     universe = background_entrez,
                     organism = "hsa",
                     pAdjustMethod = "BH",
                     pvalueCutoff = 0.05,
                     qvalueCutoff = 0.2)

cat("\n=== TOP 15 wzbogaconych ścieżek KEGG ===\n")
print(head(as.data.frame(ekegg), 15))

write.table(as.data.frame(ekegg), "KEGG_enrichment.tabular", sep = "\t", quote = FALSE, row.names = FALSE)

if (nrow(as.data.frame(ekegg)) > 0) {
    png("qc/KEGG_dotplot.png", width = 1000, height = 800)
    print(dotplot(ekegg, showCategory = 15) + ggtitle("Wzbogacenie ścieżek KEGG"))
    dev.off()
}

saveRDS(ego, "ego_result.rds")
saveRDS(ekegg, "ekegg_result.rds")

cat("\nKrok zakończony.\n")
