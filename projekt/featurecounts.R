library(Rsubread)

# Ścieżka do adnotacji GTF
adnotacja <- "reference/Homo_sapiens.GRCh38.111.gtf"

# Lista plików BAM (kolejność: WT, potem MT)
pliki_bam <- c(
    "mapped_data/WT_rep1_Aligned.sortedByCoord.out.bam",
    "mapped_data/WT_rep2_Aligned.sortedByCoord.out.bam",
    "mapped_data/WT_rep3_Aligned.sortedByCoord.out.bam",
    "mapped_data/MT_rep1_Aligned.sortedByCoord.out.bam",
    "mapped_data/MT_rep2_Aligned.sortedByCoord.out.bam",
    "mapped_data/MT_rep3_Aligned.sortedByCoord.out.bam"
)

# Zliczanie odczytów
zliczenia <- featureCounts(
    files = pliki_bam,
    annot.ext = adnotacja,
    isGTFAnnotationFile = TRUE,
    GTF.featureType = "exon",
    GTF.attrType = "gene_id",
    isPairedEnd = FALSE,        # dane single-end
    strandSpecific = 2,         # reverse-stranded, potwierdzone Infer Experiment
    nthreads = 4
)

# Zapisz surowe statystyki podsumowujące
write.table(zliczenia$stat, "qc/featurecounts_summary.txt", sep = "\t", quote = FALSE, row.names = FALSE)

# Przygotuj macierz zliczeń (geny x próbki)
macierz <- zliczenia$counts
colnames(macierz) <- c("WT_rep1", "WT_rep2", "WT_rep3", "MT_rep1", "MT_rep2", "MT_rep3")

# Zapisz macierz zliczeń do pliku
write.table(macierz, "counts_matrix.tabular", sep = "\t", quote = FALSE, col.names = NA)

cat("Krok 7 zakończony. Macierz zliczeń zapisana do counts_matrix.tabular\n")
cat("Wymiary macierzy:", dim(macierz), "\n")
