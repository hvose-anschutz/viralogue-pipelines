#!/usr/bin/perl 
use strict;
use warnings;

my$dirList = $ARGV[0];
print $dirList;

open(MYFILE, $dirList) or die "$!";
my$Decider = $ARGV[1] - 1;
my$numJobs = $ARGV[2];
my$i=0;
while(defined(my$line = <MYFILE>)){
	chomp($line);
	if($i%$numJobs==$Decider){	
		print $line . "\n";
		my$fastqB = $line;
		$fastqB =~ s/_R1/_R2/;
		my$prefix = $line;
		$prefix =~ s/_R.+//;
		my$outFile = $prefix . "_FinalContigs.fa";
		
		print $fastqB . "\n";
		print $outFile . "\n";
		
		`megahit -1 $line -2 $fastqB -o $outFile`;
	}
	$i++;
}