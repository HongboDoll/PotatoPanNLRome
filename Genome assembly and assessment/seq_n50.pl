#!/usr/bin/perl -w
#
# Author: Ruan Jue
#
use strict;

my $total = 0;
my @nums = ();

my $len = 0;
while(<>){
	if(/^>/){
		push(@nums, $len),$total+=$len if($len);
		$len = 0;
	} else {
		$len += length($_) - 1;
	}
}
push(@nums, $len),$total+=$len if($len);

my $n_seq = @nums;
my $avg = sprintf("%0.2f", $total / $n_seq);

print "Total:	$total\n";
print "Count:	$n_seq\n";
print "Average:	$avg\n";

my @nxxs = ();
my @l = (0,1,2,3,4,5,6,7,8,9,9.5,9.9,10);
my $n;
foreach $n (@l){
	push(@nxxs, int($total*$n*0.1));
}

push(@nxxs, $total + 1);

my $i = 0;
my $j = 0;

@nums = sort {$b <=> $a} @nums;

my $median = $nums[int($n_seq / 2)];

print "Median:	$median\n";

$len = 0;

for(;$i<@nums;$i++){
	$len += $nums[$i];
	while($nxxs[$j] <= $len){
		if ($j == 10) {
			print "N95".":    $nums[$i]\t". ($i + 1) . "\n";
			$j ++;
		} 
		elsif ($j == 11){
			print "N99".":    $nums[$i]\t". ($i + 1) . "\n";
			$j ++;
		}
		elsif ($j == 12){
            print "N100".":    $nums[$i]\t". ($i + 1) . "\n";
            $j ++;
        }
		else{
			print "N".$j."0:	$nums[$i]\t". ($i + 1) . "\n";
			$j ++;
		}
	}
}

1;
