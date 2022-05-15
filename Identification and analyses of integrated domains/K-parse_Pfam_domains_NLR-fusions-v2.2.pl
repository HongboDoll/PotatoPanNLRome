#!/usr/bin/perl -w

## Author: Ksenia V Krasileva

## General Description
# This script parses the output of K-parse_Pfam_domains-v3.1.pl
# Domains are printed out in the order of apprearance in the query
# NLR proteins are identified based on the presence of NB-ARC domain
# fusions are identified based on the presence of non-NBS non-LRR domains with strict evalue cutoff
# summary statistics are printed on screen

## New in v2.0
# Input of datasets descriptions and taxonomic information
# Output of families and prevalence of domains by family

## New in v2.1
# Calculation and output of contingency tables (per SD domain) for each species as well as for all species 
# Table includes following:
# Family \t Species \t Proteins+domain-fusion \t Proteins-domain-fusion \t Proteins+domain+fusion \t Proteins-domain+fusion
# added .txt to all main output filenames

## New in v2.2
# Calculated values for each domain for all species
# Implemented Fisher's Exact left test for the contingency table
 
use strict;
use warnings;

use Getopt::Long;
use Data::Dumper;
use Text::NSP::Measures::2D::Fisher::right;

my $today=`date +'%m%d%Y'`;

chomp $today;

my ($indir, $outdir, $db_description);
my $evalue_cutoff=1e-3;
    
GetOptions(
       'i|indir:s'        => \$indir,
       'e|evalue:s'        => \$evalue_cutoff,
       'o|outdir:s'        => \$outdir,
       'd|db_description:s'        => \$db_description,
);  

my $usage = "usage: perl script.pl <options>
-i|--indir directory for batch retrieval of input *pfamscan*.parsed.verbose files
-e|--evalue evalue cutoff for determining domain fusions [default 1e-3]
-o|--output output directory
-d|--db_description description of datasets used in the analyses [Organism Species_ID NCBI_taxon_ID Family Database Date_aquired Restrictions Version Common_Name Source Reference] 
";
die $usage unless ( (defined $indir) and (defined $db_description) );

my %db = &read_db_description($db_description);

#print Dumper(%db);

my (%all_domains, %nlr, %nlrsd, %sd_domains, %sd_prevalence, %sd_proteins);
my %outfile;

open (PS, "find -L $indir -name *pfamscan*parsed.verbose |");

my ($file, $basefile);

while ($file=<PS>){                                                                                                

    chomp $file;

    $basefile=`basename $file`;
    chomp $basefile;

    my ($species)=split("_pfamscan", $basefile);
    $species =~ s/.protein.fa//;
    $species =~ s/.fa//;
    
    if ( defined ( $db{$species} )){

	my $family = $db{$species}{'Family'};

	print $species, "\t", $family, "\n";

	open (my $FILE1, "<", $file) or die $usage;
    
	$outfile{$species}{'nlr'} = $outdir . "/" . $basefile . ".NLR.txt";
	$outfile{$species}{'nlrsd'} = $outdir . "/" . $basefile . ".NLRSD.txt";

	$db{$species}{'Total_proteins'}=0;

	# sample input
	# Traes_4DS_92264B9F4.1LRR_4(start=58, stop=98, evalue=0.0021)~DARPP-32(start=145, stop=241, evalue=0.015)
	
	while (my $line = <$FILE1> ){
    
	    chomp $line; 

	    $db{$species}{'Total_proteins'}++;
#	    print Dumper($db{$species}{'Total_proteins'});

		my ($seqid, $domainstring)=split("\t", $line);
	    
		my @domains = split('~', $domainstring);

		foreach (@domains){

		    my $domain=$_;

		    my ($domainid, $attributes)=split(/\(/, $domain);
		    $attributes=~ s/\)//; #remove right hand bracket
		    $attributes=~ s/\s//g;
		    my ($start_strng, $stop_string, $evalue_string)=split(",", $attributes);
		    my ($foo, $evalue)=split("=", $evalue_string);

		    if ($evalue < $evalue_cutoff){
		    
			push @{$all_domains{$domainid}{$species}}, $seqid; #record all sequences contianing each domain

			if ($line=~ m/NB-ARC|LRR|NLR|NB-LRR|Rx_N|TIR|RPW8/){ #check for the presence of NB-ARC domain                           

			    $nlr{$species}{$seqid}=$domainstring; #record all NLRs for a species 

			unless ($domainid=~ m/NB-ARC|LRR|NLR|NB-LRR|Rx_N|TIR|RPW8/ ){ #skip known domains
			
			    $nlrsd{$species}{$seqid}=$domainstring; #record putative NLR-SDs

			    push @{$sd_proteins{$domainid}{$species}}, $seqid; #record all sequences contianing each sd domain  
			
			    push @{$sd_domains{'species'}{$species}}, $domainid; #make a list of SDs for a species
			    push @{$sd_prevalence{$domainid}{'species'}}, $species; #make a list of all species for each domain
			    push @{$sd_domains{'family'}{$family}}, $domainid; #make list of SDs for a family
			    push @{$sd_prevalence{$domainid}{'family'}}, $family; #make a list of all families for each domain  
			}
		    }
		    
		}
	    }
    
	}

    close $FILE1;
	 }
}

