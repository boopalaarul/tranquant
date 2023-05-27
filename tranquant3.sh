#!/bin/bash
BAM_PATH=$1
GTF_PATH=$2
OUT_PATH=$3

#delete the temp files
rm tx_list.txt
rm tx_hist.txt
rm tx_to_gene.txt
rm gene_lengths.txt

echo "extract from bam $(date)"
#get all the transcripts out of the bam
samtools view ${BAM_PATH} | awk '{print $3}' > tx_list.txt

echo "find source genes of transcripts in gtf $(date)"
awk '$3=="transcript" {print $14, $10}' ${GTF_PATH} > gtf_transcripts.txt

echo "calculate lengths of genes in gtf $(date)"
awk '$3=="gene" {print 10, ($5 - $4 + 1)}' ${GTF_PATH} > gtf_genes.txt 

echo "begin python script $(date)"
#script to produce two column file: unique reads, & how many times they appear
#script to assign origin genes to each unique transcript & find that gene's length
#script to finish calculating quantification metrics & output final file
python tx_hist.py ${OUT_PATH}
#python mainfile.py ${OUT_PATH}

echo "cleanup $(date)"
#delete the temp files
rm tx_list.txt
rm tx_hist.txt
rm tx_to_gene.txt
rm gene_lengths.txt



