import sys
import pandas as pd

bam_df = pd.read_csv("tmp_bam.txt", sep='\t',header=["transcript_id"])
tmp_df = pd.read_csv("tmp.txt", sep='\t', header=["transcript_id", "gene_id", "gene_length"])
print(bam_df.columns)
print(tmp_df.columns)

output_df = pd.DataFrame(columns=["gene_id", "transcript_id(s)", "length", "effective_length","expected_count", "TPM", "RPKM"])


#something like O(n) time across all 4m reads
#step 1: be able to group up transcripts based on what genes they are from-- prob w/ dictionary(ies)
#samtools view -H gives all unique transcript names-- can make gene dictionary off that

    #step 0: count lines in headerless sam to find total # of reads sequenced... can count this while grouping transcripts
#step 2: while doing the above, it would be nice to keep track: # reads mapping to gene i (so, some kind of running count, per gene)
#step 3: in process of retreiving genes above, also need to find gene length (length of read or length of reference?)


#O(n) across the much smaller number of genes
#step 4: RPKM for each gene, and add each one to sum for below
#step 5: S = sum of RPKMs / 1 million
#step 6: TPM for each gene, it's the RPKM for that gene / S

output_df.to_csv(path_or_buf="{0}.genes.results".format(sys.argv[1], sep='\t', header=True))