# create contingency table and corresponding statistics (Fisher's exact test)
# Table includes following
# Family \t Species \t Proteins+domain-fusion \t Proteins-domain-fusion \t Proteins+domain+fusion \t Proteins-domain+fusion


open STATS1 , ">", "nlrsd_domains-" . $today . ".stats.tsv";

my $sep="\t";

print STATS1 join($sep,("Family","Species", "Domain", "All_proteins","All_fusions","Proteins+domain-fusion","Proteins-domain-fusion","Proteins+domain+fusion","Proteins-domain+fusion","Fisher_Right")), "\n";

foreach my $domainid (sort keys %sd_prevalence){

    foreach my $speciesid (sort keys %db){

        my $all_proteins = 0;
        my $all_fusions = 0;
        my $all_fusions_w_domain = 0;
        my $all_fusions_wo_domain = 0;
        my $all_proteins_w_domain = 0;
        my $all_proteins_w_domain_wo_fusion = 0;
        my $all_proteins_wo_domain_wo_fusion = 0;

        die $speciesid unless (defined $db{$speciesid}{'Total_proteins'});

	$all_proteins = $db{$speciesid}{'Total_proteins'};
	$all_fusions = scalar keys %{$nlrsd{$speciesid}};

	if (@{$sd_proteins{$domainid}{$speciesid}}){	

	    $all_fusions_w_domain = uniq( sort(@{$sd_proteins{$domainid}{$speciesid}}) );
	}

	$all_fusions_wo_domain = $all_fusions - $all_fusions_w_domain;

	if (@{$all_domains{$domainid}{$speciesid}}){


	    $all_proteins_w_domain = uniq( sort(@{$all_domains{$domainid}{$speciesid}}) );

        }

	$all_proteins_w_domain_wo_fusion = $all_proteins_w_domain - $all_fusions_w_domain;

	$all_proteins_wo_domain_wo_fusion = $all_proteins - $all_proteins_w_domain_wo_fusion - $all_fusions;
	
	my $checksum_all = $all_proteins_w_domain_wo_fusion + $all_proteins_wo_domain_wo_fusion + $all_fusions_w_domain + $all_fusions_wo_domain;

	my $checksum_fusions = $all_fusions_w_domain + $all_fusions_wo_domain;

	die "Checksum_all_error:", join($sep,($db{$speciesid}{'Family'},$speciesid, $all_proteins, $checksum_all)) unless ($all_proteins==$checksum_all);

        die "Checksum_fusions_error:", join($sep,($db{$speciesid}{'Family'},$speciesid, $all_fusions, $checksum_fusions)) unless ($all_fusions==$checksum_fusions);; 

	if ($all_fusions_w_domain > 0 ){

	my $fisher_right = &fisher_right($all_proteins, $all_proteins_w_domain, $all_fusions, $all_fusions_w_domain);    

	print STATS1 join($sep,($db{$speciesid}{'Family'},$speciesid, $domainid, $all_proteins, $all_fusions, $all_proteins_w_domain_wo_fusion, $all_proteins_wo_domain_wo_fusion, $all_fusions_w_domain, $all_fusions_wo_domain, $fisher_right)), "\n";

	}

    }

}

close STATS1;

# create output files and a summary table

my ($speciesid);

open SUMMARYFILE, ">", "nlrsd_summary_table" . $today . ".tsv"; 

print SUMMARYFILE "Species", "\t", "NBS_count", "\t", "TIR-NBS_count", "\t", "NBS-fusion_count", "\t", "fusion_domains", "\n"; 

