#!/usr/bin/perl
use strict;
use warnings;
use XML::Parser::Expat;
use DBI;
use ParseUtils;
my $parser = new XML::Parser::Expat();

my ($indir, $outdir) = getFullDataPaths('cgdc');
chomp($ARGV[0]);
my $inputFileName = "$indir/$ARGV[0]";

# Array for holding tags
my @Tags=();

my $element;

# Fields Extracted from data
my ($tmpAgId, $tmpDisId, $tmpEvId, $geneId, $taxId, $chrId, $geneTvId, $clusterId,$hugoSymbol, $HgncID, $LocusLinkID, $GenbankAccessionID, $RefSeqID, $UniprotID);

my($cnt, $matchedGeneTerm, $NCIGeneConceptCode, $matchedDiseaseTerm, $NCIDiseaseConceptCode, $matchedDrugTerm, $NCIDrugConceptCode);

my($Statement, $role, $PubMedID, $organism, $negationIndicator, $cellineIndicator, $comment, $sentenceStatusFlag, $GeneStatusFlag, $evidenceCodeInFile);

# Hashes to store evidencCode, Gene-Drug and Gene-Disease data
my(%EvidenceCode, %Evidence, %GeneNCI, %DrugNCI, %DiseaseNCI, %RoleCodes);  

# Ids for tables
my ($RoleCodeEntry, $geneEntry, $evEntry, $evCodeEntry, $AgentId, $DiseaseOntologyId);

# Arrays to store Gene-Evidence, Gene-Agent, Gene-Role and Gene-DiseaseOntology maps
my (%GeneEvidenceCode, %CGDC, %EvidenceEvidenceCode, %GeneGeneAlias, %GeneRoleCode,  @GeneAlias, %GeneDiseaseOntology, %GeneAgent);

# hashes to store mappings of locus link, genbank accession and refseq to Unigene.
my (%GeneAgentEvidence, %AgentDev, %GeneDiseaseEvidence, %DiseaseOntology, %geneHash, %locusLinkHash, %accessionHash);

my ($AgentFlag, $DiseaseFlag);
# Initialize all PKs  
$geneEntry = 0; # for CGIA 
$evEntry = 0; # for Evidence
$evCodeEntry = 0; # for EvidenceCode
$AgentId = 0; # for Agent
$DiseaseOntologyId = 0; # for DiseaseOntology 
$RoleCodeEntry = 0; # for Roles

# generate hashes of Id to Unigene-Id mappings 
&getGenes(\%geneHash);
&getGenesViaLocusLink(\%locusLinkHash);
&getGenesViaAccession(\%accessionHash);

# call XML Parser on input file
$parser->setHandlers('Start' => \&sh,'End'   => \&eh,'Char'  => \&ch);
$parser->parsefile($inputFileName); 


#############################################################################

# Handler for start tag
sub sh
{
  my ($p, $el, %atts) = @_;
  #print "Starting element $el with last element being $Tags[$#Tags] \n";
  $el =~s/^\s+//g;
  $el =~s/\s+$//g;
  push(@Tags, $el);
  
  if($el eq 'GeneEntryCollection') {
  open EVIDENCE,">:utf8", "$outdir/evidence.dat" || die "Error opening Evidence.dat \n";
  open AGENT, ">:utf8", "$outdir/agent.dat" || die "Error opening Agent.dat \n";
  open GENE_ROLE, ">:utf8", "$outdir/gene_role.dat" || die "Error: opening GeneRole.dat \n"; 
  open GENE_EV, ">:utf8", "$outdir/gene_evidence.dat" || die "Error opening GeneEvidence.dat \n";
  open GENE_AGENT, ">:utf8","$outdir/gene_agent.dat" || die "Error opening GeneAgent.dat \n";
  open GENE_DISEASE, ">:utf8", "$outdir/gene_disease.dat" || die "Error opening GeneDisease.dat \n";
 open DISEASEONTOLOGY, ">:utf8", "$outdir/diseaseontology.dat" || die "Error opening DiseaseOntology.dat \n";
 open EVIDENCECODE, ">:utf8", "$outdir/evidencecode.dat" || die "Error opening EvidenceCode.dat \n";
  open GENEGENEALIAS, ">:utf8", "$outdir/gene_genealias.dat" || die "Error opening Gene_GeneAlias.dat \n";
  open EVEVIDENCECODE, ">:utf8", "$outdir/evidence_evidencecode.dat" || die "Error opening Ev_EvCode.dat \n";
  open ROLECODE, ">:utf8", "$outdir/rolecodes.dat" || die "Error opening RoleCodes.dat \n";
  open CGDC, ">:utf8", "$outdir/cgdc.dat" || die "Error opening CGDC.dat \n";
  open GAE, ">:utf8", "$outdir/gae.dat" || die "Error opening GAE.dat \n";
  open GDE, ">:utf8", "$outdir/gde.dat" || die "Error opening GDE.dat \n";
  }
  
  if($el eq 'GeneEntry') {
  $geneEntry++; 
  }
  if($el eq 'Roles') {
  $role = ""; 
  }

}

