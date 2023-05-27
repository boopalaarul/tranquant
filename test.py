import pandas as pd

output_df = pd.DataFrame(columns=["gene_id", "RPKM"])

output_df.loc[len(output_df.index)] = ["boogogo", None]
#print(output_df.loc[0]["RPKM"].type)

dict = {}

print(dict["bbb"])
    