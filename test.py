import pandas as pd

output_df = pd.DataFrame(columns=["gene_id", "RPKM"])

try:
    print(output_df.loc[0])
except:
    print("wowah!~")
    output_df.loc[len(output_df.index)] = ["boogogo", None]
    print(output_df.loc[0])

dict = {}
dict["bbb"] = 0
print(dict["bbb"])
    