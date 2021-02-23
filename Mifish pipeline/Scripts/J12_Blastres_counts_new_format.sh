#!/bin/sh
#$ -S /bin/sh

IN_DIR="../3_1_BlastnRes"
OUT_DIR1="../3_2_BlastnRes_counts_new_format"
OUT_DIR12="../3_2_BlastnRes_counts/parsedfiles"
SCRIPT="../Parsers"

rm -rf $OUT_DIR1

mkdir $OUT_DIR1


for FNAME in $IN_DIR/*.blastn_res.txt
do
	FILE=${FNAME##*/}
	SAMPLE=${FILE%.blastn_res.txt}
	linenum=`wc -l $IN_DIR/$SAMPLE.blastn_res.txt | awk '{print $1}'`
	if [ $linenum -le 2 ]
	then
		rm -r $IN_DIR/$SAMPLE.blastn_res.txt
	else

		echo -e "\nListing the results of "$SAMPLE
		perl $SCRIPT/blastres_parse_counter_v4_new.pl $OUT_DIR12/$SAMPLE.blastn.deprep.list.txt > $OUT_DIR1/$SAMPLE.blastn.deprep.counts.txt
	fi
done
