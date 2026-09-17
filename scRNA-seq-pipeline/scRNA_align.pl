#!/usr/bin/perl 
use strict;
use warnings;

my$FastqFile = $ARGV[0];

open(MYFILE, $FastqFile) or die "$!";
my$barcodeList = $ARGV[2];
my$Decider = $ARGV[3] - 1;
my$numJobs = $ARGV[4];
my$i=0;

print "variables: " . $FastqFile . " " . $barcodeList . " " . $Decider . " " . $numJobs . "\n";

while(defined(my$line = <MYFILE>)){
	chomp($line);
	if($i%$numJobs==$Decider){	
		my$Cwd = `pwd`;
		chomp($Cwd);
		my$GenomeWd = $ARGV[1]; 
		chomp($GenomeWd);
		my$OutputFile = $Cwd . "/STAR_scRNA/" . $i . "/";
		my$OutputTmp = $OutputFile . "tmpSTAR_" . $i;

		my$R2File = $line;
		$R2File =~ s/_R1/_R2/g;
		my$R1File = $R2File .' '. $line;
        
		print "processing files " . $R1File . "\n";
		
        `STAR --runThreadN 12 --genomeDir $GenomeWd --readFilesCommand zcat --readFilesIn $R1File --soloType CB_UMI_Simple --soloCBwhitelist $barcodeList --soloBarcodeReadLength 0 --soloCBlen 16 --soloUMIstart 17 --soloUMIlen 12 \\
        --soloStrand Forward --soloUMIdedup 1MM_CR --soloCBmatchWLtype 1MM_multi_Nbase_pseudocounts --soloUMIfiltering MultiGeneUMI_CR --soloCellFilter EmptyDrops_CR --clipAdapterType CellRanger4 --outFilterScoreMin 30 \\
        --soloFeatures Gene --soloMultiMappers EM --outReadsUnmapped Fastx --outSAMtype BAM SortedByCoordinate --outFileNamePrefix $OutputFile --outTmpDir $OutputTmp`;

	}
	$i++;
}