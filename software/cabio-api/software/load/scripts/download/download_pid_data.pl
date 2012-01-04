#!/usr/bin/perl
use warnings;

$machine="nci6116g.nci.nih.gov";
my $server="\\\\$machine\\L:\\NCICB\\caBIO\\PID_Dump\\Combined Dump 03_10_09";
my $fullname = "$server\\current.031009";
print $fullname;
open my $fh, "<", $fullname or die "$!";
