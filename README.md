# tranquant

This tool is implemented on the model of RSEM, which can take in a set of RNA-seq reads aligned to a transcriptome and output a table of genes (labeled by gene ID) with all transcripts found in the dataset (labeled by transcript ID) followed by gene expression metrics like R/FPKM and TPM. This tool is not designed to work with paired-end datasets, so if downloading from NCBI's SRA archive make sure that for your dataset the "Layout" is "SINGLE", or search specifically for such datasets with the query string "single[Layout]".

# Installation and preprocessing.

Clone this repository to get started.

This tool requires python and the pandas library, install python and then use pip to install pandas.

`pip install pandas`

Like RSEM, this requires that the fastq RNA-seq reads be aligned by a program like STAR, in order to produce a BAM file. If you are not starting out with such a file, it is sufficient to install STAR with 

`conda install -c bioconda star`

from within a dedicated conda environment. Consult the following document for commands to create a conda environment.

https://docs.conda.io/projects/conda/en/4.6.0/_downloads/52a95608c49671267e40c689e0bc00ca/conda-cheatsheet.pdf 

In order to create an index of the genome, STAR requires a lot of RAM (20 GB+) and disk space for its temporary files. Please check to make sure you have enough of both before doing either of the following two options. 

1. If you want to run the tool with the example reference genome (GRCm38.p6) and dataset (SRR20982309) used for benchmarking, cd to workspace/ and run this script. Wait for all steps to complete, and there will be a "resultsAligned.toTranscriptome.out.bam" in the workspace/ directory.

`./generate_bam_example.sh`

These files are unfortunately too big to be included in the github repository. If you prefer, the example reference genome can be manually downloaded at: https://nov2020.archive.ensembl.org/Mus_musculus/Info/Index
Similarly, the example RNAseq data can be downloaded at:
https://www.ncbi.nlm.nih.gov/sra/SRX16999863[accn]

2. If you already have a reference genome, GTF annotation file, and dataset prepared, run the following script with the following arguments. Wait for all steps to complete, and there will be a "resultsAligned.toTranscriptome.out.bam" in the workspace/ directory.

`./generate_bam_from_genome.sh [path to reference genome] [path to GTF file] [path to FASTQ of RNAseq data]`

This last option assumes you already have a STAR index.

3. Run the following script with the following arguments. Wait for all steps to complete, and there will be a "resultsAligned.toTranscriptome.out.bam" in the workspace/ directory.

`./generate_bam_from_index.sh [path to STAR index directory] [path to FASTQ of RNAseq data]

# Usage

Now that you have a "resultsAligned.toTranscriptome.out.bam," all this tool needs is that, a copy of the GTF gene annotation file, and the name of the output directory to which it will output its intermediary files and final result, "example.genes.results". 

`./tranquant.sh [path to RNA seq BAM] [path to GTF] [name of output directory]`

The output directory's intermediary files are as follows:

1. tx_list.txt: A list of all transcripts (labeled by their Ensembl transcript IDs) that occur at least once in the dataset, as identified by STAR.

2. gtf_transcripts.txt: Column 1 contains all unique Ensembl transcript IDs in the GTF gene annotation file. Column 2 names the gene (by its Ensembl gene ID) that this transcript is produced from.

3. gtf_genes.txt: Column 1 contains all unique Ensembl gene IDs in the GTF annotation file. Column 2 contains a measure of the length, as calculated by subtracting its start position from its end position and adding 1. 

The output directory's results file, "example.genes.results", has column names in row 1. Still, the columns and their meaning are listed here.

Column 1: Ensembl gene IDs. If a transcript of this gene was found in the RNAseq dataset, it will be included here.

Column 2: All the transcripts found for that gene in this dataset, named by their Ensembl transcript IDs.

Column 3: length of the gene.

Column 6: TPM, Column 7: RPK, Column 8: RPKM. These metrics are better described here:

https://wiki.arrayserver.com/wiki/index.php?title=TPM_and_FPKM
