#!/bin/sh
#$ -S /bin/sh

IN_DIR="../1_6_Primer_removed/results/new_format"
OUT_DIR="../2_1_Uclust"
UCLUST="../Tools/usearch7.0.1090_i86linux32"
SCRIPT="../Parsers"

# Specify read size threshold for low count sequence discarding
Size="10 "
Derepsize=$Size - 1

rm -r $OUT_DIR
mkdir $OUT_DIR

for FILE in $IN_DIR/*processed.fasta
do
	FILENM=${FILE##*/}
	SAMPLE=${FILENM%_processed.fasta}
	
	$UCLUST -derep_fulllength $FILE -output $OUT_DIR/$SAMPLE.derep.fasta -sizeout
	perl $SCRIPT/size_extracter_def.pl $OUT_DIR/$SAMPLE.derep.fasta > $OUT_DIR/$SAMPLE.derep.size.fasta
	$UCLUST -sortbysize $OUT_DIR/$SAMPLE.derep.fasta -output $OUT_DIR/$SAMPLE.sizetrim.derep.fasta -minsize $Size
	$UCLUST -usearch_global $OUT_DIR/$SAMPLE.derep.size.fasta -db $OUT_DIR/$SAMPLE.sizetrim.derep.fasta -strand plus -id 0.99 -uc $OUT_DIR/$SAMPLE.size.uc
	perl $SCRIPT/uc_size_processor.pl $OUT_DIR/$SAMPLE.size.uc > $OUT_DIR/$SAMPLE.rempd.otunmsz.txt
	perl $SCRIPT/uc_size_fas_integrator.pl $OUT_DIR/$SAMPLE.sizetrim.derep.fasta $OUT_DIR/$SAMPLE.rempd.otunmsz.txt > $OUT_DIR/$SAMPLE.sizetrim.sum.fasta
	$UCLUST -sortbysize $OUT_DIR/$SAMPLE.sizetrim.sum.fasta -output $OUT_DIR/$SAMPLE.sizetrim.sum.fasta
done
