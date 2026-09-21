library(AnnotationDbi)
library(org.Hs.eg.db)

results_filtered <- readRDS("results_filtered.rds")

res_df <- as.data.frame(results_filtered)
res_df$ensembl_gene_id <- rownames(res_df)

res_df$external_gene_name <- mapIds(org.Hs.eg.db,
                                     keys = res_df$ensembl_gene_id,
                                     column = "SYMBOL",
                                     keytype = "ENSEMBL",
                                     multiVals = "first")

res_df$description <- mapIds(org.Hs.eg.db,
                              keys = res_df$ensembl_gene_id,
                              column = "GENENAME",
                              keytype = "ENSEMBL",
                              multiVals = "first")

res_df$entrez_id <- mapIds(org.Hs.eg.db,
                            keys = res_df$ensembl_gene_id,
                            column = "ENTREZID",
                            keytype = "ENSEMBL",
                            multiVals = "first")

res_annotated <- res_df[order(res_df$padj), ]

write.table(res_annotated, "deseq_results_annotated.tabular",
            sep = "\t", quote = FALSE, row.names = FALSE)

top20 <- head(res_annotated[!is.na(res_annotated$padj), ], 20)
cat("=== TOP 20 najbardziej istotnych DEG ===\n")
print(top20[, c("ensembl_gene_id", "external_gene_name", "log2FoldChange", "padj", "description")])

write.table(top20, "top20_DEG_annotated.tabular", sep = "\t", quote = FALSE, row.names = FALSE)

saveRDS(res_annotated, "res_annotated.rds")

cat("\n zakończony (adnotacja: org.Hs.eg.db).\n")
