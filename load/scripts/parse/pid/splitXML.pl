#!/usr/bin/perl
use XML::DOM;
use ParseUtils;

chomp($ARGV[0]);
chomp($ARGV[1]);

my ($indir, $outdir) = getFullDataPaths("pid/$ARGV[0]");
my ($inFile) = "$indir/$ARGV[1]";
my ($outFile1) = "$indir/Interactions.xml";
my ($outFile2) = "$indir/Pathways.xml";
my ($outFile3) = "$indir/Molecules.xml";


 my $parser = new XML::DOM::Parser;
 my $doc = $parser->parsefile ($inFile);
 my $nodes = $doc->getElementsByTagName ("InteractionList");
 $node=$nodes->item(0);
 print "Number of interactions ", $nodes->getLength ,"\n";
 $f = new FileHandle($outFile1, "w");
 $node->print($f);

 my $nodes = $doc->getElementsByTagName ("PathwayList");
 $node=$nodes->item(0);
 $f = new FileHandle($outFile2, "w");
 $node->print($f);

 my $nodes = $doc->getElementsByTagName ("MoleculeList");
 $node=$nodes->item(0);
 $f = new FileHandle($outFile3, "w");
 $node->print($f);
