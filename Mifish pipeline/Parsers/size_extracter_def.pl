#!/usr/bin/perl

$derep = $ARGV[0];
# Uclust derep file

open(IN,"<$derep") or print "\nUsage: \$perl size_extracter_def.pl [Uclust derep file] \n";

#######################################################
# Specify read size threshold for sequence discarding #
#######################################################
my $sizethreshold = 10;

my $check='off';

while($line=<IN>){
	chomp($line);
	if($check eq 'off'){
		if($line =~ /^>/){
			my @lines = split(/;/, $line);
			my $size = $lines[1];
			$size =~ s/size=//g;
			if ($size < $sizethreshold){
				print $line."\n";
				$check='on';
			}
		}else{}
	}elsif($check eq 'on'){
		if($line =~ /^>/){
			my @lines2 = split(/;/, $line);
			my $size2 = $lines2[1];
			$size2 =~ s/size=//g;
				if ($size2 < $sizethreshold){
				print $line."\n";
				}else{$check='off';}
		}elsif($line !~ /^>/){
			print $line."\n";
		}else{
			$check='off';
		}
	}
}
