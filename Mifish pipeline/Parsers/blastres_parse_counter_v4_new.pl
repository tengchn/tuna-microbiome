#!/usr/bin/perl

$blstres = $ARGV[0];
# BLASTn result file

open(IN,"<$blstres") or print "\nUsage: \$perl blastres_parse_counter_v4.pll [BLASTn result file]\n";
my @filepath = split(/\//, $blstres);
my $filenm = pop(@filepath);
my @filenames = split(/\./, $filenm);
$samplenm = $filenames[0].".".$filenames[1];


my @LINE = <IN>;

my %subtotal;
my @order;

foreach (@LINE){
	chomp;
	my ($num, $id, $seq) = split(/\t/);
		if (!exists $subtotal{$id}){
			push(@order, $id, $seq);
		}
	$subtotal{$id} += $num;
	}

my $ret = "";
foreach my $key (@order) {
	if($key !~ /^No hits found:/){
		my $value = $subtotal{$key};
		chomp $value;
		$ret .= "$key\t$value\t$seq";
	}else{
	push(@nohits, $key);}
}
$ret =~ s/	0	//g;
$ret =~ s/		/\n/g;
$ret =~ s/\d.\n/\t/g;
	if ($ret ne ""){
		$ret =~ s/^/$samplenm\t/gm;}
$ret =~ s/SPC/GMB/g;

print $ret;
#foreach $nohits(@nohits) {print $nohits."\n";}

close(IN);
