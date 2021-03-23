#!/usr/bin/perl

$size1uc = $ARGV[0];
# Uclust derep file

open(IN,"<$size1uc") or print "\nUsage: \$perl uc_size_processor.pl\n";

# making OTU list
my @otus =();
while($line=<IN>){
	chomp($line);
	my @list = split(/\t/, $line);
	if ($list[9] !~ /\*/){
		push(@otus, $list[9]);
	}
}
close(IN);

# OTU list derep
my %hash = ();
my @OTUuni = grep { ! $hash{ $_ }++ } @otus;

foreach $otu (@OTUuni) {
	my @otunames = split(/;/, $otu);
	# OTU name
	$otuname = $otunames[0];
	# OTU size
	my @otusizes = split(/=/, $otunames[1]);
	$otusize = $otusizes[1];
	print $otuname.";size=";
	
	open(IN2,"<$size1uc");
		while($line2=<IN2>){
			chomp($line2);
			my @list2 = split(/\t/, $line2);
			if ($list2[9] =~ /$otuname/){
				$hitsize = 0;
				my @hitsizes = split(/;/, $list2[8]);
				my $hitsize = $hitsizes[1];
				$hitsize =~ s/size=//g;;
				$otusize += $hitsize;
			}
		}
	print $otusize.";\n";
}
close(IN2);
