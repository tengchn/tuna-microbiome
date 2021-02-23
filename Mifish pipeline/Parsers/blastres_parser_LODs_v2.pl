#!/usr/bin/perl

$blstres = $ARGV[0];
# BLAST result file

open(IN,"<$blstres") or print "\nUsage: \$perl blastres_parser_LODs_v2.pl [BLAST result file]\n";

my $i = ();
$check='off';
my $num=1;
while($line=<IN>){
	chomp($line);
	if($line =~ /Query: /){
		$name = $line;
		my @querynms = split(/;/, $name);
		$querynms[1] =~ s/size=//g;
		my $size = $querynms[1];
		print $size."\t";
		$check='on';
		$num=1;
		my $Sp =();
		my $Seq =();
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
				$nmlist[2] =~ tr /\n//;
				$Sp[$num] = $nmlist[2];
				# sequence $nmlist[7]
				$pmlist[7] =~ s/-//g;
				$Seq[$num] = $pmlist[7];
				# scientific name $nmlist[2]
				# % identity $pmlist[1]
				$PerI[$num] = $pmlist[1];
				# alignment length $pmlist[2]
				$Ale[$num] = $pmlist[2];
				# mismatches $pmlist[3]
				$Mis[$num] = $pmlist[3];
				# gap opens $pmlist[4]
				# evalue $pmlist[5]
				# bit score $pmlist[6]
					if ($num > 1){
					# read with hits from more than 2 species
						if ($Sp[$num] !~ /$Sp[1]/){
							my $LOD = log((($Ale[1])/($Mis[1]+1))/(($Ale[$num])/($Mis[$num]+1)));
							my $LODs = sprintf("%.4f", $LOD);
							# >=98% identity
							if ($PerI[1] >= 98) {
								# >=0.9 LOD score
								if ($LODs >= 0.9){
									print $Sp[1]."\t".$PerI[1]."\t".$Ale[1]."\t".$Mis[1]."\t".$Ale[$num]."\t".$Mis[$num]."\t".$LODs."\tHIGH\t".$Seq[1]."\t".$Sp[$num]."\n";$check='off';
								# >=0.5 LOD score
								}elsif ($LODs >= 0.5){
									print $Sp[1]."\t".$PerI[1]."\t".$Ale[1]."\t".$Mis[1]."\t".$Ale[$num]."\t".$Mis[$num]."\t".$LODs."\tMODERATE\t".$Seq[1]."\t".$Sp[$num]."\n";$check='off';
								# <0.5 LOD score
								}elsif ($LODs < 0.5){
									print $Sp[1]."\t".$PerI[1]."\t".$Ale[1]."\t".$Mis[1]."\t".$Ale[$num]."\t".$Mis[$num]."\t".$LODs."\tLOW\t".$Seq[1]."\t".$Sp[$num]."\n";$check='off';
								}
							}else{
							# <=98% identity
							print $Sp[1]."\t".$PerI[1]."\t".$Ale[1]."\t".$Mis[1]."\t".$Ale[$num]."\t".$Mis[$num]."\t".$LODs."\tLOW\t".$Seq[1]."\t".$Sp[$num]."\n";$check='off';
							}
						}else{}
					}
				$num++;
				}
				# read with hit from one species
				if($line =~ /BLAST/){
					if ($PerI[1] >= 99) {
						print  $Sp[1]."\t".$PerI[1]."\t".$Ale[1]."\t".$Mis[1]."\tN.A.\tN.A.\tN.A.\tHIGH\t".$Seq[1]."\tNone\n";
					}elsif($PerI[1] >= 98){
						print  $Sp[1]."\t".$PerI[1]."\t".$Ale[1]."\t".$Mis[1]."\tN.A.\tN.A.\tN.A.\tMODERATE\t".$Seq[1]."\tNone\n";
					}else{
						print  $Sp[1]."\t".$PerI[1]."\t".$Ale[1]."\t".$Mis[1]."\tN.A.\tN.A.\tN.A.\tLOW\t".$Seq[1]."\tNone\n";
					}
				}
			}
		}else{$check='off';}
	}
}
close(IN);

