#!/usr/bin/perl

$sizetrmfas = $ARGV[0];
# sizetrim.derep.fasta file

$otunmsz = $ARGV[1];
# rempd.otunmsz.txt file

open(IN1,"<$sizetrmfas") or print "\nUsage: \$perl uc_size_fas_integrator.pl [*.sizetrim.derep.fasta] [*.rempd.otunmsz.txt]\n";
open(IN2,"<$otunmsz") or print "\nUsage: \$perl uc_size_fas_integrator.pl [*.sizetrim.derep.fasta] [*.rempd.otunmsz.txt]\n";

my @list = <IN2>;

while($line=<IN1>){
	chomp($line);
	if ($line =~ /^>/){
		@OTUnames = split(/;/, $line);
		$OTUname = $OTUnames[0];
		$OTUname =~ s/^>//g;;
		
		@matched = grep { /$OTUname/ } @list;
			if (@matched >= 1){
				print ">".$matched[0];
			}else{
				print $line."\n";
			}
	}else{
		print $line."\n";
	}
}
close(IN1);
close(IN2);
