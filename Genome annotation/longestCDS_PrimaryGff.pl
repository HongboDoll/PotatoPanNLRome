#!/usr/bin/perl

my %hash;
my %mm;
my @genes;
open(IN,$ARGV[0]);
while(<IN>) {
	chomp;
	next if (/^#/);
	my @ll=split/\t/;
  
       if (/\tgene\t.*ID=([^;]+).*Name=([^;]+)/) {
                my $gene_id=$1;
                $gene_hash{$gene_id}="$_";
                next;
        }


	if (/\tmRNA\t.*ID=([^;]+).*Parent=([^;]+)/) {
		my $id=$1;
		my $parent=$2;
		if (! exists $hash{$parent}) {push(@genes,$parent);}
		$hash{$parent}{$id}{ID}=$id;
		$hash{$parent}{$id}{seq}="$gene_hash{$parent}\n$_\n";
		$mm{$id}=$parent;
		next;
	} 
    #if (/\texon\t.*Parent=([^;]+)/) {
	#	my $parent=$1;
	#	if (exists $mm{$parent}) {
	#		$hash{$mm{$parent}}{$parent}{exon}+=$ll[4]-$ll[3]+1;
	#		$hash{$mm{$parent}}{$parent}{seq}.="$_\n";
	#	}
	#}
	if (/\tCDS\t.*Parent=([^;]+)/) {
		my $parent=$1;
		if (exists $mm{$parent}) {
			$hash{$mm{$parent}}{$parent}{CDS}+=$ll[4]-$ll[3]+1;
			$hash{$mm{$parent}}{$parent}{seq}.="$_\n";
		}
	}


        if (/\texon\t.*Parent=([^;]+)/) {
                my $parent=$1;
                if (exists $mm{$parent}) {
                        $hash{$mm{$parent}}{$parent}{seq}.="$_\n";
                }
        }


        if (/\tfive_prime_UTR\t.*Parent=([^;]+)/) {
                my $parent=$1;
                if (exists $mm{$parent}) {
                        $hash{$mm{$parent}}{$parent}{seq}.="$_\n";
                }
        }

        if (/\tthree_prime_UTR\t.*Parent=([^;]+)/) {
                my $parent=$1;
                if (exists $mm{$parent}) {
                        $hash{$mm{$parent}}{$parent}{seq}.="$_\n";
                }
        }


}
close IN;
foreach my $gene (@genes) {
	my $max=0;
	my $id;
	foreach my $mRNA (sort{$b cmp $a} keys %{$hash{$gene}}) {
		if ($hash{$gene}{$mRNA}{CDS} >= $max) {
			$max=$hash{$gene}{$mRNA}{CDS};
			$id=$hash{$gene}{$mRNA}{ID};
		}
	}
    #print "$gene\t$id\t$max\n$hash{$gene}{$id}{seq}";		
	print "$hash{$gene}{$id}{seq}";
}
