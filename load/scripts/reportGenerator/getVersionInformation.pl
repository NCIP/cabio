#!/usr/bin/perl
use strict;

# Extracts version information from URL wherever applicable
# Declare variables 
my @arrayElements; # array that stores diff parts of URL
my ($dsName, $url, $projectWebSite, $dataSourceVersion, $fileDownloaded, $downloadedFrom);

# Filehandle
my $FH;

# get the URL to download data from
my $url = $ARGV[0] || die "This program needs a URL to parse log information from \n";
my $dsName = $ARGV[1] || die "This program needs a data Source Name to parse log information from \n";

chomp($url);
chomp($dsName);
$downloadedFrom = $url;
# remove the word "ftp://" from the URL
$url =~s/\S+:\/\///g;

# parse the remaining URL
@arrayElements = split('\/',$url);

# First array element is website
$projectWebSite = $arrayElements[0];

# In cases of data sources like CTEP where the ftp site and
# HTTP site differ only slightly
# substitute the ftp with http to get Project Website
if($projectWebSite =~/^ftp/) {
	$projectWebSite =~s/ftp\.?/http:\/\//;
}  else {
	$projectWebSite = "http://".$projectWebSite;	
}

# Last element is file being downloaded
$fileDownloaded = $arrayElements[$#arrayElements-1];

# Loop through remaining array elements to check for
# version information if applicable
# Sometime URL used for download may not contain version information
# In this case, no version information can be extracted automatically
# Remove first and last elements;

shift(@arrayElements);
pop(@arrayElements);

foreach my $var (@arrayElements) {
    
    # UNTIL hitting a digit, it is subdirectory
    # from where file is being downloaded
    if($var =~/\d$/) {
    $dataSourceVersion = $var;
    }
 }
# At this point, if version is not available, print "N.A." as the version
$dataSourceVersion = "N.A." unless($dataSourceVersion);

# Also check if there are chromosome files being downloaded
# If so, replace them with chr* 
$downloadedFrom =~s/chr\S+\.txt\.gz/chr\*\.txt\.gz/;
$downloadedFrom =~s/chr\S+\.flat\.gz/chr\*\.flat\.gz/;

# print the results to the automatic log extraction output file
open FH , ">>caBioDataRefresh.log" || die "Cannot open file caBioDataRefresh.log \n";

print FH "Data Source Name: $dsName \n";
print FH "Project Website: $projectWebSite \n";
print FH "Version: $dataSourceVersion \n";
print FH "Downloaded from: $downloadedFrom \n";
print FH "\n\n"; 
exit;
