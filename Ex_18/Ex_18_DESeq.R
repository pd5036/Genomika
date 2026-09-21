# Ex18 pd5036 Lukasz KRZOWSKI

# DESeq2 – analiza różnicowa

# Instalacja i uruchomienie pakietów
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

    BiocManager::install("biomaRt")
    BiocManager::install("DESeq2")
 
    library(biomaRt)
    library(DESeq2)

# Połączenie z bazą Ensembl
    mart_connection <- useMart("ensembl", dataset = "hsapiens_gene_ensembl")

# Pobranie atrybutów dla genów z macierzy counts
    gen <- getBM(attributes = c("ensembl_gene_id", 
                            "hgnc_symbol", 
                            "chromosome_name", 
                            "start_position", 
                            "percentage_gene_gc_content", 
                            "gene_biotype", 
                            "description",
                            "entrezgene_id"),
                  filters = "ensembl_gene_id",
                   values = rownames(counts),
                     mart = mart_connection)

# Utworzenie obiektu DESeq2 i analiza różnicowa ekspresji
    dds <- DESeqDataSetFromMatrix(countData = counts,
                              colData = coldata,
                              design = ~ condition)

    dds2 <- DESeq(dds)

# Wyniki analizy
    deseq_results <- results(dds2)
    head(deseq_results)
    write.csv(as.data.frame(deseq_results), file = "deseq2_results.csv")