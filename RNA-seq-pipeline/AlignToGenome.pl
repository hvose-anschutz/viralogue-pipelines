#!/usr/bin/perl 
use strict;
use warnings;

my$FastqFile = $ARGV[3];
my$GenomeWd = $ARGV[4];

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
		chomp($GenomeWd);      
		
        # SINGLE READ VERSION
        my$R1File = $FastqDir . $line;
        # PAIRED END VERSION
		my$R2File = $line;
		if ($R2File =~ s/_R1/_R2/) {
		    my$R1File = $FastqDir . $line .' '. $FastqDir . $R2File;
		}

		my$lineOutput = $line;
		$lineOutput =~ s/_\d.+//;
		my$ClassOutput = '/scratch/alpine/hvose@xsede.org/SamFiles/Class/' . $lineOutput . '.Loose.mapped_to_hg38';
		my$LocusOutput = '/scratch/alpine/hvose@xsede.org/SamFiles/Locus/' . $lineOutput . '.Strict.mapped_to_hg38';
		
		print "ALL VARIABLES\n";
		print "R1 + R2 File: " . $R1File . "\n";
		print "Class File Output: " . $ClassOutput . "\n";
		print "Locus File Output: " . $LocusOutput . "\n";

		my$ClassOutput = $line;
		$ClassOutput =~ s/_1.+//;
		# $ClassOutput =~ s/.+\///;
		my$TheClassOutput = '/scratch/alpine/hvose@xsede.org/SamFiles/Class/' . $ClassOutput . '.Loose.mapped_to_hg38';
		my$LocusOutput = '/scratch/alpine/hvose@xsede.org/SamFiles/Locus/' . $ClassOutput . '.Strict.mapped_to_hg38';
		
		print "ALL VARIABLES\n";
		print "R1 + R2 File: " . $R1File . "\n";
		print "Class File Output: " . $TheClassOutput . "\n";
		print "Locus File Output: " . $LocusOutput . "\n";

		`STAR --runMode alignReads --runThreadN 12 --genomeDir $GenomeWd --outFilterMultimapNmax 1000000 --outFilterScoreMinOverLread 0 --outFilterMatchNminOverLread 0 --outFilterMatchNmin 0 --outFilterMismatchNmax 2 --readFilesIn $R1File --outFileNamePrefix $TheClassOutput --limitOutSAMoneReadBytes 10000000`;
        
        # my$Command = 'STAR --runMode alignReads --runThreadN 12 --genomeDir '. $GenomeWd . ' --outFilterMultimapNmax 2 --outFilterScoreMinOverLread 0 --outFilterMatchNminOverLread 0 --outFilterMatchNmin 0 --outFilterMismatchNmax 2 --readFilesIn $R1File --outFileNamePrefix '. $LocusOutput --limitOutSAMoneReadBytes 1000000000;
        
        # print "$Command";
        
		#`STAR --runMode alignReads --runThreadN 12 --genomeDir $GenomeWd --outFilterMultimapNmax 2 --outFilterScoreMinOverLread 0 --outFilterMatchNminOverLread 0 --outFilterMatchNmin 0 --outFilterMismatchNmax 2 --readFilesIn $R1File --outFileNamePrefix $LocusOutput --limitOutSAMoneReadBytes 1000000000`;
		
		

	}
	$i++;
}
