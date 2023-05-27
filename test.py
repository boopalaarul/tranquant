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

file = open("blegh.txt", "r")
print(file) #this won't print all of the lines, files are iterators, can only traverse file once
#put every gtf entry into a dictionary(after stripping the quote marks and semicolons), then use that for lookup
    