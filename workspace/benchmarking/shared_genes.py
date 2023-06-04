import pandas as pd

output_df = pd.DataFrame(columns=["gene_id", "tx_id(s) [RSEM]", "tx_id(s) [tranquant]", "tx_id_agreement", "length [RSEM]", "length [tranquant]", "TPM [RSEM]", "TPM [tranquant]"])

"""step 1: count all gene ids that occur in both files"""

file = open("genes_in_both_files.txt", "r")
gene_set = set()
for line in file:
    gene_set.add(line.strip(" \t\n"))
file.close()

#print(len(gene_set))
"""step 2: read RSEM results"""
rsem_results = open("../RSEM_results/example.genes.results", "r")

rsem_tx_ids = {}
rsem_length = {}
rsem_tpm = {}

for line in rsem_results:
    data = line.strip("\";\n").split("\t")
    if data[0] not in gene_set:
        continue
    rsem_tx_ids.update({data[0] : data[1]})
    rsem_length.update({data[0] : data[2]})
    rsem_tpm.update({data[0] : data[5]})
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
    my_tx_ids.update({data[0] : data[1]})
    my_length.update({data[0] : data[2]})
    my_tpm.update({data[0] : data[5]})
my_results.close()

"""step 4: calculate metrics"""
#print(len(rsem_tx_ids.keys()))
#print(len(my_tx_ids.keys()))
tx_id_equality = {}
for gene in gene_set:
    
    tx_id_equality.update({gene : (set(rsem_tx_ids[gene].strip("\";\n").split(",")) == set(my_tx_ids[gene].strip("\";\n").split(",")))})
    output_df.loc[len(output_df.index)] = [gene, rsem_tx_ids[gene], my_tx_ids[gene], tx_id_equality[gene], rsem_length[gene], my_length[gene], rsem_tpm[gene], my_tpm[gene]]

"""step 5: tx_id list equality check"""

output_df.to_csv(path_or_buf="shared_genes_comparison.txt", sep='\t', header=True, index=False)
