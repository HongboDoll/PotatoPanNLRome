#!/usr/bin/perl -w 
use strict;
use warnings;
use Getopt::Long;
use Data::Dumper;

my($gff,$bin,$AED,$Name,$tran,$prot,$help);
GetOptions(
    "gff:s"=>\$gff,
    "bin:s"=>\$bin,
    "n:s"=>\$Name,
    "aed:s"=>\$AED,
    "tran:s"=>\$tran,
    "prot:s"=>\$prot,
    "h|help!"  => \$help,
);

$bin ||=0.025;
$AED ||=1;

my $Usage=<<USAGE;

 This script will produce pipeline command.
 options:
	-bin       bin length, 0-1           [ default : 0.025 ]
	-aed       aed limit                 [ default : 1 ]
	-n         gene name                 [ force ]
	-gff       maker gff                 [ force ]
	-tran      maker transcript fasta    [ option ]
	-prot      maker protein fasta       [ option ]
	-help|h           print help information

 perl maker_AED_rename_ch.pl -n C88_C -gff maker.gff3
 2020.12.23
 
USAGE

die $Usage if ($help || ! $gff || !$Name);

##  aed bin ##
my %hash;
my $bin_S=-$bin;
my $bin_E=0;
while(1) {
	$hash{$bin_S}{END}=$bin_E;
	$hash{$bin_S}{NUM}=0;
	$bin_S+=$bin;
	$bin_E+=$bin;
	$bin_E=sprintf "%.3f",$bin_E;
	if ($bin_E >= 1) {
		$bin_E=1;
		$hash{$bin_S}{END}=$bin_E;
		$hash{$bin_S}{NUM}=0;
		last;
	}
}

