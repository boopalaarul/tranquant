import sys
import pandas as pd

"""step 1: count all transcripts in the experiment & make list of unique IDs"""

file = open("tx_list.txt", "r")

tx_freqs = {}

for line in file:
    tx_id = line.strip()
    if len(tx_id) < 3:
        continue
    try:
        tx_freqs[tx_id] += 1
    except:
        tx_freqs.update({tx_id : 1})	#Updates the dictionary with the specified key-value pairs
file.close()

"""step 2: read in gtf_transcripts, find gene of origin & how many reads map to it"""

#one copy of every possible transcript-- should we sort and uniq?
gtf_tx_file = open("gtf_transcripts.txt", "r")

num_reads_on_gene = {}
txlist_on_gene = {}
total_reads_sequenced = 0

for line in gtf_tx_file:
    #tx_gene[0] = ENSMUST, #tx_gene[1] = ENSMUSG
    tx_gene = line.split(" ")
    tx_id = tx_gene[0].strip("\";\n")
    gene_id = tx_gene[1].strip("\";\n")
    try:
        #does this ENSMUST occur in the BAM file-- was it detected in this experiment
        freq = tx_freqs[tx_id]
    except:
        continue #don't have to store a useless transcript
    #from this transcript, we first want to update the gene's list of found transcripts...
    try:
        txlist_on_gene[gene_id] = txlist_on_gene[gene_id] + ", " + tx_id
    except:
        txlist_on_gene.update({gene_id : tx_id})
    #...and then want to update the number of reads mapping to the gene.
    try:
        num_reads_on_gene[gene_id] = num_reads_on_gene[gene_id] + freq
    except:
        num_reads_on_gene.update({gene_id : freq})
    #update total number of reads sequenced
    total_reads_sequenced += freq
    #also want to find length of gene, but we can do that later
gtf_tx_file.close()

"""step 3: find gene lengths"""

lengths_file = open("gtf_genes.txt", "r")

lengths = {}

for line in lengths_file:
    gene_length = line.split(" ")
    gene_id = gene_length[0].strip("\";\n")
    length = int(gene_length[1].strip("\";\n"))
    try:
        #just trying to throw an exception if it's not there
        dummy = txlist_on_gene[gene_id]
    except:
        #if these gene is not represented in the experiment, don't need to track its length]
        continue
    lengths.update({gene_id : length})
lengths_file.close()

"""step 4: calculte metrics"""

output_df = pd.DataFrame(columns=["gene_id", "transcript_id(s)", "length", "effective_length","expected_count", "RPK", "TPM", "RPKM"])

rpk_sum = 0
#O(n) across the much smaller number of genes
for gene in num_reads_on_gene.keys():
    #step 4: RPKM for each gene, and add each one to sum for below
    length = lengths[gene]
    number_reads = num_reads_on_gene[gene]
    rpk = number_reads / (length / 1000)

    #start formatting output dataframe
    rpkm = rpk / (total_reads_sequenced / 1000000)
    output_df.loc[len(output_df.index)] = [gene, txlist_on_gene[gene], length, 0, 0, rpk, 0, rpkm]
    
    #step 5: S = sum of RPKs / 1 million
    rpk_sum += rpk
normalization_factor = rpk_sum / 1000000

"""step 5: TPM for each gene, it's the RPKM for that gene / S"""
#for column in dataframe
#take each rpk make a tpm
output_df["TPM"] = output_df["RPK"] / normalization_factor


output_df.to_csv(path_or_buf="{0}.genes.results".format(sys.argv[1]), sep='\t', header=True, index=False)
