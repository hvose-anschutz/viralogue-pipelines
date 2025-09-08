#!/usr/bin/perl 
use strict;
use warnings;

my$FastqList = $ARGV[2];

open(MYFILE, $FastqList) or die "$!";
my$Decider = $ARGV[0] - 1;
my$numJobs = $ARGV[1];
my$i=0;
while(defined(my$line = <MYFILE>)){
	chomp($line);
	if($i%$numJobs==$Decider){	
		my$gunzipFile = '/scratch/alpine/hvose@xsede.org/Krishnamurthy_07152025_GEX/' . $line;
		print $gunzipFile; 
		`gunzip $gunzipFile`;
	}
	$i++;
}