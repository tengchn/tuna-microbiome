#!/bin/bash

IN_DIR="../data"
OUT_DIR="../1_5_Length_check"
SCRIPT="../Tools/check_seq_length_MiFish.pl"

rm -rf $OUT_DIR
mkdir $OUT_DIR

for FILE in $IN_DIR/*fastq.gz
do
	FILENM=${FILE##*/}
	SAMPLE=${FILENM%.fastq.gz}
	gzip -d -k $FILE
	echo -e "\n"
	date +"%Y/%m/%d %H:%M:%S"
	echo -e "Starting length finltering (240 +- 50 bp) of" $SAMPLE
	perl $SCRIPT $IN_DIR/$SAMPLE.fastq >$OUT_DIR/$SAMPLE.MiFish.fastq
	echo -e "Length filtering finished at "
	rm -rf $IN_DIR/$SAMPLE.fastq
done

