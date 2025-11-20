#!/usr/bin/perl 
use strict;
use warnings;

my$FastqFile = $ARGV[0];

open(MYFILE, $FastqFile) or die "$!";
my$barcodeList = $ARGV[1];
my$Decider = $ARGV[2] - 1;
my$numJobs = $ARGV[3];
my$i=0;
while(defined(my$line = <MYFILE>)){
	chomp($line);
	if($i%$numJobs==$Decider){	
		my$Cwd = `pwd`;
		chomp($Cwd);
		my$GenomeWd = $ARGV[0]; 
		chomp($GenomeWd);
		my$OutputFile = $Cwd . "/STAR_scRNA/";

		my$R2File = $line;
		$R2File =~ s/_1/_2/;
		my$R1File = $FastqDir . $R2File .' '. $FastqDir . $line;
        
		print "processing files " . $R1File . "\n";
		
        `STAR --runThreadN 8 --genomeDir $GenomeWd --readFilesIn $R1File --soloType CB_UMI_Simple --coloCBwhitelist $barcodeList --soloBarcodeReadLength 0 --soloCBLen 16 --soloUMIstart 17 --soloUMIlen 12 \\
        --soloStrand Forward --soloUMIdedup 1MM_CR --soloCBmatchWLtype 1MM_multi_Nbase_pseudocounts` --soloUMIfiltering MultiGeneUMI_CR --soloCellFilter EmptyDrops_CR --clipAdapterType CellRanger4 --outFilterScoreMin 30 \\
        --soloFeatures Gene --soloMultiMappers EM --outReadsUnmapped Fastx --outFileNamePrefix $OutputFile;

	}
	$i++;
}