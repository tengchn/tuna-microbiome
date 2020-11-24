#!/bin/bash
#Please download related raw data (MF-SP) from sra (PRJNA680376).
#As the amplicon size of MiFish libarary are just around 220bp, so both the forward and reverse miseq reads can cover the whole length. 
set -e
#This step was used to remove the reverse primer's adapter and sequencing primer at the end of the forward reads.
cutadapt -j 40 -a AGACCAAGTCTCTGCTACCGTA -o MF-SP_S1_L001_R1_001_trim_rev_adapter.fastq.gz MF-SP_S1_L001_R1_001.fastq.gz --untrimmed-output MF-SP_S1_L001_R1_001_trim_rev_adapter.untrimmed.fastq.gz > forward.trim.log

#This step was used to remove the forward primer's adapter and sequencing primer at the end of the reverse reads.
cutadapt -j 40 -a TGTAGAACCATGTCGTCAGTGTAGATCTCGGTGGTCGCCGT -o MF-SP_S1_L001_R2_001_trim_rev_adapter.fastq.gz MF-SP_S1_L001_R2_001.fastq.gz --untrimmed-output MF-SP_S1_L001_R2_001_trim_rev_adapter.untrimmed.fastq.gz > reverse.trim.log

#Reverse complement the file of MF-SP_S1_L001_R2_001_trim_rev_adapter.fastq.gz
python rev_com_fastq.py MF-SP_S1_L001_R2_001_trim_rev_adapter.fastq.gz

#Combine the forward and reverse file into one
cat MF-SP_S1_L001_R1_001_trim_rev_adapter.fastq.gz rev_com_MF-SP_S1_L001_R2_001_trim_rev_adapter.fastq.gz > MF-SP_S1_L001_R1+R2_001_trim_rev_adapter.fastq.gz

