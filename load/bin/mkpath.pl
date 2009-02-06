#!/usr/bin/perl

use strict;
use File::Path;

my $path = $ARGV[0];
unless ($path)  {
	print "Usage: mkpath.pl [path]\n" unless $path;
	exit(1);
}
mkpath $path;
