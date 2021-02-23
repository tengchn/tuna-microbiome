import sys
import re 
import os
import gzip

from Bio import SeqIO
SeqIO.convert(sys.argv[1],"fastq", sys.argv[2],"fasta")


