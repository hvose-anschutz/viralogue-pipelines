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
		my$GenomeWd = '/projects/hvose@xsede.org/Genomes/mm10';  
		chomp($GenomeWd);      

		my$R2File = $line;
		$R2File =~ s/_1/_2/;
		my$R1File = $FastqDir . $line .' '. $FastqDir . $R2File;

		my$lineOutput = $line;
		$lineOutput =~ s/_1.+//;
		my$ClassOutput = '/scratch/alpine/hvose@xsede.org/SamFiles/Class/' . $lineOutput . '.Loose.mapped_to_hg38';
		my$LocusOutput = '/scratch/alpine/hvose@xsede.org/SamFiles/Locus/' . $lineOutput . '.Strict.mapped_to_hg38';
		
		print "ALL VARIABLES\n";
		print "R1 + R2 File: " . $R1File . "\n";
		print "Class File Output: " . $ClassOutput . "\n";
		print "Locus File Output: " . $LocusOutput . "\n";

		`STAR --runMode alignReads --runThreadN 12 --genomeDir $GenomeWd --outFilterMultimapNmax 1000000 --outFilterScoreMinOverLread 0 --outFilterMatchNminOverLread 0 --outFilterMatchNmin 0 --outFilterMismatchNmax 2 --readFilesIn $R1File --outFileNamePrefix $ClassOutput --limitOutSAMoneReadBytes 10000000`;
        
        # my$Command = 'STAR --runMode alignReads --runThreadN 12 --genomeDir '. $GenomeWd . ' --outFilterMultimapNmax 2 --outFilterScoreMinOverLread 0 --outFilterMatchNminOverLread 0 --outFilterMatchNmin 0 --outFilterMismatchNmax 2 --readFilesIn $R1File --outFileNamePrefix '. $LocusOutput --limitOutSAMoneReadBytes 1000000000;
        
        # print "$Command";
        
		`STAR --runMode alignReads --runThreadN 12 --genomeDir $GenomeWd --outFilterMultimapNmax 2 --outFilterScoreMinOverLread 0 --outFilterMatchNminOverLread 0 --outFilterMatchNmin 0 --outFilterMismatchNmax 2 --readFilesIn $R1File --outFileNamePrefix $LocusOutput --limitOutSAMoneReadBytes 1000000000`;
		
		my$SamFileClass = $ClassOutput . 'Aligned.out.sam';
		my$SamFileLocus = $LocusOutput . 'Aligned.out.sam';
		my$TagDirClass = $SamFileClass;
		my$TagDirLocus = $SamFileLocus;
		$TagDirClass =~ s/\..*//;
		$TagDirLocus =~ s/\..*//;
		
		my$TagHomeClass = '/scratch/alpine/hvose@xsede.org/SamFiles/Class/TagDirectory/' . $TagDirClass;
		my$TagHomeLocus = '/scratch/alpine/hvose@xsede.org/SamFiles/Locus/TagDirectory/' . $TagDirLocus;

		`makeTagDirectory $TagHomeClass $SamFileClass -format sam -keepOne`;
		`makeTagDirectory $TagHomeLocus $SamFileLocus -format sam -keepOne`;

	}
	$i++;
}