#!/bin/sh
#$ -S /bin/sh

IN_DIR="../2_1_Uclust"
OUT_DIR="../3_1_BlastnRes"

rm -rf $OUT_DIR
mkdir $OUT_DIR

# Specify Blastn database name
DBname="Crust_mitochondrion_new.fasta" #make your own database

DB="../BlastDB/$DBname" #database path

for FNAME in $IN_DIR/*.sizetrim.sum.fasta
do
	FILE=${FNAME##*/} 
	SAMPLE=${FILE%.sizetrim.sum.fasta}
	echo -e "\nStart Blastn search analysis for :"$SAMPLE
	blastn -query $FNAME -db $DB -num_threads 30 -max_target_seqs 5 -perc_identity 97 -evalue 0.00001 -outfmt "7 sseqid pident length mismatch gapopen evalue bitscore qseq" -out $OUT_DIR/$SAMPLE.blastn_res.txt -html
done

echo -e "\nBlastn search analysis finished"
