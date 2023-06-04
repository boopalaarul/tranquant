echo "Number of genes in RSEM results"
tail -n +2 ../RSEM_results/example.genes.results | wc -l
echo "Number of unique genes in RSEM results"
tail -n +2 ../RSEM_results/example.genes.results | awk '{print $1}' | uniq -c | wc -l
echo "Number of genes with TPM > 0 in RSEM results"
tail -n +2 ../RSEM_results/example.genes.results | awk '$6>0 {print $1}' > rsem_genes.txt
wc -l rsem_genes.txt

echo "Number of genes in my results"
tail -n +2 ../myexample/example.genes.results | wc -l
echo "Number of unique genes in my results"
tail -n +2 ../myexample/example.genes.results | awk '{print $1}' | uniq -c | wc -l
echo "Number of genes with TPM > 0 in my results"
tail -n +2 ../myexample/example.genes.results | awk '$6>0 {print $1}' > my_genes.txt
wc -l my_genes.txt

cp rsem_genes.txt tmp.txt
cat my_genes.txt >> tmp.txt
sort tmp.txt | uniq -c > all_expressed_genes.txt
rm tmp.txt

echo "Number of genes that occur in both files"
awk '$1>1 {print $2}' all_expressed_genes.txt > genes_in_both_files.txt
wc -l genes_in_both_files.txt
echo "Number of genes that occur only in RSEM results"
cp genes_in_both_files.txt tmp.txt
cat rsem_genes.txt >> tmp.txt
sort tmp.txt | uniq -c > rsem_genes.txt
rm tmp.txt
awk '$1==1 {print $2}' rsem_genes.txt > rsem_unique_genes.txt 
wc -l rsem_unique_genes.txt
echo "Number of genes that occur only in my results"
cp genes_in_both_files.txt tmp.txt
cat my_genes.txt >> tmp.txt
sort tmp.txt | uniq -c > my_genes.txt
rm tmp.txt
awk '$1==1 {print $2}' my_genes.txt > my_unique_genes.txt
wc -l my_unique_genes.txt
#echo "Number of genes that occur in only one files"
#awk '$1==1 {print $2}' all_expressed_genes.txt > genes_in_one_file.txt 
#wc -l genes_in_one_file.txt

