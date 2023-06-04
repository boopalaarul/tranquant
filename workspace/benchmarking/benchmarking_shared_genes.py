import pandas as pd

output_df = pd.DataFrame(columns=["gene_id", "transcript_id(s) [RSEM]", "transcript_id(s) [tranquant]", "length [RSEM]", "length [tranquant]" "TPM [RSEM]", "TPM [tranquant]"])

"""step 1: count all gene ids that occur in both files"""

file = open("genes_in_both_files.txt", "r")
gene_set = set()
for line in file:
    gene_set.add(line.strip(" \t\n"))
file.close()

print(len(gene_set))
"""step 2: read RSEM results"""
rsem_results = open("../RSEM_results/example.genes.results", "r")

rsem_tx_ids = {}
rsem_length = {}
rsem_tpm = {}

for line in rsem_results:
    data = line.strip("\";\n").split("\t")
    if data[0] not in gene_set:
        continue
    rsem_tx_ids.update({line : data[1]})
    rsem_length.update({line : data[2]})
    rsem_tpm.update({line : data[5]})
rsem_results.close()

"""step 3: read my results"""
my_results = open("../myexample/example.genes.results", "r")

my_tx_ids = {}
my_length = {}
my_tpm = {}

for line in my_results:
    data = line.strip("\";\n").split("\t")
    if data[0] not in gene_set:
        continue
    my_tx_ids.update({line : data[1]})
    my_length.update({line : data[2]})
    my_tpm.update({line : data[5]})
my_results.close()

"""step 4: calculate metrics"""

for gene in gene_set:
    output_df.loc[len(output_df.index)] = [gene, rsem_tx_ids[gene], my_tx_ids[gene], rsem_length[gene], my_length[gene], rsem_tpm[gene], my_tpm[gene]]

#"""step 5: TPM for each gene, it's the RPKM for that gene / S"""
#for column in dataframe
#take each rpk make a tpm
#output_df["TPM"] = output_df["RPK"] / normalization_factor

output_df.to_csv(path_or_buf="shared_genes_comparison.txt", sep='\t', header=True, index=False)
