#!/bin/bash
BAM_PATH=$1
GTF_PATH=$2
OUT_PATH=$3

#STAR's output BAM header contains list of all transcript IDs
TX_IDS=$(samtools view -H ${BAM_PATH} | awk '{print $2}' | cut -c 4-)

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
	echo "${TX}\t${GENE_ID}\t${GENE_LENGTH}" >> tmp.txt
done

#run the python script
python mainfile.py ${BAM_PATH} ${OUT_PATH}

#delete the temp file
rm tmp.txt



