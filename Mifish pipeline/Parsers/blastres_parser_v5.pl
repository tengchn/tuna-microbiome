#!/usr/bin/perl

$blstres = $ARGV[0];
# BLAST result file

open(IN,"<$blstres") or print "\nUsage: \$perl blastres_parser_v5.pl [BLAST result file]\n";

my $i = ();
$check='off';
while($line=<IN>){
	chomp($line);
	if($line =~ /Query: /){
		$name = $line;
		my @querynms = split(/;/, $name);
		$querynms[1] =~ s/size=//g;
		my $size = $querynms[1];
		print $size."\t";
		$check='on';
	}else{
		if($check eq 'on'){
			if($line =~ /\s[0] hits found/){
				$i++;
				print "No hits found: ".$name."\n";
				$check='off';
			}else{
				if($line =~ /^gb/ or $line =~ /^gi/){
					my @pmlist = split(/\t/, $line);
					my @nmlist = split(/\|/, $pmlist[0]);
					# accession number $nmlist[1]
					$nmlist[2] =~ tr /_/ /;
					$pmlist[7] =~ s/-//g;
					# scientific name $nmlist[2]
					# % identity $pmlist[1]
					# alignment length $pmlist[2]
					# mismatches $pmlist[3]
					# gap opens $pmlist[4]
					# evalue $pmlist[5]
					# bit score $pmlist[6]
					print $nmlist[2]."\t".$pmlist[7]."\n";
					$check='off';
				}
			}
		}
	}
}

print "Number of read with no hits: ".$i;
close(IN);
