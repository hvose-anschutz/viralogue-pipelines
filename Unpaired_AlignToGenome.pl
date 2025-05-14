#!/usr/bin/perl 
use strict;
use warnings;

my$FastqFile = $ARGV[3];

open(MYFILE, $FastqFile) or die "$!";
my$Decider = $ARGV[1] - 1;
my$numJobs = $ARGV[2];
my$i=0;
while(defined(my$line = <MYFILE>)){
	chomp($line);
	if($i%$numJobs==$Decider){	
		my$Cwd = `pwd`;
		my$FastqDir = $ARGV[0];
		chomp($Cwd);
		my$GenomeWd = $Cwd . '/Genomes/mm10';  
		chomp($GenomeWd);      

        my$coolFile = $line;
		my$ClassOutput = $FastqDir . '/' . $line;
		print "$ClassOutput";
		my$TheClassOutput = $Cwd . '/SamFiles/Class/' . $coolFile . '.Loose.mapped_to_mm10';
		my$LocusOutput = $Cwd . '/SamFiles/Locus/' . $coolFile . '.Strict.mapped_to_mm10';

		`STAR --runMode alignReads --runThreadN 12 --genomeDir $GenomeWd --outFilterMultimapNmax 1000000 --outFilterScoreMinOverLread 0 --outFilterMatchNminOverLread 0 --outFilterMatchNmin 0 --outFilterMismatchNmax 2 --readFilesIn $ClassOutput --outFileNamePrefix $TheClassOutput --limitOutSAMoneReadBytes 10000000`;
        
		`STAR --runMode alignReads --runThreadN 12 --genomeDir $GenomeWd --outFilterMultimapNmax 2 --outFilterScoreMinOverLread 0 --outFilterMatchNminOverLread 0 --outFilterMatchNmin 0 --outFilterMismatchNmax 2 --readFilesIn $ClassOutput --outFileNamePrefix $LocusOutput --limitOutSAMoneReadBytes 1000000000`;
		
		

	}
	$i++;
}
