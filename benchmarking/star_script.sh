STARDIR=STAR_index
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

STAR \
    --runThreadN 5 \
    --genomeDir ${STARDIR} \
    --readFilesIn rnaseq_data/SRR23147610.fastq \
    --outFileNamePrefix SRR23147610 \
    --outSAMtype BAM SortedByCoordinate \
    --quantMode TranscriptomeSAM ${STAROPTS}
    # Reorganize the output files
#mv ${OUTDIR}/${f}Aligned.toTranscriptome.out.bam ${OUTDIR}/txBams/
#mv ${OUTDIR}/${f}Aligned.sortedByCoord.out.bam ${OUTDIR}/genomeBams/
samtools index SRR23147610Aligned.sortedByCoord.out.bam