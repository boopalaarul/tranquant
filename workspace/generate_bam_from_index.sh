#!/bin/bash

STARDIR=$1
FASTQ=$2

# STAR options recommended by ENCODE
STAROPTS="--outSAMattributes NH HI AS NM MD \
    --outFilterType BySJout \
    --outFilterMultimapNmax 20 \
    --outFilterMismatchNmax 999 \
    --outFilterMismatchNoverReadLmax 0.04 \
    --alignIntronMin 20 \
    --alignIntronMax 1000000 \
    --alignMatesGapMax 1000000 \
    --alignSJoverhangMin 8 \
    --alignSJDBoverhangMin 1 \
    --sjdbScore 1 \
    --limitBAMsortRAM 50000000000"

mkdir STAR_results
STAR \
    --runThreadN 5 \
    --genomeDir ${STARDIR} \
    --readFilesIn ${FASTQ} \
    --outFileNamePrefix STAR_results/results \
    --outSAMtype BAM SortedByCoordinate \
    --quantMode TranscriptomeSAM ${STAROPTS}
    # Reorganize the output files
mv STAR_results/resultsAligned.toTranscriptome.out.bam .
#mv ${OUTDIR}/${f}Aligned.sortedByCoord.out.bam ${OUTDIR}/genomeBams/
#samtools index SRR20982309Aligned.sortedByCoord.out.bam