sub eh
{
  my ($p, $el) = @_;
#  $el =s/^\s+//g;
#  $el =~s/\s+$//g;
#  print "Ending tag $el comparing with $Tags[$#Tags] \n";
  if($el eq $Tags[$#Tags]) {
  pop(@Tags);
  }

 if($el eq 'GeneEntry') {
 $geneId = "";
 $geneTvId = "";
 $chrId = "";
 $taxId = "";
 $clusterId = "";
 $Statement = "";
 $PubMedID = "";
 $role = "";	
 $negationIndicator = "";
 $comment = "";
 $cellineIndicator = "";
 $sentenceStatusFlag = "";
 @GeneAlias = ();
 $AgentFlag=0;
 $DiseaseFlag=0;
 }
 
  # HUGO Gene Symbol
  if ($el eq 'HUGOGeneSymbol') {
  $hugoSymbol = $element;
  if (exists ($geneHash{$hugoSymbol})) {
  $geneTvId = $geneHash{$hugoSymbol};
  ($geneId, $chrId, $taxId)= split(/\|/, $geneTvId);
  } 
  }

  if ($el eq 'GeneAlias') {
  push (@GeneAlias, $element);
  }

  # HGNC Id
  if ($el eq 'HgncID') {
  $HgncID = $element;
  }

  # LocusLink Id
  if ($el eq 'LocusLinkID') {
  $LocusLinkID = $element;
  if (exists($locusLinkHash{$LocusLinkID})) {
  $geneTvId = $locusLinkHash{$LocusLinkID};
  ($geneId, $chrId, $taxId)= split(/\|/, $geneTvId);
  &loadAlias($geneId, $geneTvId, \@GeneAlias);
  }
  }

  # Genbank Accession
  if ($el eq 'GenbankAccessionID') {
  $GenbankAccessionID = $element;
  if(exists($accessionHash{$GenbankAccessionID})){
  $geneTvId = $accessionHash{$GenbankAccessionID};
  ($geneId, $chrId, $taxId)= split(/\|/, $geneTvId);
  &loadAlias($geneId, $geneTvId, \@GeneAlias);
  } 
  }


  # RefSeq Id
  if ($el eq 'RefSeqID') {
  $RefSeqID = $element;
  if(exists($accessionHash{$RefSeqID})){
  $geneTvId = $accessionHash{$RefSeqID};
  ($geneId, $chrId, $taxId)= split(/\|/, $geneTvId);
  &loadAlias($geneId, $geneTvId, \@GeneAlias);
  } 
  }

  # Uniprot
  if ($el eq 'UniprotID') {
  $UniprotID = $element;
  }
  if ($el eq 'GeneStatusFlag') {
  $GeneStatusFlag = $element;
  }

  # DiseaseOntology
  if ($el eq 'MatchedDiseaseTerm') {
  $matchedDiseaseTerm = $element;
  $DiseaseFlag=1;
  }
  if ($el eq 'NCIDiseaseConceptCode') {
  $NCIDiseaseConceptCode = $element;
  my @tmpDisCodeId;

  # At this stage, we know whether it is a human or mouse data
  # Hence add disease terms data only for those genes
  if($geneId && (!(exists($DiseaseNCI{$matchedDiseaseTerm})))) {
  $DiseaseOntologyId++;
  $DiseaseNCI{$matchedDiseaseTerm} = $DiseaseOntologyId."|".$NCIDiseaseConceptCode."|".$geneTvId;
  $GeneDiseaseOntology{$geneId}{$DiseaseOntologyId} = 'XX'; 
  $tmpDisId = $DiseaseOntologyId;	
  } elsif ($geneId) {
  @tmpDisCodeId = split(/\|/,$DiseaseNCI{$matchedDiseaseTerm});
  $GeneDiseaseOntology{$geneId}{$tmpDisCodeId[0]} = 'XX'; 
  $tmpDisId = $tmpDisCodeId[0];	
  }
  @tmpDisCodeId = ();
  $cnt = 0;
}
  
  # Matched Agent term
  # At this stage, we know whether it is a human or mouse data
  # Hence add drug terms data only for those genes
  if ($el eq 'DrugTerm') {
  $matchedDrugTerm = $element;
  $AgentFlag = 1;
  }
  if ($el eq 'NCIDrugConceptCode') {
  my @tmpAgentIdArr;
  $NCIDrugConceptCode = $element;
  if($geneId && (!(exists($DrugNCI{$matchedDrugTerm})))) {
  $AgentId++;
  $DrugNCI{$matchedDrugTerm} = $AgentId."|".$NCIDrugConceptCode."|".$geneTvId;
  $GeneAgent{$geneId}{$AgentId} = 'XX'; 
  $tmpAgId = $AgentId;
  } elsif ($geneId) {
  @tmpAgentIdArr = split(/\|/,$DrugNCI{$matchedDrugTerm});
  $GeneAgent{$geneId}{$tmpAgentIdArr[0]} = 'XX'; 
  $tmpAgId = $tmpAgentIdArr[0];
  }
  @tmpAgentIdArr = ();
  $cnt = 0;
  }
 
  # Evidence Information
  if($el eq 'Sentence') {
  $evEntry++;
  } 
  if ($el eq 'Statement') {
  $Statement = $element;
  }
  if ($el eq 'PubMedID') {
  $PubMedID = $element;
  }
  if ($el eq 'Organism') {
  $organism = $element;
  }
  if ($el eq 'NegationIndicator') {
  $negationIndicator = $element;
  }
  if ($el eq 'CellineIndicator') {
  $cellineIndicator = $element;
  }
  if ($el eq 'Comments') {
  $comment = $element;
	if(length($comment)> 254) {
  $comment = substr($comment,0,254);
   }
  }
  if ($el eq 'EvidenceCode') {
   $evidenceCodeInFile = $element;
   } 
  
 if ($el eq 'SentenceStatusFlag') {
  $sentenceStatusFlag = $element;
  my $tmpEvCodeId;
  $tmpEvId="";
  if($geneId) {
    # By this time, Evidence is read
    # check if evidence exists in the Evidence Hash
    # Evidence is a unique combination of Pubmed Id and Sentence
    my $evKey = $PubMedID."|".$Statement."|".$sentenceStatusFlag."|".$comment;
 if(!exists($Evidence{$evKey})) {
   $evEntry++;
   $Evidence{$evKey} = $evEntry."|".$geneId."|".$geneTvId."|".$Statement."|".$negationIndicator."|".$cellineIndicator."|".$comment."|".$PubMedID."|".$sentenceStatusFlag; 
    $tmpEvId = $evEntry;
     } else {
      my $tmpEvData = $Evidence{$evKey};
      my @tmpEvArrData = split (/\|/,$tmpEvData);
      $tmpEvId = $tmpEvArrData[0]; 
     }

  if(!exists($EvidenceCode{$evidenceCodeInFile})) {
    $evCodeEntry++;
    $tmpEvCodeId = $evCodeEntry;
    $EvidenceCode{$evidenceCodeInFile} = $evCodeEntry;
    }  else {
   $tmpEvCodeId = $EvidenceCode{$evidenceCodeInFile};
   }
   $GeneEvidenceCode{$geneId}{$tmpEvId}{$tmpEvCodeId} = 1;
   if(!(exists($EvidenceEvidenceCode{$tmpEvId}{$tmpEvCodeId}))) {
   $EvidenceEvidenceCode{$tmpEvId}{$tmpEvCodeId} = 1;
   }
  } 
 
   $role = "Not assigned" unless $role;	
 
   if ($geneId && $DiseaseFlag) {
   #print "$tmpEvId is evidence key for sentence $Statement \n"; 
   #	print "I create an association for GFA Gene Disease \n";
    $GeneDiseaseEvidence{$geneId}{$tmpDisId}{$tmpEvId}{$role} = 1;
    }
    if ($geneId && $AgentFlag) {
   # print "$tmpEvId is evidence key for sentence $Statement \n"; 
   #	print "I create an association for GFA Gene Agent \n";
   #     print "$geneId $tmpAgId $tmpEvId $role \n"; 
	$GeneAgentEvidence{$geneId}{$tmpAgId}{$tmpEvId}{$role} = 1;
    }

   }
  
  # NCI and Other Roles
  if ($el eq 'PrimaryNCIRoleCode') {
  my $tmpRoleId;
  $role = $element;	
   if($geneId && (!exists($RoleCodes{$role}))) {
     $RoleCodeEntry++;
     $RoleCodes{$role} = $RoleCodeEntry;
     $GeneRoleCode{$geneId}{$role} = 1; 
  }elsif($geneId) {
   $tmpRoleId = $RoleCodes{$role};
   $GeneRoleCode{$geneId}{$role} = 1; 
  }
  }
  
  if ($el eq 'OtherRole') {
  my $tmpRoleId;
  $role = $element;
  if($geneId && (!exists($RoleCodes{$role}))){
  $RoleCodeEntry++;
  $RoleCodes{$role} = $RoleCodeEntry;
  $GeneRoleCode{$geneId}{$role} = 1; 
  } elsif ($geneId) {
   $tmpRoleId = $RoleCodes{$role};
   $GeneRoleCode{$geneId}{$role} = 1; 
  }
 }

  if($el eq $Tags[$#Tags]) {
  pop(@Tags);
  }

 
if($el eq 'GeneEntryCollection') {
 print  AGENT "DRUGTERM|AGENT_ID|EVS_ID|GENE_ID|CHR_ID|TAX_ID\n"; 
 foreach my $drugTerm (sort keys %DrugNCI) {
 print AGENT "$drugTerm|$DrugNCI{$drugTerm}\n";
 }
 close AGENT;

 print "Printing Gene-Role \n";
 print  GENE_ROLE "GENE_ID|NCI_ROLE_ID\n"; 
  foreach my $gId (sort keys %GeneRoleCode) {
  foreach my $RCode (sort keys %{$GeneRoleCode{$gId}}) {
   print GENE_ROLE "$gId|$RCode\n";
  }
  }
  close GENE_ROLE; 

 print "Printing Role codes \n";
 print ROLECODE "RoleName|RoleId \n";
 foreach my $roleCode (sort keys %RoleCodes) {
 print  ROLECODE "$roleCode|$RoleCodes{$roleCode}\n";
 }
 close ROLECODE;

 print "Printing Gene-Evidence \n";
 print  GENE_EV "GENE_ID|EVID_ID|EVID_CODE\n";
     foreach my $gId (sort keys %GeneEvidenceCode) {
      foreach my $evid (sort keys %{$GeneEvidenceCode{$gId}}) {
         foreach my $evidCode (sort keys %{$GeneEvidenceCode{$gId}{$evid}}) {
     print GENE_EV "$gId|$evid|$evidCode\n";
     }
     }
     }
  close GENE_EV;

 print "Printing Gene-Agent \n";
 print  GENE_AGENT "GENE_ID|AGENT_ID\n";
  foreach my $gId (sort keys %GeneAgent) {
      foreach my $agId (sort keys %{$GeneAgent{$gId}}) {
   print GENE_AGENT "$gId|$agId|$GeneAgent{$gId}{$agId}\n";
  }
  }
  close GENE_AGENT;

 print "Printing Gene-Disease \n";
 print  GENE_DISEASE "GENE_ID|DISEASE_TERM\n";
  foreach my $gId (sort keys %GeneDiseaseOntology) {
  foreach my $disTerm (sort keys %{$GeneDiseaseOntology{$gId}}) {
   print GENE_DISEASE "$gId|$disTerm|$GeneDiseaseOntology{$gId}{$disTerm}\n";
  } 
  }
  close GENE_DISEASE;
 
 close CGDC;

 print  GAE "GENE_ID|AGENT_ID|EVIDENCE_ID\n";
  foreach my $gId (sort keys %GeneAgentEvidence) {
  foreach my $agTerm (sort keys %{$GeneAgentEvidence{$gId}}) {
  foreach my $evidenceId (keys %{$GeneAgentEvidence{$gId}{$agTerm}}) {
  foreach my $roleId (keys %{$GeneAgentEvidence{$gId}{$agTerm}{$evidenceId}}) {

	print GAE "$gId|$agTerm|$evidenceId|$roleId\n";
   }
   }
   }
   }
  close GAE;

 print  GDE "GENE_ID|DISEASE_ID|EVIDENCE_ID\n";
  foreach my $gId (sort keys %GeneDiseaseEvidence) {
  foreach my $disTerm (keys %{$GeneDiseaseEvidence{$gId}}) {
  foreach my $evidenceId (sort keys %{$GeneDiseaseEvidence{$gId}{$disTerm}}) {
  foreach my $roleId (sort keys %{$GeneDiseaseEvidence{$gId}{$disTerm}{$evidenceId}}) {

	print GDE "$gId|$disTerm|$evidenceId|$roleId\n";
   }
   }
   }
   }
  close GDE;

 print "Printing Evidence-EvidenceCode \n";
 print  EVEVIDENCECODE "EVIDENCE_ID|EVIDENCECODE_ID\n";
  foreach my $evId (sort keys %EvidenceEvidenceCode) {
  foreach my $evCodeId (sort keys %{$EvidenceEvidenceCode{$evId}}) {
   print EVEVIDENCECODE "$evId|$evCodeId\n";
  } 
  }
  close EVEVIDENCECODE;


 print DISEASEONTOLOGY "DISEASE_TERM|DIS_ID|EVS_ID|GENE_ID|HIST_ID|PARENT|CONCEPT_CODE\n";
 foreach my $disTerm (sort keys %DiseaseNCI) {
 print DISEASEONTOLOGY "$disTerm|$DiseaseNCI{$disTerm}\n";
 }
 close DISEASEONTOLOGY;

 print "Printing Evidence \n";
 print EVIDENCE "ID|STATEMENT|SENTENCE_STATUS_FLAG|COMMENT|NEGATIONINDIC|CELLLINEINDIC|COMMENT|PUBMED|SENTSTATUSFLAG\n";
 foreach my $ev (sort keys %Evidence) {
 print EVIDENCE "$Evidence{$ev}\n";
 }
 close EVIDENCE;

 print "Printing EvidenceCode \n";
 foreach my $evCode (sort keys %EvidenceCode) {
 print EVIDENCECODE "$evCode|$EvidenceCode{$evCode}\n";
 }
 close EVIDENCECODE;

 print "Printing GeneGeneAlias \n";
 foreach my $gId (sort keys %GeneGeneAlias) {
 foreach my $alias (sort keys %{$GeneGeneAlias{$gId}}) {
 print GENEGENEALIAS "$gId|$alias|$GeneGeneAlias{$gId}\n";
 }
}
 close GENEGENEALIAS;
}

# Set element to NULL each time, before reading a new tag
$element = "";
}

sub ch
{
  my ($p, $el) = @_;
  chomp($el);
  $el =~s/^\s+//g;
  $el =~s/\s+$//g;	
  $el =~s/\|//g; 	
  $element.=$el;

}

sub loadAlias() {
 my ($geneId, $geneTvId, $arrRef) = @_;
 foreach my $alias (@$arrRef)  {
  $GeneGeneAlias{$geneId}{$alias} = $geneTvId; 
 }
}

sub getGenes() {
my ($geneId, $symbol, $clusterId, $chromosomeId, $taxonId);
$geneId = "";
$symbol = "";
$clusterId = "";
$chromosomeId = "";
$taxonId = "";
my $hashRef = shift;
my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die "Error ".DBI->errstr;
my $sql = qq(SELECT distinct GENE_ID, HUGO_SYMBOL, CLUSTER_ID, CHROMOSOME_ID, TAXON_ID from GENE_TV where HUGO_SYMBOL IS NOT NULL);
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$geneId, \$symbol, \$clusterId, \$chromosomeId, \$taxonId);
while ($sth->fetch()) {
  $hashRef->{$symbol} = $geneId."|".$chromosomeId."|".$taxonId;
 }
}

sub getGenesViaLocusLink() {
my ($geneId, $symbol, $clusterId, $EntrezgeneId, $chromosomeId, $taxonId);
$geneId = "";
$symbol = "";
$clusterId = "";
$chromosomeId = "";
$taxonId = "";
$EntrezgeneId = ""; 
my $hashRef = shift;
my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die "Error ".DBI->errstr;
my $sql = qq(SELECT distinct GENE_ID, GENEID, substr(UNIGENE_CLUSTER,4), CHROMOSOME_ID, TAXON_ID from GENE_TV a, ZSTG_GENE2UNIGENE b where a.CLUSTER_ID = substr(b.UNIGENE_CLUSTER,4) and a.SYMBOL is NOT NULL and decode(substr(b.unigene_cluster,0,2),'Hs',5,'Mm', 6)=a.TAXON_ID);
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$geneId, \$EntrezgeneId, \$clusterId, \$chromosomeId, \$taxonId);
while ($sth->fetch()) {
 $hashRef->{$EntrezgeneId} = $geneId."|".$chromosomeId."|".$taxonId;
 }
}

