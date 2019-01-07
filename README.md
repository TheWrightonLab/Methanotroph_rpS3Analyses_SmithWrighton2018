ReadMe file for data generation and analysis described in the publication titled "Metagenomic approaches unearth methanotroph phylogenetic and metabolic diversity" released simultaneously in a focus issue of Current Issues in Molecular Biology (https://doi.org/10.21775/9781912530045.03, ISSN 1467-3037 [print]; ISSN 1467-3045 [electronic]) and book by Caister Academic Press.



File Inventory

README.txt
This file.
Holds information about the other files in this data package.

MetaGANDMethanotroph_rpS3_Metadata.xlsx
List of metagenomes available on IMG/MER (https://img.jgi.doe.gov/cgi-bin/mer/main.cgi) that were publicly available prior to 1st of June 2016 that were mined for methanotroph rps# genes, and metadata for compiled (meta)genomic information that includes methanotrophic isolates, metagenome-assembled genomes, and single genes from the mined metagnomes.
Sheet1 contains legend. The Sheet2 is the IMG/M metagnome table for the queried metagenomes. Sheet3 contains the metadata for each ribosomal protein S3 (rpS3) gene and respective (meta)genome and isolate or metagenome-assembled genomes without rpS3 genes. Note that altered metadata, either inferred from available data or modified for simplification of analysis, is colored red. Outgroup sequences are indicated by orange highlighting, but no metadata is provided.
In Sheet3, some rpS3 genes were only accesible from untranslated genomic sequences and appear as:
tpg|DAJM01000034.1|:c27352-26471
gi|1331056477|gb|PDZR01000019.1|:17097-17816
gb|PLAI01000238.1|:4787-5466
gb|PLZT01000613.1|:14847-15028
gb|PMPT01000294|:3605-4284
gb|PKZX01000153|:5952-6631
gb|PMGC01000175|:6245-6924
gb|PMFK01000378|:3755-4434
gb|PLVF01000413|:14750-15429
tpg|DHHX01000073.1|:c16245-15607
gi|1320930125|gb|PHSQ01000001.1|:950615-951342
gi|1343553618|gb|PERJ01000006.1|:5451-6199
gi|1343536416|gb|PERD01000024.1|:4244-4993
gb|PLUZ01000289.1|:7834-8055
gb|PMBZ01000225.1|:11886-12535
gi|1148888542|gb|MSCV01000025.1|:88299-88921
gi|1190773396|gb|MUGL01000068.1|:288729-289351
tpg|DCZF01000042.1|:c266862-266236
tpg|DKIS01000088.1|:3484-4152
tpg|DLHW01000014.1|:125762-126421
gi|1320930128|gb|PHSP01000003.1|:240559-241230
tpg|DEII01000144.1|:3498-4124
tpg|DEZR01000019.1|:2977-3645
tpg|DFWO01000060.1|:c11071-10406
tpg|DIAT01000033.1|:c11292-10627
tpg|DIUY01000016.1|:3456-4124
tpg|DCBF01000057.1|:4304-4963
tpg|DBZZ01000025.1|:c37317-36691
tpg|DEIG01000025.1|:19986-20612
tpg|DBBV01000017.1|:c289193-288552
gi|1200355592|gb|NHDW01000004.1|:387524-388138
gi|1124896005|gb|MRWO01000592.1|:3040-3747
gi|1269174687|gb|NSJM01000016.1|:2901-3608
tpg|DBTH01000073.1|:c6042-5416
These are as retrieved from NCBI's BLASTn output, which includes the (meta)genomic accession within the pipes ( | characters) followed by the nucleotide positions after the colon with reverse complementation indicated by a "c" preceding the positions. For example, tpg|DAJM01000034.1|:c27352-26471 denotes the NCBI Nucleotide accession (DAJM00000000, version 1, #34 out of 72 entries in the whole genome shotgun sequence assembly records) at bases 26471-27352 with the reading frame in the reverse orientation. These genes were translated in Geneious (version 7.0.9).
In Sheet3, there are two sets of comparisons between genes and genomes, all columns headers included "IsolateRef" or "GenomeRef". "IsolateRef" refers to BLASTp analysis of unmodified ribosomal protein S3 (rpS3) amino acid sequences of any metagenome derived gene (mined single genes or metagenome-assembled genomes) against isolate genomes, and "GenomeRef" refers to similar analysis comparing mined metagenomic rpS3 amino acids to any methanotroph genome (metagenome-assembled and isolate genomes).
Genes were mined from the metagenomes available on IMG/M listed in Sheet2` using BLASTp with an e-value cutoff of -50. Returned rpS3 genes were removed in less than 180 amino acids, low percent identity with reference sequences, branching distant from known methanotrophic taxa, or greater similarity with non-methanotrophs when queried to NCBI using BLASTp.

Methanotroph_rpS3_Sequences.fasta
Translated isolate, metagenome-assembled, and mined single metagenomic ribosomal protein S3 (rpS3) genes of known methanotrophs or putatively affiliated with known methanotrophs.
Headers for each sequence link to the first column in the third sheet of "MetaGANDMethanotroph_rpS3_Metadata.xlsx" and the first column of "Methanotroph_rpS3_Metadata.csv".

Methanotroph_rpS3_Alignment.fasta
Raw alignment of  "Methanotroph_rpS3_Sequences.fasta" generated using MUSCLE in Geneious (version 7.0.9)

Methanotroph_rpS3_Modified_Alignment.fasta
Manually modified version of "Methanotroph_rpS3_Alignment.fasta". Highly gapped regions, positions that lacked a residue on >70% of sequences or obviously specific to one major clade, were removed to maintain the integrity of phylogenetic inferences. 

Methanotroph_rpS3_Tree_Command.txt
Exact command used to reconstruct phylogeny from "Methanotroph_rpS3_Modified_Alignment.fasta" using RAxML (https://sco.h-its.org/exelixis/web/software/raxml/index.html). The GAMMA model of rate heterogeneity and WAG substitution matrix were used (-m PROTGAMMAWAG), and 100 bootstrap replicates were performed (-N 100).

Methanotroph_rpS3_Modified_Alignment_RAxML
Unmodified newick format RAxML output from the command in "Methanotroph_rpS3_Tree_Command.txt".

Methanotroph_rpS3_Metadata.csv
Metadata information matching the third sheet in "MetaGANDMethanotroph_rpS3_Metadata.xlsx" for use in R.

MethanotrophS3Analyses.R
R script (R version 3.3.2 [2016-10-31] -- "Sincere Pumpkin Patch"; Platform: x86_64-apple-darwin13.4.0 [64-bit]) for performing analyses and generating the figures. 
Little to no modifications should be necessary to recreate the analyses and figures. Figure recreation was verified on independent Apple computers and with fully updated packages (1st of August 2018). Figures were refined for publication using Adobe Illustrator.



Co-corresponding authors:

Smith, Garrett
Department of Microbiology, College of Arts and Sciences, The Ohio State University
Columbus, Ohio, 43210
Email: smith.10284@osu.edu

Wrighton, Kelly
Department of Soil and Crop Science, College of Agricultural Sciences, Colorado State University
Fort Collins, Colorado, 80523 
Email: Kelly.Wrighton@colostate.edu
Phone: 9709992261
