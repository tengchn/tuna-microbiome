#!/bin/bash

IN_DIR="../1_5_Length_check"
OUT_DIR="../1_6_Primer_removed"
OUT_DIR1="../1_6_Primer_removed/results"
OUT_DIR2="../1_6_Primer_removed/log"
#SCRIPT="../Tools/tagcleaner.pl"

rm -rf $OUT_DIR
rm -rf $OUT_DIR1
rm -rf $OUT_DIR2
mkdir $OUT_DIR
mkdir $OUT_DIR1
mkdir $OUT_DIR2
mkdir $OUT_DIR1/new_format

for FNAME in $IN_DIR/*.MiFish.fastq
do
	FILE=${FNAME##*/} 
	SAMPLE=${FILE%.MiFish.fastq}
	
	cutadapt -j 40 -g ^CGCCTGTTTATCAAAAACAT -o $OUT_DIR/$SAMPLE.tmp.fq $IN_DIR/$FILE --untrimmed-output $OUT_DIR/$SAMPLE.untrim.fq #replace with you own primer
	wait
	cutadapt -j 40 -a TAAGACCCTATAAAACT -o $OUT_DIR1/$SAMPLE.MiFish_processed.fastq.gz $OUT_DIR/$SAMPLE.tmp.fq --untrimmed-output $OUT_DIR/$SAMPLE.tmp.untrim.fq #replace with you own primer
	wait
	java -jar ../trimmomatic-0.39-1/trimmomatic.jar SE -phred33 -threads 30 $OUT_DIR1/$SAMPLE.MiFish_processed.fastq.gz $OUT_DIR1/$SAMPLE.MiFish_processed.fastq LEADING:30 TRAILING:30 SLIDINGWINDOW:4:20 MINLEN:160  #give the path to trimmomatic
	wait
	python ../Tools/fq_to_fa.py $OUT_DIR1/$SAMPLE.MiFish_processed.fastq $OUT_DIR1/$SAMPLE.MiFish_processed.fasta
	cat $OUT_DIR1/$SAMPLE.MiFish_processed.fasta | sed '/^>/ s/ /:/g'|sed '/^>/ s/:N:0:1//g' > $OUT_DIR1/new_format/$SAMPLE.MiFish_processed.fasta
	#COMMAND1="perl $SCRIPT -verbose -fastq $IN_DIR/$FILE -out_format 1 -out $OUT_DIR1/$SAMPLE.MiFish_processed -nomatch 3 -mm3 4 -mm5 4 -tag3 CAAACTGGGATTAGATACCCCACTATGNNNNN -tag5 NNNNNGTCGGTAAAACTCGTGCCAGC"
	#echo $COMMAND1 >> $OUT_DIR/1_6_command_MiFish.sh

	#COMMAND2="perl $SCRIPT -verbose -fastq $IN_DIR/$FILE -out_format 1 -stats $OUT_DIR2 -out $OUT_DIR1/$SAMPLE.MiFish_processed -nomatch 3 -mm3 4 -mm5 4 -tag3 CAAACTGGGATTAGATACCCCACTATGNNNNN -tag5 NNNNNGTCGGTAAAACTCGTGCCAGC"
	#echo "$COMMAND2 > $OUT_DIR2/"$SAMPLE".log" >> $OUT_DIR/1_6_command_MiFish.sh
done

#chmod 774 ../1_6_Primer_removed/1_6_command_MiFish.sh
#../1_6_Primer_removed/1_6_command_MiFish.sh

# MiFish-F
# NNNNNNGTCGGTAAAACTCGTGCCAGC
# MiFish-R
# NNNNNNCATAGTGGGGTATCTAATCCCAGTTTG
