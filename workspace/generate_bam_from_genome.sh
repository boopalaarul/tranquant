#!/bin/bash

#reference genome: 
#ref_genomes/GRCm38.fa in example
REFFA=$1
#gene annotations, exon-exon boundaries (where genes start and end): 
#ref_genomes/GRCm38.102.gtf ine xample
GTF=$2

FASTQ=$3

#output director for star's index files
mkdir STAR_index
STARDIR=STAR_index
STAR \
    --runMode genomeGenerate --genomeDir ${STARDIR} \
    --genomeFastaFiles ${REFFA} \
    --sjdbGTFfile ${GTF} \
    --sjdbOverhang 49

./generate_bam_from_index.sh ${STARDIR} ${FASTQ}