sub getGenesViaAccession() {
my ($rnaNucAcc, $protAcc, $genNucAcc, $geneId, $symbol, $clusterId, $EntrezgeneId, $chromosomeId, $taxonId);
$protAcc = "";
$genNucAcc = "";
$geneId = "";
$symbol = "";
$clusterId = "";
$EntrezgeneId = "";
$chromosomeId = "";
$taxonId = "";
$rnaNucAcc = "";
my $hashRef = shift;
my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die "Error ".DBI->errstr;
my $sql = qq(SELECT distinct GENE_ID, c.GENEID, substr(UNIGENE_CLUSTER,4), c.PROTEIN_ACCESSION, GENOMIC_NUCLEOTIDE_ACC, RNA_NUCLEOTIDE_ACC, CHROMOSOME_ID, TAXON_ID from GENE_TV a,ZSTG_GENE2UNIGENE b, ZSTG_GENE2ACCESSION c where b.GENEID = c.GENEID and a.CLUSTER_ID = substr(b.UNIGENE_CLUSTER,4) and a.SYMBOL is NOT NULL and decode(substr(b.unigene_cluster,0,2),'Hs',5, 'Mm',6) = a.taxon_id);
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$geneId, \$EntrezgeneId, \$clusterId, \$protAcc, \$genNucAcc, \$rnaNucAcc, \$chromosomeId, \$taxonId);
 my ($accNo,$dot);
while ($sth->fetch()) {
# remove the .1 BEFORE
 ($accNo, $dot) = split(/\./,$protAcc);
 if( ($accNo ne "") && ($accNo ne "-")) {
 $hashRef->{accNo} = $geneId."|".$chromosomeId."|".$taxonId;
  }
 ($accNo, $dot) = split(/\./,$genNucAcc); 
 if(($accNo ne "") && ($accNo ne "-")) {
 $hashRef->{$accNo} = $geneId."|".$chromosomeId."|".$taxonId;
 }
 ($accNo, $dot) = split(/\./,$rnaNucAcc); 
 if( ($accNo ne "") && ($accNo ne "-")) {
 $hashRef->{$accNo} = $geneId."|".$chromosomeId."|".$taxonId;
 }
 
 }
}
