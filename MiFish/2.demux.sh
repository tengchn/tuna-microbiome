#!/bin/bash
set -e
WD=`pwd`
mkdir -p $WD/MiFish
#BarcodeA.fasta contain all the barcode sequences of MiFish forward primers
cutadapt -e 0 --no-indels -m 100 -g file:BarcodeA.fasta -o $WD/MiFish/{name}.fastq.gz MF-SP_S1_L001_R1+R2_001_trim_rev_adapter.fastq.gz --untrimmed-output $WD/MiFish/MF-SP_S1_L001_R1+R2_001.A-untrimmed.fastq.gz > Library.R1+R2.MiFish-A.log
wait
#Use Barcode-MiFish-A$i to demultiplex each individuals 
for i in `seq 1 10`;do

cutadapt -e 0 --no-indels -a file:Barcode-MiFish-A$i\.fasta -o $WD/MiFish/{name}.fastq.gz $WD/MiFish/Library-MiFish-A$i\.fastq.gz --untrimmed-output $WD/MiFish/Library-MiFish-A$i\.untrimmed.fastq.gz > $WD/MiFish/Library-demux-MiFish-A$i\.log
wait

done

#Following analysis was performed using MiFish pipeline 