## read gff ##
my %prots;
my %stat;
my %gme;
my %m2g;
my @genes;
my %chrs;
my %ord;
my %tRNA;
my %log;
open(IN,$gff);
while(<IN>) {
	chomp;
	my @ll=split/\t/;
	next if (/^#/ || $ll[2] !~ /^gene|^mRNA|^CDS|^exon|^tRNA|UTR$/i );
	## chr rename
	if ($ll[0] =~ /ch([0-9]+)_(\d+)$/i) {
		my $id=$1;
		$chrs{chr}{$id}=$ll[0];
	} elsif ($ll[0] =~ /ch([XYZW])$/i ) {
		my $id=$1;
		$chrs{sex}{$id}=$ll[0];
	} else {
		$chrs{scaf}{$ll[0]}=$ll[0];
	}

	## read gene/exon/mRNA/CDS
	if ($ll[2] eq "gene" ) {
		$stat{gene}{total}++;
		if ( $ll[-1] =~ /ID=([^;]+)/ ) {my $id=$1;$gme{$id}{line}="$_";push(@genes,$id);$ord{$ll[0]}{$ll[3]}{$id}=1}
	} elsif ($ll[2] eq "mRNA") {
		my ($id,$parent,$aed,$name)=($ll[-1],$ll[-1],$ll[-1],$ll[-1]);
		$id =~ s/^ID=([^;]+).*/$1/g;
		$parent =~ s/.*Parent=([^;]+).*/$1/g;
		$aed =~ s/.*_AED=([^;]+).*/$1/g;
		$name =~ s/.*Name=([^;]+).*/$1/g;
		$stat{mRNA}{total}++;
		$m2g{$id}=$parent;
		## AED filter ##
		if ($aed <= $AED) {
			$stat{mRNA}{pass}++;
			$gme{$parent}{mRNA}{$id}{line}="$_";
			## some proteins use name as ID
			if ($name) { $prots{$name}=$id }
		}
		## AED stat
		foreach my $st (sort {$a<=>$b} keys %hash) {
			if ( $aed > $st && $aed <= $hash{$st}{END} ) {
				$hash{$st}{NUM}++;
				last;
			}
		}
		
	} elsif ($ll[2] =~ /^exon$|^CDS$|UTR$/i ) {
		my $parent=$ll[-1];
        $parent =~ s/.*Parent=([^;]+).*/$1/g;
        #$parent =~ s/.*Parent=(.*?)/$1/g;
		my @parents=split/,/,$parent;
		foreach my $pp (@parents) {
			next if (exists $log{$pp});
			my $id=$m2g{$pp};
            if (exists $gme{$id}{mRNA}{$pp}) {
				$stat{$ll[2]}{pass}++;
				$stat{$ll[2]}{len}+=$ll[4]-$ll[3]+1;
				$gme{$id}{mRNA}{$pp}{$ll[2]}{$ll[3]}=(join("\t",@ll[0..7]))."\tParent=$pp";
				if ($ll[2] eq "exon") {
					$gme{$id}{mRNA}{$pp}{len}+=$ll[4]-$ll[3]+1;
				} else {
					$gme{$id}{mRNA}{$pp}{plen}+=$ll[4]-$ll[3]+1;
				}
			}
		}
	} elsif ($ll[2] eq "tRNA" ) {
		$stat{gene}{total}--;
		my ($id,$parent)=($ll[-1],$ll[-1]);
		$id =~ s/^ID=([^;]+).*/$1/g;
		$parent =~ s/.*Parent=([^;]+).*/$1/g;
		$tRNA{$ll[0]}{$ll[3]}{$id}{line}="$_";
		$tRNA{$ll[0]}{$ll[3]}{$id}{Parent}="$parent";
		$log{$id}=1;
	}
}
close IN;


open(OUT,">AED_$AED.maker.gff");
open(List,">gene.name.list");
my %list;
my $num=0;
my @my_chrs;
if (exists $chrs{chr}) {
	foreach my $id (sort {$a<=>$b} keys %{$chrs{chr}}) {push(@my_chrs,$id)}
}
if (exists $chrs{sex}) {
	foreach my $id (sort keys %{$chrs{sex}}) {push(@my_chrs,$id)}
}
if (@my_chrs) {
	foreach my $id (@my_chrs) {
		my $snum=0;
		my $chr=$chrs{chr}{$id};
		my $fid=$id;
		for(my $i=0;$i<2-length($fid);$i++) {$fid="0".$fid}
		foreach my $pos (sort {$a<=>$b} keys %{$ord{$chr}}) {
			foreach my $gene (sort keys %{$ord{$chr}{$pos}}) {
				my @kk = keys %{$gme{$gene}{mRNA}};
				if (@kk) {
					$stat{gene}{pass}+=10;
					$snum+=10;
					$num+=10;
					my $line=$gme{$gene}{line};
					my $fnum=$snum;
					my $f_len=6-length($fnum);
					for(my $i=0;$i<$f_len;$i++) {$fnum="0".$fnum}
					$line=~s/\tID=[^;]+/\tID=$Name${fid}G$fnum/g;
					$line=~s/Name=[^;]+/Name=$Name${fid}G$fnum/g;
					print OUT "$line\n";
					my $mnum=0;
					foreach my $mRNA (keys %{$gme{$gene}{mRNA}}) {
						$mnum++;
						$line=$gme{$gene}{mRNA}{$mRNA}{line};
						print List "$Name${fid}G$fnum\t$Name${fid}G$fnum.$mnum\t$line\n";
						$line=~s/Parent=[^;]+/Parent=$Name${fid}G$fnum/g;
						$line=~s/\tID=[^;]+/\tID=$Name${fid}G$fnum\.$mnum/g;
						$line=~s/Name=[^;]+/Name=$Name${fid}G$fnum\.$mnum/g;
						$list{$mRNA}="$Name${fid}T$fnum\.$mnum";
						print OUT "$line\n";
                        #my @types=("exon","CDS");
                        my @types=("exon","five_prime_UTR","CDS","three_prime_UTR");
						foreach my $type (@types) {
							if (exists $gme{$gene}{mRNA}{$mRNA}{$type}) {
								foreach my $pos (sort {$a<=>$b} keys %{$gme{$gene}{mRNA}{$mRNA}{$type}}) {
									$line=$gme{$gene}{mRNA}{$mRNA}{$type}{$pos};
									$line=~s/Parent=[^;]+/Parent=$Name${fid}G$fnum.$mnum/g;
									print OUT "$line\n";
								}
							}
						}
					}
				}
			}
		}
	}
}


if (exists $chrs{scaf}) {
	foreach my $id (sort keys %{$chrs{scaf}}) {
		my $chr=$chrs{scaf}{$id};
		my $fid=$id;
		foreach my $pos (sort {$a<=>$b} keys %{$ord{$chr}}) {
			foreach my $gene (sort keys %{$ord{$chr}{$pos}}) {
				my @kk = keys %{$gme{$gene}{mRNA}};
				if (@kk) {
					$stat{gene}{pass}+=10;
					$num+=10;
					my $line=$gme{$gene}{line};
					my $fnum=$num;
					my $f_len=6-length($fnum);
					for(my $i=0;$i<$f_len;$i++) {$fnum="0".$fnum}
					$line=~s/\tID=[^;]+/\tID=${Name}00G$fnum/g;
					print OUT "$line\n";
					my $mnum=0;
					foreach my $mRNA (keys %{$gme{$gene}{mRNA}}) {
						$mnum++;
						$line=$gme{$gene}{mRNA}{$mRNA}{line};
						print List "${Name}00G$fnum\t${Name}00G$fnum.$mnum\t$line\n";
						$line=~s/Parent=[^;]+/Parent=${Name}00G$fnum/g;
						$line=~s/\tID=[^;]+/\tID=${Name}00G$fnum.$mnum/g;
						$line=~s/Name=[^;]+/Name=${Name}00G$fnum.$mnum/g;
						$list{$mRNA}="${Name}00G$fnum\.$mnum";
						print OUT "$line\n";
                        #my @types=("exon","CDS");
                        my @types=("exon","five_prime_UTR","CDS","three_prime_UTR");
						foreach my $type (@types) {
							if (exists $gme{$gene}{mRNA}{$mRNA}{$type}) {
								foreach my $pos (sort {$a<=>$b} keys %{$gme{$gene}{mRNA}{$mRNA}{$type}}) {
									$line=$gme{$gene}{mRNA}{$mRNA}{$type}{$pos};
									$line=~s/Parent=[^;]+/Parent=${Name}00G$fnum\.$mnum/g;
									print OUT "$line\n";
								}
							}
						}
					}
				}
			}
		}
	}
}
############
open(TR,">tRNA.gff");
my $tRNA_num=0;
foreach my $aa (sort keys %tRNA) {
	foreach my $bb (sort {$a<=>$b} keys %{$tRNA{$aa}}) {
		foreach my $cc (sort keys %{$tRNA{$aa}{$bb}}) {
			$tRNA_num++;
			my $line=$tRNA{$aa}{$bb}{$cc}{line};
			my @ll=split/\t/,$line;
			$ll[2]="gene";
			$ll[-1]="ID=tRNA$tRNA_num";
			$line=join("\t",@ll);
			print TR "$line\n";
			$ll[2]="tRNA";
			$ll[-1]="ID=tRNA$tRNA_num.1;Parent=tRNA$tRNA_num";
			$line=join("\t",@ll);
			print TR "$line\n";
			$ll[2]="exon";
			$ll[-1]="Parent=tRNA$tRNA_num.1";
			$line=join("\t",@ll);
			print TR "$line\n";
		}
	}
}
close TR;




######## output stat 
open(OUT,">gene_Summary_AED_$AED.txt");
print OUT "Total gene number : $stat{gene}{total}\n";
print OUT "Total mRNA number : $stat{mRNA}{total}\n";
print OUT "AED cutoff : <= $AED \n";
$num=$stat{gene}{pass};
print OUT "Filter AED gene number : $num \n";
$num=$stat{mRNA}{pass};
print OUT "Filter AED mRNA number : $num \n";
my $mean=$stat{exon}{pass}/$num;
print OUT "Filter AED mean number of exons per transcript : $mean\n";
$mean=$stat{exon}{len}/$stat{exon}{pass};
print OUT "Filter AED mean exon size : $mean\n";
$mean=$stat{CDS}{len}/$stat{CDS}{pass};
print OUT "Filter AED mean CDS size : $mean\n";
close OUT;

open(OUT,">AED.stat.txt");
$num=0;
foreach my $val (sort {$a<=>$b} keys %hash) {
	$num+=$hash{$val}{NUM};
	my $perc=int($hash{$val}{NUM}*10000/$stat{mRNA}{total})/100;
	my $pp=int($num*10000/$stat{mRNA}{total})/100;
	print OUT "$hash{$val}{END}\t$pp\t$hash{$val}{NUM}\t$perc\n";
}
close OUT;


my $pass=$stat{mRNA}{pass};

## output transcripts
if ( $tran ) {
	my $ord=0;
	open(IN,$tran);
	my $mark=0;
	open(OUT,">AED_$AED.trans.fasta");
	while(<IN>) {
		chomp;
		if (/^>(\S+)/) {
			my $id=$1;
			my $parent=$m2g{$id};
			if (exists $gme{$parent}{mRNA}{$id}{line} || exists $prots{$id} ) {
				if (exists $prots{$id}) {my $new=$prots{$id};$_=~s/$id/$new/g;$id=$new}
				$_=~s/$id/$list{$id}/g;
				$_=~s/ .*//g;
				$mark=1;
				$ord++;
			} else {
				$mark=0;
			}
		} 
		if ($mark==1) {print OUT "$_\n"}
	}
	close OUT;
	my $diff = $pass - $ord;
	if ($diff > 0) {print "Error : $diff transcripts can't find!\n"}
}

## output proteins
if ( $prot ) {
	my $ord=0;
	open(IN,$prot);
	my $mark=0;
	open(OUT,">AED_$AED.prot.fasta");
	while(<IN>) {
		chomp;
		if (/^>(\S+)/) {
			my $id=$1;
			my $parent=$m2g{$id};
			if (exists $gme{$parent}{mRNA}{$id}{line}  || exists $prots{$id} ) {
				if (exists $prots{$id}) {my $new=$prots{$id};$_=~s/$id/$new/g;$id=$new}
				$_=~s/$id/$list{$id}/g;
				$_=~s/ .*//g;
				$mark=1;
				$ord++;
			} else {
				$mark=0;
			}
		}
		if ($mark==1) {print OUT "$_\n"}
	}
	close OUT;
	my $diff = $pass - $ord;
	if ($diff > 0) {print "Error : $diff proteins can't find!\n"}
}


