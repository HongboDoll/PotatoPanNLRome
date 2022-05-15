#!/usr/bin/perl -w

# Author: Ksenia V Krasileva

# This script parses the output of pfam_scan.pl
# Domains are extracted and redundant (lower e-value hits are removed)
# Domains are printed out in the order of apprearance in the query
# Pfam_B domains are skipped

# New in v3.0
#  - parsing of pfam_scan.pl
#  - pfam_scan output is automatically converted to tab separated values
#  - redundant domains are removed 

# New in v3.1
#  - fixed skipping the first domain bug 

use strict;
use warnings;

use Getopt::Long;
use Data::Dumper;

my ($pfam, $evalue_cutoff, $output);
my $verbose="F";

GetOptions(
       'p|pfam:s'        => \$pfam,
       'e|evalue:s'        => \$evalue_cutoff,
       'o|output:s'        => \$output,
       'v|verbose:s'        => \$verbose,
       
);  

my $usage = "usage: perl script.pl <options>
-p|--pfam <pfamscan.out>
-e|--evalue <evalue cutoff>
-o|--output
-v|--verbose <T/F> default F. Display more information about each domain (start, stop, evalue)\n";

open (FILE1, "<", $pfam) or die $usage;

my $line;
my %all_domains;
my %evalue;
my $n=0;
my ($query_id, $ali_from, $ali_to, $env_from, $env_to, $domain_id, $domain_name, $domain_type, $hmm_from, $hmm_to, $hmm_length, $bit_score, $evalue, $signif, $clan, $active_sites);

while ($line = <FILE1> ){
    
    chomp $line; 

    unless ( ($line=~ m/^#/) or ($line eq '') or ($line=~m/Pfam-B_/)) { #skip comment lines

	$line=~ s/\s+/\t/g; #convert space separated table to tab separated table


# Header format
# <seq id> <alignment start> <alignment end> <envelope start> <envelope end> <hmm acc> <hmm name> <type> <hmm start> <hmm end> <hmm length> <bit score> <E-value> <significance> <clan> <predicted_active_site_residues>
	
	($query_id, $ali_from, $ali_to, $env_from, $env_to, $domain_id, $domain_name, $domain_type, $hmm_from, $hmm_to, $hmm_length, $bit_score, $evalue, $signif, $clan, $active_sites) = split (/\t/, $line);

	$n++;

# for each sequence
# store all alignment coordinates and correspondin domain and evalue

	$all_domains{$query_id}{$n}{'start'}=$ali_from;
	$all_domains{$query_id}{$n}{'end'}=$ali_to;
	$all_domains{$query_id}{$n}{'evalue'}=$evalue;
	$all_domains{$query_id}{$n}{'domain'}=$domain_name;

    } 
}

close FILE1;

#print Dumper(\%all_domains); 

# go through all alignments for each sequence
# sample input format                                                                                                                                                                                                          #eliminate nested alignments                                                                                                                                                                                                                     #from overlapping aln, pick one with lower evalue                                                                                                                                                                                                #example 1 
#UCW_Tt-k41_contig_18098	51    420     16    478 PB000097    Pfam-B_97         Pfam-B   199   386   717     21.3   6.1e-05  NA NA      
#UCW_Tt-k41_contig_18098	70    125     67    151 PF12818.2   Tegument_dsDNA    Family   189   244   282     12.7     0.037   0 No_clan  
#UCW_Tt-k41_contig_18098	80    115     78    124 PF00646.28  F-box             Domain     4    39    48     19.2    0.0006   1 CL0271   
#UCW_Tt-k41_contig_18098	440    480    436    482 PF08387.5   FBD               Family     9    49    51     12.9     0.051   0 No_clan  

my %selected_domains;
my ($key1, $key2); #where key1 is sequence id and key2 is a counter

foreach $key1 (keys %all_domains){
  
    my $new_seq=$key1;
    my $saved_start=0;
    my $saved_end=0;
    my $saved_evalue = 100000;
    my $saved_domain = '';
    my $saved_counter = '';
    my $counter;
    my $internal_counter = 0;

    foreach $key2 (sort keys %{ $all_domains{$key1} } ){
	
        my $current_counter=$key2;
        my $current_start = $all_domains{$key1}{$key2}{'start'};
        my $current_end = $all_domains{$key1}{$key2}{'end'};
        my $current_evalue = $all_domains{$key1}{$key2}{'evalue'};
        my $current_domain = $all_domains{$key1}{$key2}{'domain'};

        if ( $current_start > $saved_end ){

            if( $internal_counter != 0) {
                #keep saved domain
                $selected_domains{$key1}{$saved_counter}{'start'} = $saved_start;
                $selected_domains{$key1}{$saved_counter}{'end'} = $saved_end;
                $selected_domains{$key1}{$saved_counter}{'evalue'} = $saved_evalue;
                $selected_domains{$key1}{$saved_counter}{'domain'} = $saved_domain;
            }

            #reset saved
            $saved_start = $current_start;
            $saved_end = $current_end;
            $saved_evalue = $current_evalue;
            $saved_domain = $current_domain;
            $saved_counter = $current_counter;

        }
        
        #next domain overlaps but it is shorter    
        elsif ($current_end < $saved_end ){

            next;

        } 
        
        #next domain overlaps but it is longer
        elsif ($current_end > $saved_end){

             if ($current_evalue < $saved_evalue){ #check for the best evalue
				#print $key1, "\t", $saved_domain, "\t", $saved_evalue, "\t", $current_domain, "\t", $current_evalue, "\n";	
                 #reset saved
                 $saved_start = $current_start;
                 $saved_end = $current_end;
                 $saved_evalue = $current_evalue;
                 $saved_domain = $current_domain;
                 $saved_counter = $current_counter;
             } 	 	 

        }
        $internal_counter++;
 
    } 

	#save the last domain

    $selected_domains{$key1}{$saved_counter}{'start'} = $saved_start;
    $selected_domains{$key1}{$saved_counter}{'end'} = $saved_end;
    $selected_domains{$key1}{$saved_counter}{'evalue'} = $saved_evalue;
    $selected_domains{$key1}{$saved_counter}{'domain'} = $saved_domain;
}


#prepare data for printing

open (FILE2, ">", $output) or die $usage;

my @output_list;
my $output_domain;

foreach $key1 (keys %selected_domains){

	print FILE2 $key1 , "\t";
	
	foreach $key2 (sort keys %{ $selected_domains{$key1} }){
	
	    if ($verbose eq "T"){

		 $output_domain= $selected_domains{$key1}{$key2}{'domain'} . "(" . "start=" . $selected_domains{$key1}{$key2}{'start'} . ", stop=" . $selected_domains{$key1}{$key2}{'end'} . ", evalue=" . $selected_domains{$key1}{$key2}{'evalue'} . ")";

	    }

	    else{

		 $output_domain= $selected_domains{$key1}{$key2}{'domain'};

	    }

	    push (@output_list, $output_domain);

	}

	print FILE2 join("~", @output_list), "\n";
 
	@output_list=(); #re-set output array
}


close FILE2;


__END__
