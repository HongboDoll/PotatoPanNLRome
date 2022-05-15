#!/usr/bin/perl -w
#
use warnings;
use strict;

my $filter = $ENV{REVERSE} || 0;
my $plat   = $ENV{PLAT_NAME} || 0;
my $db_file  = shift or die("Usage: REVERSE=0|1 $0 <fasta_file> <seq_name> ...\n");
my @names = @ARGV;

if(@names == 0){
	while(<>){
		chomp;
		push(@names, $_);
	}
}

my %hash = ();
foreach my $tag (@names){
	if(not $plat and $tag=~/^(.+?)(\[([+-])(:(-?\d+),(-?\d+))?\])$/){
		$hash{$1} = [$3 eq '+'? 1:2, (defined $5)? $5:1, (defined $6)? $6:-1];
		#print STDERR join("\t", $1, @{$hash{$1}}), "\n";
	} else {
		$hash{$tag} = [1, 1, -1];
	}
}

my $n = 0;
open(IN, $db_file) or die($!);
my $flag = [0, 1, 0];
my $print = 0;
my $seq = '';
while(<IN>){
	if(/^>(\S+)/){
		my $tag = $1;
		if($plat){
			if(exists $hash{$tag}){
				$print = not $filter;
				$n ++;
			} else {
				$print = $filter;
				last if(not $filter and $n >= @names);
			}
			print if($print);
			next;
		}
		&print_seq;
		$flag=[0,1,-1],last if(not $filter and $n >= @names);
		if(exists $hash{$tag}) { 
			$flag = $hash{$tag};
			$flag->[0]=0 if($filter);
			$n ++; 
		} else {
			$flag = $filter? [1, 1, -1] : [0, 1, 0];
		}
		if($flag->[0]){
			print;
			$seq = '';
		}
	} elsif($plat){
		print if($print);
	} elsif($flag->[0]){
		chomp;
		$seq .= $_;
	}
}
&print_seq;
close IN;

1;

sub print_seq {
	if($flag->[0]){
		$flag->[2]=length($seq) if($flag->[2] < 0);
		if($flag->[1] <= $flag->[2]){
			my $ss = substr($seq, $flag->[1] - 1, $flag->[2] - $flag->[1] + 1);
			if($flag->[0] == 2){
				$ss =~tr/ACGTacgt/TGCAtgca/;
				$ss = reverse $ss;
			}
			while($ss=~/(.{1,100})/g){ print "$1\n"; }
		}
	}
}
