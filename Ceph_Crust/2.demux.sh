#!/bin/bash
#As the barcode sequence of all forward primers is unique between Crust and Ceph libraries, then we can use these barcode sequences to seperate the reads belong to Crust and Ceph library. 
set -e
WD=`pwd`
mkdir -p $WD/Ceph
mkdir -p $WD/Crust
#BarcodeE.fasta contain all the barcode sequences of Ceph forward primers
cutadapt -e 0 --no-indels -m 100 -g file:BarcodeE.fasta -o $WD/Ceph/{name}.fastq.gz CC-SP_S1_L001_R1+R2_001_trim_rev_adapter.fastq.gz --untrimmed-output $WD/Ceph/CC-SP_S1_L001_R1+R2_001.E-untrimmed.fastq.gz > Library.R1+R2.Ceph-E.log

#BarcodeC.fasta contain all the barcode sequences of Crust forward primers
cutadapt -e 0 --no-indels -m 100 -g file:BarcodeC.fasta -o $WD/Crust/{name}.fastq.gz CC-SP_S1_L001_R1+R2_001_trim_rev_adapter.fastq.gz --untrimmed-output $WD/Crust/CC-SP_S1_L001_R1+R2_001.C-untrimmed.fastq.gz > Library.R1+R2.crust-C.log

#Use Barcode-Crust-C$i and Barcode-Ceph-E$i to demultiplex each individuals 
for i in `seq 1 10`;do

cutadapt -e 0 --no-indels -a file:Barcode-Ceph-E$i\.fasta -o $WD/Ceph/{name}.fastq.gz $WD/Ceph/Library-Ceph-E$i\.fastq.gz --untrimmed-output $WD/Ceph/Library-Ceph-E$i\.untrimmed.fastq.gz > $WD/Ceph/Library-demux-Ceph-E$i\.log
wait
cutadapt -e 0 --no-indels -a file:Barcode-Crust-C$i\.fasta -o $WD/Crust/{name}.fastq.gz $WD/Crust/Library-Crust-C$i\.fastq.gz --untrimmed-output $WD/Crust/Library-Crust-C$i\.untrimmed.fastq.gz > $WD/Crust/Library-demux-Crust-C$i\.log
wait

done

#Following analysis was performed using MiFish pipeline 

