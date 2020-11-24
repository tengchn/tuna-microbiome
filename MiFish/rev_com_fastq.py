import sys
import re 
import os
import gzip

from Bio import SeqIO, bgzf
from Bio.Seq import reverse_complement
rev_com = [] 
output = "rev_com_" + sys.argv[1]
with gzip.open(sys.argv[1], "rt") as handle:
    for my_seq in SeqIO.parse(handle, "fastq"):
    	rev_com.append(my_seq.reverse_complement(id=my_seq.id,description=my_seq.description)) 
with bgzf.BgzfWriter(output, "wb") as outgz:            
	SeqIO.write(rev_com,outgz,"fastq")

