echo "Number of genes in RSEM results"
tail -n +2 ../RSEM_results/example.genes.results | wc -l
echo "Number of unique genes in RSEM results"
tail -n +2 ../RSEM_results/example.genes.results | awk '{print $1}' | uniq -c | wc -l
echo "Number of genes with TPM > 0 in RSEM results"
tail -n +2 ../RSEM_results/example.genes.results | awk '$6>0 {print}' | wc -l

echo "Number of genes in my results"
tail -n +2 ../myexample/example.genes.results | wc -l
echo "Number of unique genes in my results"
tail -n +2 ../myexample/example.genes.results | awk '{print $1}' | uniq -c | wc -l
echo "Number of genes with TPM > 0 in my results"
tail -n +2 ../myexample/example.genes.results | awk '$6>0 {print}' | wc -l

tail -n +2 ../RSEM_results/example.genes.results | awk '$6>0 {print $1}' > tmp.txt
tail -n +2 ../myexample/example.genes.results | awk '{print $1}' >> tmp.txt
sort tmp.txt | uniq -c > all_expressed_genes.txt
rm tmp.txt

echo "Number of genes that occur in both files"
awk '$1=2 {print $2}' all_expressed_genes.txt > genes_in_both_files.txt
wc -l genes_in_both_files.txt
echo "Number of genes that occur in only one files"
awk '$1=1 {print $2}' all_expressed_genes.txt > genes_in_one_file.txt 
wc -l genes_in_one_file.txt

