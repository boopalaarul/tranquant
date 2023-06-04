#reference genome
REFFA=ref_genomes/GRCm38.fa
#gene annotations, exon-exon boundaries (where genes start and end)
GTF=ref_genomes/GRCm38.102.gtf
#output director for star's index files
STARDIR=STAR_index
STAR \
    --runMode genomeGenerate --genomeDir ${STARDIR} \
    --genomeFastaFiles ${REFFA} \
    --sjdbGTFfile ${GTF} \
    --sjdbOverhang 49
