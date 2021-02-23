#!/bin/sh
#$ -S /bin/sh

IN_DIR="../3_1_BlastnRes"
OUT_DIR1="../3_2_BlastnRes_counts"
OUT_DIR12="../3_2_BlastnRes_counts/parsedfiles"
SCRIPT="../Parsers"

rm -rf $OUT_DIR1
rm -rf $OUT_DIR12
mkdir $OUT_DIR1
mkdir $OUT_DIR12

for FNAME in $IN_DIR/*.blastn_res.txt
do
	FILE=${FNAME##*/}
	SAMPLE=${FILE%.blastn_res.txt}
	linenum=`wc -l $IN_DIR/$SAMPLE.blastn_res.txt | awk '{print $1}'`
	if [ $linenum -le 2 ]
	then
		rm -r $IN_DIR/$SAMPLE.blastn_res.txt
	else
		date +"%Y/%m/%d %H:%M:%S"
		echo -e "\nParsing BlastnRes file of "$SAMPLE
		perl $SCRIPT/blastres_parser_v5.pl $IN_DIR/$FILE > $OUT_DIR12/$SAMPLE.blastn.deprep.list.txt
		echo -e "\nListing the results of "$SAMPLE
		perl $SCRIPT/blastres_parse_counter_v4.pl $OUT_DIR12/$SAMPLE.blastn.deprep.list.txt > $OUT_DIR1/$SAMPLE.blastn.deprep.counts.txt
		echo -e "\nCalculating LOD scores of "$SAMPLE
		perl $SCRIPT/blastres_parser_LODs_v2.pl $IN_DIR/$FILE > $OUT_DIR1/$SAMPLE.blastn.LODlist.txt
	fi
done
