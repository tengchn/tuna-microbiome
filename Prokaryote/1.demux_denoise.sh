#!/bin/bash
#Please download the raw data from sra.
set -e

WD=`pwd`

for i in `seq 1 8`
do
    echo processing V34_H${i}
    
    mkdir $WD/V34_H${i}
    ln -s $WD/H${i}_sample_metadata.txt $WD/V34_H${i}
    mkdir -p $WD/V34_H${i}/fastqz
    ln -s $WD/V34-SP-H${i}_S${i}_L001_R1_001.fastq.gz $WD/V34_H${i}/fastqz/forward.fastq.gz
    ln -s $WD/V34-SP-H${i}_S${i}_L001_R2_001.fastq.gz $WD/V34_H${i}/fastqz/reverse.fastq.gz
    cd $WD/V34_H${i}

    # import the pair of read files into qiime
    qiime tools import --type MultiplexedPairedEndBarcodeInSequence --input-path $WD/V34_H${i}/fastqz --output-path V34_H${i}.qza
    wait
    
    # demultiplex the pair of read files according to the forward barcodes
    qiime cutadapt demux-paired --i-seqs V34_H${i}.qza --m-forward-barcodes-file H${i}_sample_metadata.txt --m-forward-barcodes-column BarcodeSequence1 --p-error-rate 0 --o-per-sample-sequences V34_H${i}_demux.qza --o-untrimmed-sequences V34_H${i}_untrimmed.qza
    wait

    # show the summary statistics
    qiime demux summarize --i-data V34_H${i}_demux.qza --o-visualization V34_H${i}_demux.qzv
    wait
    
    # remove the reverse primers from the reads
    qiime cutadapt trim-paired --i-demultiplexed-sequences V34_H${i}_demux.qza --p-cores 20 --p-front-r GACTACNVGGGTATCTAATCC --p-match-read-wildcards --p-discard-untrimmed --o-trimmed-sequences V34_H${i}_demux_trimmed_0.1mismatch.qza
    wait

    # show the summary statistics
    qiime demux summarize --i-data V34_H${i}_demux_trimmed_0.1mismatch.qza --o-visualization V34_H${i}_demux_trimmed_0.1mismatch.qzv
    wait

    # run dada2
    qiime dada2 denoise-paired --i-demultiplexed-seqs V34_H${i}_demux_trimmed_0.1mismatch.qza --p-trim-left-f 0 --p-trim-left-r 0 --p-trunc-len-f 260 --p-trunc-len-r 200 --p-n-threads 20 --o-representative-sequences V34_H${i}_rep-seqs-dada2.qza --o-table V34_H${i}_table-dada2.qza --o-denoising-stats V34_H${i}_stats-dada2.qza
    wait
    # get the status data
    qiime metadata tabulate --m-input-file V34_H${i}_stats-dada2.qza --o-visualization V34_H${i}_stats-dada2.qzv
    wait
    # summarise table
    qiime feature-table summarize --i-table V34_H${i}_table-dada2.qza --o-visualization V34_H${i}_table-dada2.qzv --m-sample-metadata-file H${i}_sample_metadata.txt
    wait
    # visualize the seqs
    qiime feature-table tabulate-seqs --i-data V34_H${i}_rep-seqs-dada2.qza --o-visualization V34_H${i}_rep-seqs-dada2.qzv

done
