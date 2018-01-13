#!/usr/bin/bash
## Annotation of human genes:   1st column of text file needs to contain human gene symbol list
## Author: Christophe Desterke
## Version 1.0.1
## Date: January 13th, 2018
## Usage: sh gene2bcp.sh humangene.txt

variable=${1}
if [ -z "${variable}" ]
then 
	echo "TEXTTAB file not passed as parameter"
	exit 1
fi

log_file="log_file.log" 

nom_fichier=$(echo $1 | sed -re 's/(.*).txt/\1/')

echo "analyse du ficher = $nom_fichier" >> $log_file

date >> $log_file



echo "-------------------------------------">> $log_file
echo "-------------------------------------">> $log_file

echo "METABOLISM PATHWAY BioCycPath human gene annotation" >> $log_file

echo "-------------------------------------">> $log_file

cat $1 | awk -v OFS="\t" '{print $1}' > input

awk -v OFS="\t" 'NR==FNR {h[$1] = $1; next} {print $1"\t"$2"\t"$3,h[$1]}' input DATABASES_GENES/bcp.txt  > bcp

sort -k2 bcp > bcp_sorted

awk '!arr[$4]++' bcp_sorted > bcp_uniq.txt
tail -n +2 bcp_uniq.txt | sponge bcp_uniq.txt
awk '{print $1,$2,$3}' bcp_uniq.txt > bcp_annotation.txt


echo "Total Number of genes in the list: " >> $log_file
wc -l $1 >> $log_file
echo "Number of metabolic genes reported in the list: " >> $log_file
wc -l bcp_annotation.txt >> $log_file

echo  "Gene_Symbol	BioCycPath_ID	Metabolism_ID" > headers_bcp.tsv
cat headers_bcp.tsv bcp_annotation.txt >> results_bcp.txt
echo "-------------------------------------">> $log_file
sed 's/ /\t/g' results_bcp.txt > bcp_results.csv
cat bcp_results.csv >> $log_file
echo "-------------------------------------">> $log_file
echo "-------------------------------------">> $log_file







cat log_file.log

mkdir RESULTS
mv log_file.log bcp_results.csv RESULTS
cd RESULTS


mv bcp_results.csv $(echo bcp_results.csv | sed "s/\./".$nom_fichier"\./")
mv log_file.log $(echo log_file.log | sed "s/\./".$nom_fichier"\./")

cd .. GENEANNOT
mv RESULTS RESULTS_$nom_fichier

rm input 


rm bcp_sorted
rm bcp
rm bcp_annotation.txt
rm bcp_uniq.txt
rm results_bcp.txt
rm headers_bcp.tsv



exit 0
