file = open("tx_list.txt", "r")

dict = {}

for line in file:
    tx_id = line.strip()
    if len(tx_id) < 3:
        continue
    try:
        dict[tx_id] += 1
    except:
        dict.update({tx_id : 1})	#Updates the dictionary with the specified key-value pairs

out = open("tx_hist.txt", "w")

for key in dict.keys():
    out.write(key + "\t" + str(dict[key]) + "\n")
out.close()