foreach my $speciesid (sort keys (%outfile) ){

    open FILEOUT1, ">", $outfile{$speciesid}{'nlr'};
    open FILEOUT2, ">", $outfile{$speciesid}{'nlrsd'};
    
    my $nlr_counter=0;
    my $nlrtir_counter=0; 
    my $nlrsd_counter=0;
	
    while ( my ($nlr_id, $nlr_domains) = each(%{$nlr{$speciesid}}) ){

	print FILEOUT1 $nlr_id, "\t", $nlr_domains, "\n";
	$nlr_counter++;
	
	if ( $nlr_domains=~ m/TIR/ ){

	    $nlrtir_counter++;
	}
	
    }
    while ( my ($nlrsd_id, $nlrsd_domains) = each(%{$nlrsd{$speciesid}}) ){

	print FILEOUT2 $nlrsd_id, "\t", $nlrsd_domains, "\n";
	$nlrsd_counter++;

    }

    my $sd_domains_out="N/A";
	
    if (@{$sd_domains{'species'}{$speciesid}} ){
	
	$sd_domains_out=join(", ", uniq( sort (@{$sd_domains{'species'}{$speciesid}}) ) );

    }
    
    print SUMMARYFILE $speciesid, "\t", $nlr_counter, "\t", $nlrtir_counter, "\t", $nlrsd_counter, "\t", $sd_domains_out, "\n";
}

close SUMMARYFILE;

open SUMMARYFILE2, ">", "nlrsd_by_prevalence" . $today . ".tsv";
open DATAFILE1, ">", "nlrsd_by_prevalence_family_wordcloud_input" . $today . ".txt";

print SUMMARYFILE2 "Domain", "\t", "Species_list", "\t", "Species_total", "\t", "Families_list", "\t", "Families_total", "\n";

foreach my $domain_id (sort keys (%sd_prevalence) ){

    my $sd_prevalence_species_list=join(", ", uniq( sort(@{$sd_prevalence{$domain_id}{'species'}}) ) );
    my $sd_prevalence_species_counter = uniq( sort(@{$sd_prevalence{$domain_id}{'species'}}) );
    my $sd_prevalence_family_list=join(", ", uniq( sort(@{$sd_prevalence{$domain_id}{'family'}}) ) );
    my $sd_prevalence_family_counter = uniq( sort(@{$sd_prevalence{$domain_id}{'family'}}) );


    print SUMMARYFILE2 $domain_id, "\t", $sd_prevalence_species_list, "\t", $sd_prevalence_species_counter, "\t", $sd_prevalence_family_list, "\t", $sd_prevalence_family_counter, "\n";


#    local $, = "\n";
    print DATAFILE1 +("$domain_id") x $sd_prevalence_family_counter, "\n";
 
}

    
sub uniq {

    my %seen;
    grep !$seen{$_}++, @_;

}

sub read_db_description {

    my $file=$_[0];
    open (FILEIN, $file);

    my $header_line = <FILEIN>;
    chomp $header_line;
    my @header = split("\t", $header_line);

    my %descriptions;

    while (my $line = <FILEIN>){

	chomp $line;
	my @data = split("\t", $line);

	%{ $descriptions{ $data[1] } } = map { $header[$_] => $data[$_] } (0 .. $#header);

    }

    return %descriptions;
} 

sub fisher_right {

    my ($npp, $n1p, $np1, $n11) = @_;

    my $right_value = calculateStatistic( n11=>$n11,
                                      n1p=>$n1p,
                                      np1=>$np1,
				    npp=>$npp);

  if( (my $errorCode = getErrorCode()))
  {
      print STDERR $errorCode." - ".getErrorMessage();
  }
  else
  {
    return $right_value;
  }
}

#          word2   ~word2
#  word1    n11      n12 | n1p
# ~word1    n21      n22 | n2p
#           --------------
#           np1      np2   npp

# where n11 is the number of times <word1><word2> occur together, and n12 is the number of times <word1> occurs with some word other than word2, and n1p is the number of times in total that word1 occurs as the first word in a bigram.
# The fishers exact tests are calculated by fixing the marginal totals and computing the hypergeometric probabilities for all the possible contingency tables,

# A right sided test is calculated by adding the probabilities of all the possible two by two contingency tables formed by fixing the marginal totals and changing the value of n11 to greater than or equal to the given value. A right sided Fisher's Exact Test tells us how likely it is to randomly sample a table where n11 is greater than observed. In other words, it tells us how likely it is to sample an observation where the two words are more dependent than currently observed.

__END__
