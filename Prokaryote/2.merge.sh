# merge the 8 feature tables into 1 file. 
qiime feature-table merge \
  --i-tables V34_H8/V34_H8_table-dada2.qza \
  --i-tables V34_H2/V34_H2_table-dada2.qza \
  --i-tables V34_H7/V34_H7_table-dada2.qza \
  --i-tables V34_H4/V34_H4_table-dada2.qza \
  --i-tables V34_H6/V34_H6_table-dada2.qza \
  --i-tables V34_H5/V34_H5_table-dada2.qza \
  --i-tables V34_H3/V34_H3_table-dada2.qza \
  --i-tables V34_H1/V34_H1_table-dada2.qza \
  --o-merged-table V34_merge_table.qza
wait  
qiime feature-table summarize --i-table V34_merge_table.qza --o-visualization V34_merge_table.qzv --m-sample-metadata-file UC_V34_merge_metadata.txt
wait
# merge the 8 related seqs into 1 file. 
qiime feature-table merge-seqs \
  --i-data V34_H8/V34_H8_rep-seqs-dada2.qza \
  --i-data V34_H2/V34_H2_rep-seqs-dada2.qza \
  --i-data V34_H7/V34_H7_rep-seqs-dada2.qza \
  --i-data V34_H4/V34_H4_rep-seqs-dada2.qza \
  --i-data V34_H6/V34_H6_rep-seqs-dada2.qza \
  --i-data V34_H5/V34_H5_rep-seqs-dada2.qza \
  --i-data V34_H3/V34_H3_rep-seqs-dada2.qza \
  --i-data V34_H1/V34_H1_rep-seqs-dada2.qza \
  --o-merged-data V34_merge_rep-seqs.qza
wait  
qiime feature-table tabulate-seqs --i-data V34_merge_rep-seqs.qza --o-visualization V34_merge_rep-seqs.qzv
