#!/bin/bash

#makes directory to store example genome and GTF: mouse
mkdir ref_genomes
wget -O ref_genomes/GRCm38.fa.gz http://ftp.ensembl.org/pub/release-102/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz
gunzip ref_genomes/GRCm38.fa.gz
wget -O ref_genomes/GRCm38.102.gtf.gz http://ftp.ensembl.org/pub/release-102/gtf/mus_musculus/Mus_musculus.GRCm38.102.gtf.gz
gunzip ref_genomes/GRCm38.102.gtf.gz
#makes directory to store example data
mkdir rnaseq_data
wget -O rnaseq_data/SRR23147610.fastq.gz https://trace.ncbi.nlm.nih.gov/Traces/sra-reads-be/fastq?acc=SRR23147610
gunzip rnaseq_data/SRR23147610.fastq.gz

./generate_bam_from_genome.sh ref_genomes/GRCm38.fa ref_genomes/GRCm38.102.gtf rnaseq_data/SRR23147610.fastq
