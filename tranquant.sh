#!/bin/bash
BAM_PATH=$1
GTF_PATH=$2
OUT_PATH=$3

operand1=$(echo ${BAM_PATH} | rev | cut -c 1-3 | rev)
operand2="bam"
if [ ${operand1} != ${operand2} ]
then
	echo "[Error] provided bam file doesn't end in suffix bam"
	exit 1
fi

echo "$(date) | extract from bam"
#get all the transcripts OF SEED LENGTH (25) OR ABOVE out of the bam
samtools view ${BAM_PATH} | awk 'length($10)>=25 {print $3}' > ${OUT_PATH}/tx_list.txt

operand1=$(echo ${GTF_PATH} | rev | cut -c 1-3 | rev)
operand2="gtf"
if [ ${operand1} != ${operand2} ]
then
	echo "[Error] provided gtf file doesn't end in suffix gtf"
	exit 1
fi

echo "$(date) | find source genes of transcripts in gtf"
awk '$3=="transcript" {print $14, $10}' ${GTF_PATH} > ${OUT_PATH}/gtf_transcripts.txt

echo "$(date) | calculate lengths of genes in gtf"
awk '$3=="gene" {print $10, ($5 - $4 + 1)}' ${GTF_PATH} > ${OUT_PATH}/gtf_genes.txt 

echo "$(date) | begin python script"
#script to produce two column file: unique reads, & how many times they appear
#script to assign origin genes to each unique transcript & find that gene's length
#script to finish calculating quantification metrics & output final file
python tx_hist.py ${OUT_PATH}
#python mainfile.py ${OUT_PATH}


