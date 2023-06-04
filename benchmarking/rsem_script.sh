#RSEMOUT=RSEM/RSEM
#rsem-prepare-reference \
#    --gtf ${GTF} ${REFFA} ${RSEMOUT}

rsem-calculate-expression \
    -p 5 \
    --fragment-length-mean -1 \
    --seed-length 25 \
    --bam SRR23147610Aligned.toTranscriptome.out.bam \
    ${RSEMOUT} \
    ../RSEM_results/SRR23147610