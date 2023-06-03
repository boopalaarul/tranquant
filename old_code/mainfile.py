import sys
import pandas as pd

#step 1: be able to group up transcripts based on what genes they are from-- prob w/ dictionary(ies)
#samtools view -H gives all unique transcript names-- can make gene dictionary off that
#all this was done by shell script earlier

"""step 3: in process of retreiving genes above, also need to find gene length (length of read or length of reference?)"""

#key for all of these dictionaries is the gene id
lengths = {}
length_file = open("gene_lengths.txt", "r")

for line in length_file:
    kv_pair = line.strip().split("\t")
    gene = kv_pair[0]
    length = int(kv_pair[1])
    lengths.update({gene : length})	#Updates the dictionary with the specified key-value pairs

length_file.close()

"""step 2: keep track: # reads mapping to gene i (so, some kind of running count, per gene)"""

#something like O(n) time across all 4m reads
total_reads_sequenced = 0

#dictionary that allows counting of # reads mapping to each gene
number_reads_mapping = {}
#unique transcripts per gene
tx_list_per_gene = {}

tx_file = open("tx_to_gene.txt", "r")

for line in tx_file:
    tx_freq_gene = line.strip().split("\t")
    tx = tx_freq_gene[0]
    freq = int(tx_freq_gene[1])
    gene = tx_freq_gene[2]
    try:
        number_reads_mapping[gene] += freq
        tx_list_per_gene[gene] = tx_list_per_gene[gene] + "," + tx
    except:
        number_reads_mapping.update({gene : freq})
        tx_list_per_gene.update({gene: tx})	#Updates the dictionary with the specified key-value pairs'
    
    total_reads_sequenced += 1

tx_file.close()

output_df = pd.DataFrame(columns=["gene_id", "transcript_id(s)", "length", "effective_length","expected_count", "RPK", "TPM", "RPKM"])

rpk_sum = 0
#O(n) across the much smaller number of genes
for gene in number_reads_mapping.keys():
    #step 4: RPKM for each gene, and add each one to sum for below
    length = lengths[gene]
    number_reads = number_reads_mapping[gene]
    rpk = number_reads / (length / 1000)

    #start formatting output dataframe
    rpkm = rpk / (total_reads_sequenced / 1000000)
    output_df.loc[len(output_df.index)] = [gene, tx_list_per_gene[gene], length, 0, 0, rpk, 0, rpkm]
    
    #step 5: S = sum of RPKs / 1 million
    rpk_sum += rpk
normalization_factor = rpk_sum / 1000000

"""step 6: TPM for each gene, it's the RPKM for that gene / S"""
#for column in dataframe
#take each rpkm make a tpm

output_df["tpm"] = output_df["rpk"] / normalization_factor


output_df.to_csv(path_or_buf="{0}.genes.results".format(sys.argv[1], sep='\t', header=True))
