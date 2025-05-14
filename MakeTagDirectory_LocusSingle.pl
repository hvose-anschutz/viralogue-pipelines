#!/usr/bin/perl 
use strict;
use warnings;

my$File = $ARGV[0];
my$Count = $ARGV[1]-1;
my$numJobs = $ARGV[2];

open(MYFILE, "$File") or die "$!";
my$i=0;
while(defined(my$line = <MYFILE>)){
	chomp($line);
	if($i%$numJobs==$Count){
		$line =~ m/(\d+)\.Strict/;
		my$TagDir = $line;
		my$TagHome = '/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/';
		$TagDir =~ s/\..*//;
		my$SamFile = $TagHome . $line ; #'./SamFiles/Locus/TagDirectory' . $line;
		my$NewTagDir = $TagHome . $TagDir;
		print "NewTagDir is $NewTagDir\n";
		print "File being opened is $SamFile\n";
		`makeTagDirectory $NewTagDir $SamFile -format sam -keepOne`
	}
	$i++;
}
