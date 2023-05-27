import pandas as pd

output_df = pd.DataFrame(columns=["gene_id", "transcript_id(s)", "length", "effective_length","expected_count", "TPM", "FPKM"])

output_df.to_csv(path_or_buf="test.genes.results", sep='\t', header=True)