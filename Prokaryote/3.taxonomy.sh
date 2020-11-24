#!/bin/bash

classifier='path/to/your/own/classifier'

set -e
#taxonomy

qiime feature-classifier classify-sklearn --i-classifier $classifier --i-reads V34_merge_rep-seqs.qza --o-classification V34_merge_rep-seqs_silva_V3V4.taxonomy.qza
wait
qiime metadata tabulate --m-input-file V34_merge_rep-seqs_silva_V3V4.taxonomy.qza --o-visualization V34_merge_rep-seqs_silva_V3V4.taxonomy.qzv
wait
qiime taxa barplot --i-table V34_merge_table.qza --i-taxonomy V34_merge_rep-seqs_silva_V3V4.taxonomy.qza --m-metadata-file UC_V34_merge_metadata.txt --o-visualization V34_merge_rep-seqs_silva_V3V4.taxa-bar-plots.qzv

