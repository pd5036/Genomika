Analiza RNA-seq: A549 Mock vs SARS-CoV-2 (GSE147507)
Projekt zaliczeniowy — Bioinformatyka w genomice i transkryptomice.
Ścieżka: transkryptomiczna.
Zbiór danych
Źródło: GSE147507 (Blanco-Melo i wsp., Cell 2020), Series 5
Materiał: ludzkie komórki nabłonka płuc A549 (bez wektora ACE2)
Warunki: Mock (kontrola, WT) vs SARS-CoV-2 MOI 2.0 (MT), 3 powtórzenia biologiczne/grupę
Numery SRA:
Mock/WT: `SRR11412215`, `SRR11412216`, `SRR11412217`
SARS-CoV-2/MT: `SRR11412218`, `SRR11412219`, `SRR11412220`
Typ danych: RNA-seq, single-end, Illumina NextSeq 500
Genom referencyjny: GRCh38, adnotacja Ensembl release 111
Pełny opis metodyki, wyników i interpretacji biologicznej: Pd5036 Łukasz KRZOWSKI.docx.
Struktura repozytorium
```
.
download.sh                      # pobranie i przygotowanie surowych danych z SRA
fastqc.sh                        # Krok 1: kontrola jakości surowych odczytów (FastQC)
multiqc.sh                       # Krok 1: zbiorczy raport jakości (MultiQC)
trim_adapters.sh                 # Krok 2: wycinanie adapterów (Cutadapt)
qc.sh                            # Krok 3: ponowna kontrola jakości po przycięciu
star.sh                          # Krok 4: indeksowanie genomu (STAR)
mapping.sh                       # Krok 4: mapowanie próbek (STAR)
infer.sh                         # Krok 6: typ biblioteki RNA (RSeQC infer_experiment)
featurecounts.R                  # Krok 7: macierz zliczeń (Rsubread)
deseq2.R, deseq2_2.R             # Krok 8: przygotowanie danych + analiza DESeq2
deseq2_diag.R                    # Krok 8: diagnostyka i analiza wrażliwości (PCA, dyspersja)
plots.R                          # Krok 8: MA-plot, volcano plot, heatmap
annot.R                          # Krok 9: adnotacja funkcjonalna (org.Hs.eg.db)
top.R                            # Krok 9: geny wg wielkości efektu
kegg.R                           # Krok 10: analiza GO/KEGG (clusterProfiler)

counts_matrix.tabular            # macierz zliczeń (geny x próbki)
deseq_results_full.tabular       # pełne wyniki DESeq2 (6 próbek)
deseq_results_filtered.tabular   # wyniki DESeq2 po filtrowaniu (padj<0.05)
deseq_results_sensitivity_full.tabular  # wyniki DESeq2 (5 próbek, bez próbki odstającej)
deseq_results_annotated.tabular  # wyniki z adnotacją funkcjonalną
top20_DEG_annotated.tabular      # 20 najbardziej istotnych DEG
top_DEG_by_effect_size.tabular   # DEG posortowane wg wielkości efektu (|log2FC|)
GO_BP_enrichment.tabular         # wzbogacenie Gene Ontology (Biological Process)
KEGG_enrichment.tabular          # wzbogacenie ścieżek KEGG

pca_plot.png                     # PCA próbek (diagnostyka)
dispersion_plot.png              # wykres dyspersji DESeq2
MA_plot.png                      # MA-plot (Krok 8)
volcano_plot.png                 # volcano plot (Krok 8)
heatmap_top30.png                # heatmap top 30 DEG (Krok 8)
GO_dotplot.png                   # wzbogacenie GO (Krok 10)
KEGG_dotplot.png                 # wzbogacenie KEGG (Krok 10)

Pd5036 Łukasz KRZOWSKI.docx      # pełna dokumentacja/sprawozdanie z projektu
README.md                        # ten plik
```
```
Genom referencyjny (GRCh38, Ensembl release 111) i adnotacja GTF pobierane są
automatycznie w skrypcie `star.sh` z serwerów Ensembl.
Środowisko
Analiza wykonana z użyciem środowisk conda:
`FastQC`, `MultiQC`, `SRA_tools_fix`, `cutadapt_env`, `trimmomatic_env`
`mapping` (STAR, samtools), `rseqc_env` (RSeQC)
`rnaseq_R` (R 4.3.3: Rsubread, DESeq2, clusterProfiler, org.Hs.eg.db, EnhancedVolcano, pheatmap)
`igv_env` (wizualizacja)
Wizualizacja IGV
Zrzut ekranu regionu genu MX1 (chr21) z widocznym wyższym pokryciem i częstszymi
złączeniami splicingowymi w próbkach zakażonych (MT) względem kontroli (WT) —
patrz Pd5036 Łukasz KRZOWSKI.docx, sekcja "Krok 5".