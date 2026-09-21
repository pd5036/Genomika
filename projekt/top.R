res_annotated <- readRDS("res_annotated.rds")

# Tylko geny istotne statystycznie
sig_genes <- res_annotated[!is.na(res_annotated$padj) & res_annotated$padj < 0.05, ]

# TOP 15 wg wielkości efektu (|log2FC|), nie samej p-wartości
top_by_fc <- sig_genes[order(-abs(sig_genes$log2FoldChange)), ]
cat("=== TOP 15 istotnych DEG wg WIELKOŚCI EFEKTU (|log2FC|) ===\n")
print(head(top_by_fc[, c("external_gene_name", "log2FoldChange", "padj", "description")], 15))

# Sprawdźmy konkretnie geny odpowiedzi interferonowej/przeciwwirusowej
isg_symbols <- c("IFIT1", "ISG15", "OAS1", "MX1", "IFI6", "CXCL10", "IFIT2", "IFIT3", "IFI27", "IRF7")
isg_in_results <- res_annotated[res_annotated$external_gene_name %in% isg_symbols & !is.na(res_annotated$external_gene_name), ]
cat("\n=== Geny odpowiedzi interferonowej (ISG) w wynikach ===\n")
print(isg_in_results[, c("external_gene_name", "log2FoldChange", "padj")])

write.table(top_by_fc, "top_DEG_by_effect_size.tabular", sep = "\t", quote = FALSE, row.names = FALSE)
