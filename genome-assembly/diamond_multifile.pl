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
		my$diamondDir = '/scratch/alpine/hvose@xsede.org/Assembly/' . $line . '/final.contigs.fa';
		my$outputFile = '/scratch/alpine/hvose@xsede.org/Outputs/KaseyOutputs/' . $line . '.diamondx.nr';
		my$dbDir = '/scratch/alpine/hvose@xsede.org/diamond_dbs/nr.dmnd';
		`diamond blastx --db $dbDir -q $diamondDir -p 32 -o $outputFile --outfmt 6 --max-target-seqs 2`;
	}
	$i++;
}