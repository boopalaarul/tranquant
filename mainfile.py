import sys
import pandas as pd

bam_df = pd.read_csv("tmp_bam.txt", sep='\t', header=None, names= ["transcript_id"])
tx_to_gene_df = pd.read_csv("tx_to_gene.txt", sep='\t', header=None, index_col=0)
gene_length_df = pd.read_csv("gene_length.txt", sep='\t', header=None, index_col=0)

output_df = pd.DataFrame(columns=["gene_id", "transcript_id(s)", "length", "effective_length","expected_count", "RPK", "TPM", "RPKM"])

#something like O(n) time across all 4m reads
total_reads_sequenced = len(bam_df["transcript_id"])

#dictionary that allows counting of # reads mapping to each gene
number_reads_mapping = {}

#step 1: be able to group up transcripts based on what genes they are from-- prob w/ dictionary(ies)
#samtools view -H gives all unique transcript names-- can make gene dictionary off that
#all this was done by shell script earlier

#step 2: keep track: # reads mapping to gene i (so, some kind of running count, per gene)
for transcript in bam_df["transcript_id"]:
    try:
        gene_id = tx_to_gene_df.loc[tx_to_gene_df.loc[transcript][0]]
    except:
        continue

    number_reads_mapping[gene_id].append(transcript)


    
#step 3: in process of retreiving genes above, also need to find gene length (length of read or length of reference?)
#already done by shell script

rpk_sum = 0
#O(n) across the much smaller number of genes
for gene in number_reads_mapping.keys:
    #step 4: RPKM for each gene, and add each one to sum for below
    length = gene_length_df.loc[gene][0]
    transcript_list = number_reads_mapping[gene]
    number_reads = len(transcript_list)
    rpk = number_reads / (length / 1000)

    #start formatting output dataframe
    rpkm = rpk / (total_reads_sequenced / 1000000)
    output_df.loc[len(output_df.index)] = [gene, transcript_list, length, 0, 0, rpk, 0, rpkm]
    
    #step 5: S = sum of RPKs / 1 million
    rpk_sum += rpk
normalization_factor = rpk_sum / 1000000

#step 6: TPM for each gene, it's the RPKM for that gene / S
#for column in dataframe
#take each rpkm make a tpm

output_df["tpm"] = output_df["rpk"] / normalization_factor

output_df.to_csv(path_or_buf="{0}.genes.results".format(sys.argv[1], sep='\t', header=True))
