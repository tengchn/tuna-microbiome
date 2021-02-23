#!/usr/local/bin/perl 
use strict;
my $file = $ARGV[0];
my ($in, $out) = (0, 0);
my $size = 240;
my $window = 50;
 
open IN, "$file" or print "File not found. Usage: \$ perl Fastq_Nread_trim.pl <fastq>\n";

while(<IN>){
	$in++;
	my $id = $_;
	my $seq = <IN>;
	my $len = length $seq;
	
	if ($len <= $size-$window || $len >= $size+$window ){
		$_ = <IN>;
		$_ = <IN>;
	}
	else{
		$out++;
		print $id;
		print $seq;
		$_ = <IN>;
		print $_; 
		$_ = <IN>;
		print $_; 
	}
	
}

close IN;

my $percent = $out/$in*100;
print STDERR "$file\tinput\t$in\toutput\t$out\t$percent%\n";

# F-primer: TGTCTTGTCGGTAAAACTCGTGCCAGC
# 27 bp
# Read: CACCGCGGTTATACGTGCGACCCAAGTTGATAGCCTACGGCGTAAAGCGTGGTTAAGAAAATAAAATACTAGGGCCGAACCTCCACACAGCTGTTATACGCATACGAGAATATGAAGCCCCCCTACAAAAGTGGCCCCAACCTACTCTGACCCCACGTAAGATGCAAAA
# 169 bp
# R-primer: CAAACTGGGATTAGATACCCCACTATGGGCAGT
# 33 bp
