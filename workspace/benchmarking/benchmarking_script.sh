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
#python shared_genes.py
echo "Number of shared genes for which same transcripts are listed"
awk '$4=="True" {print}' shared_genes_comparison.txt > same_transcripts.txt
wc -l same_transcripts.txt
awk '{print $10}' same_transcripts.txt | datamash -H mean 1 min 1 q1 1 median 1 q3 1 max 1 
#sstdev 1

echo "Number of shared genes for which TPMs are same in both results"
awk '$9=="True" {print}' shared_genes_comparison.txt > same_tpm.txt
wc -l same_tpm.txt
awk '{print $10}' same_tpm.txt | datamash -H mean 1 min 1 q1 1 median 1 q3 1 max 1 
#sstdev 1

echo "Number of shared genes for which TPM[RSEM] = TPM[tranquant] AND TPMs are same"
awk '$9=="True" {print}' same_transcripts.txt > same_transcripts_tpm.txt
wc -l same_transcripts_tpm.txt
awk '{print $10}' same_transcripts_tpm.txt | datamash -H mean 1 min 1 q1 1 median 1 q3 1 max 1 
#sstdev 1
