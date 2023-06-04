RSEMINDEX=$1/RSEM
BAM=$2
#rsem-prepare-reference \
#    --gtf ${GTF} ${REFFA} ${RSEMOUT}
mkdir RSEM_results
rsem-calculate-expression \
    -p 5 \
    --fragment-length-mean -1 \
    --seed-length 25 \
    --bam ${BAM} \
    ${RSEMINDEX} \
    RSEM_results/example \
    >RSEM_results/log.out 2>RSEM_results/log_warn_error.out
