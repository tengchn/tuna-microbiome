#!/bin/bash

IN_DIR0="../data"
IN_DIR5="../1_6_Primer_removed/results"

OUT_DIR="../1_7_processed_read_counts"

rm -rf $OUT_DIR
mkdir -p $OUT_DIR

date +"%Y/%m/%d %H:%M:%S"
echo "Processed-read counting started"


echo "Counting raw read numbers"

for i in `ls $IN_DIR0`;do
	count=`zcat $IN_DIR0/$i|grep -c '^@M'`
	printf "%s\t%s\n" "${i%%.fastq.gz}" "$count" >> $OUT_DIR/Raw_READ_counts.txt
done

wait

echo "Counting primer-removed reads"
cd $IN_DIR5
grep -c '^>' *.MiFish_processed.fasta|sed s/'.MiFish_processed.fasta:'/'\t'/g >> ../$OUT_DIR/Primer_removed_READ_counts.txt