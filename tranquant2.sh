#!/bin/bash
BAM_PATH=$1
GTF_PATH=$2
OUT_PATH=$3

#delete the temp files
rm tx_list.txt
rm tx_hist.txt
rm tx_to_gene.txt
rm gene_lengths.txt

echo "extract and count reads from bam $(date)"

#get all the transcripts out of the bam
samtools view ${BAM_PATH} | awk '{print $3}' > tx_list.txt

#script to produce two column file: unique reads, & how many times they appear
python tx_hist.py

#TX_IDS=$(samtools view -H ${BAM_PATH} | awk '{print $2}' | cut -c 4-)
#TX_IDS=$(awk '{print $1}' tx_hist.txt)
echo "match reads to genes $(date)"
GENE_IDS=()

#for each transcript...
awk '$3=="transcript" {print $14, $10}' ${GTF_PATH} > gtf_transcripts.txt

#exit 0

for LINE in $(cat tx_hist.txt)
do
    TX=$(echo -e ${LINE} | awk '{print $1}')
    NUM_OCCURRENCES=$(echo -e ${LINE} | awk '{print $2}')
	#find the corresponding gene-- if we can't move on
	GENE_STRING=$(grep ${TX} gtf_transcripts.txt)
	if [ $? -ne 0 ]; then #if exit code is error...
		#if we can't find transcript ID in gtf, discard
		#echo -e "${TX}\tno-gene-found\t-1" >> tmp.txt
		continue 1
	fi
	GENE_ID=$(echo -e "${GENE_STRING}" | awk '{print $2}' | cut -c 2-19)
	
    #if the gene is not already in our list, add it
	grep ${GENE_ID} gene_length.txt > /dev/null 2>&1
    if [ $? -ne 0 ]; then
		#add to output log
	    echo -e "${TX}\t${NUM_OCCURRENCES}\t${GENE_ID}" >> tx_to_gene.txt
        GENE_IDS+=( ${GENE_ID} )
	fi
done

echo "calculate lengths of genes $(date)"

awk '$3=="gene" {print 10, $5 - $4 + 1}' > gtf_genes.txt 
for GENE_ID in ${TX_IDS}
do
    #find difference between gene's start and end points, although this may include noncoding introns
	GENE_LENGTH=$(grep ${GENE_ID} ${GTF_PATH} | awk {print $2}')
	echo -e "${GENE_ID}\t${GENE_LENGTH}" >> gene_lengths.txt
done

echo "begin python script $(date)"
#run the python script
python mainfile.py ${OUT_PATH}

echo "cleanup $(date)"
#delete the temp files
rm tx_list.txt
rm tx_hist.txt
rm tx_to_gene.txt
rm gene_lengths.txt



