#!/bin/bash
BAM_PATH=$1
GTF_PATH=$2
OUT_PATH=$3

#STAR's output BAM header contains list of all transcript IDs
TX_IDS=$(samtools view -H ${BAM_PATH} | awk '{print $2}' | cut -c 4-)


#delete the temp files
rm tx_to_gene.txt
rm gene_length.txt
rm tmp_bam.txt

echo "begin assembling temp files $(date)"

#for each transcript...
for TX in ${TX_IDS}
do
	#find the corresponding gene-- if we can't move on
	GENE_STRING=$(grep ${TX} ${GTF_PATH})
	if [ $? -ne 0 ]; then
		#if we can't find transcript ID in gtf, discard
		#echo -e "${TX}\tno-gene-found\t-1" >> tmp.txt
		continue 1
	fi
	GENE_ID=$(echo "${GENE_STRING}" | awk '$3=="transcript" {print $10}' | cut -c 2-19)
	
	#find difference between gene's start and end points, although this may include noncoding introns
	GENE_LENGTH=$(grep ${GENE_ID} ${GTF_PATH} | awk '$3=="gene" {print $5 - $4 + 1}')

	#add to output log
	echo -e "${TX}\t${GENE_ID}" >> tx_to_gene.txt
	grep ${GENE_ID} gene_length.txt > /dev/null
	if [ $? -ne 0 ]; then
		echo -e "${GENE_ID}\t${GENE_LENGTH}" >> gene_length.txt
	fi
done


echo "begin exporting list of reads $(date)"
#give python an uncompressed BAM file... or really, just the transcript IDs, don't need the other data for expression quantification
samtools view ${BAM_PATH} | awk '{print $3}' > tmp_bam.txt

echo "begin python script $(date)"
#run the python script
python mainfile.py ${OUT_PATH}

echo "cleanup $(date)"
#delete the temp files
rm tx_to_gene.txt
rm gene_length.txt
rm tmp_bam.txt




