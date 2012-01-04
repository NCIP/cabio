#!/usr/bin/perl

use strict;
use ParseUtils;

my $probe_set_id;
my $general_id;
my (@go_array,@LineArr, $genechipname);

my $input_file_name = $ARGV[0];
my $out_file_name = $ARGV[1];

my ($indir,$outdir) = getFullDataPaths('arrays/Affymetrix/HG-U133_Plus2');
my $input_file = "$outdir/$ARGV[0]";
my $out_file = "$outdir/$ARGV[1]";

open (INFILE, "<$input_file") or die "Cannot open \"$input_file\" \n\n";
open (OUTFILE, ">$out_file") or die "Cannot open \"$out_file\" \n\n";
my $tmpVar;
my @tmpArr=();
my @chrArr = ();
my $chrHash = &getChromosomes(5);
my ($chrNumber,$assembly,$chrId);
foreach my $line(<INFILE>) {
	chomp($line);
    @LineArr = split("#", $line);
     $genechipname = $LineArr[1];
	$line = $LineArr[0];	
    @chrArr=();
    if ($line =~ /chr/) {
        if ($line =~ /\s+\/\/\/\s+/) {
            @go_array = split("\/\/\/", $line);
            my $i = 0;
            foreach my $new_line(@go_array) {
                while ($i < $#go_array) {
                    $i = $i + 1;
                    $go_array[$i] =~ s/^\s+//;
                    $go_array[$i] =~ s/\s+$//;
		    $tmpVar = $go_array[$i];
                    $tmpVar =~s/^chr//g;
		    if($tmpVar=~/\;/) {
		    @tmpArr = split ('\;',$tmpVar);
		    $tmpArr[0] =~/(\S+)[p|q|cen](.)*/g;
		    $chrNumber = $1;

			if(($chrNumber =~/_/) && (!(exists($chrHash->{$chrNumber})))) {
			  @chrArr = split('_',$chrNumber);
			  $assembly = $chrNumber;
			  $chrId= "";
			} else {
			   $chrArr[0] = $chrNumber;
			   $assembly = 'GRCh37';
			   $chrId = $chrHash->{$chrNumber};	
			}
			if($tmpArr[1]=~/^[p|q]/) {
		           $tmpArr[1] = $chrNumber.$tmpArr[1];	
		        } 
			chomp($tmpArr[1]);
			chomp($tmpArr[0]);
                    print OUTFILE "$go_array[0],$go_array[$i],$tmpVar,$tmpArr[0],$tmpArr[1],$chrNumber,$chrArr[0],$assembly,$genechipname,$chrId\n";
		    @tmpArr = ();		
		    }elsif($tmpVar =~/\|/) {
		    @tmpArr = split ('\|',$tmpVar);
		    $tmpArr[0] =~/(\S+)[p|q|cen](.)*/g;
		    $chrNumber = $1;

			if(($chrNumber =~/_/) && (!(exists($chrHash->{$chrNumber})))) {
			  @chrArr = split('_',$chrNumber);
			  $assembly = $chrNumber;
			  $chrId= "";
			} else {
			   $chrArr[0] = $chrNumber;
			   $assembly = 'GRCh37';
			   $chrId = $chrHash->{$chrNumber};	
			}
			if($tmpArr[1]=~/^[p|q]/) {
		           $tmpArr[1] = $chrNumber.$tmpArr[1];	
		        } 
                    print OUTFILE "$go_array[0],$go_array[$i],$tmpVar,$tmpArr[0],$tmpArr[1],$chrNumber,$chrArr[0],$assembly,$genechipname,$chrId\n";
		    @tmpArr = ();		
		    } elsif($tmpVar =~/-/) {
		    @tmpArr = split ('-',$tmpVar);
		    $tmpArr[0] =~/(\S+)[p|q|cen](.)*/g;
		    $chrNumber = $1; 
			if(($chrNumber =~/_/) && (!(exists($chrHash->{$chrNumber})))) {
			  @chrArr = split('_',$chrNumber);
			  $assembly = $chrNumber;
			  $chrId= "";
			} else {
			   $chrArr[0] = $chrNumber;
			   $assembly = 'GRCh37';
			   $chrId = $chrHash->{$chrNumber};	
			}
			if($tmpArr[1]=~/^[p|q]/) {
		           $tmpArr[1] = $chrNumber.$tmpArr[1];	
		        } 
                    print OUTFILE "$go_array[0],$go_array[$i],$tmpVar,$tmpArr[0],$tmpArr[1],$chrNumber,$chrArr[0],$assembly,$genechipname,$chrId\n";
		    @tmpArr = ();
		   }		
		    else {
		    $tmpVar =~/(\S+)[p|q|cen](.)*/g;
		    $chrNumber = $1; 
			if(($chrNumber =~/_/) && (!(exists($chrHash->{$chrNumber})))) {
			  @chrArr = split('_',$chrNumber);
			  $assembly = $chrNumber;
			  $chrId= "";
			} else {
			   $chrArr[0] = $chrNumber;
			   $assembly = 'GRCh37';
			   $chrId = $chrHash->{$chrNumber};	
			}
			if($tmpVar=~/^[p|q]/) {
		           $tmpVar = $chrNumber.$tmpVar;	
		        } 
                    print OUTFILE "$go_array[0],$go_array[$i],$tmpVar,$tmpVar,$tmpVar,$chrNumber,$chrArr[0],$assembly,$genechipname,$chrId\n";
		    }
                }
            }
        }
        elsif ($line =~ /\/\/\//) {
            (my $probe_set_id, my $general_id) = ($line =~ /^(.+)\/\/\/(.+)/);
            $general_id =~ s/\s+$//;
                    @chrArr = ();
		    $tmpVar = $general_id;
                    $tmpVar =~s/^chr//g;
                    $tmpVar =~s/^chr//g;
                    if($tmpVar =~/\;/) {
                    @tmpArr = split ('\;',$tmpVar);
		    $tmpArr[0] =~/(\S+)[p|q|cen](.)*/g;
		    $chrNumber = $1; 
			if(($chrNumber =~/_/) && (!(exists($chrHash->{$chrNumber})))) {
			  @chrArr = split('_',$chrNumber);
			  $assembly = $chrNumber;
			  $chrId= "";
			} else {
			   $chrArr[0] = $chrNumber;
			   $assembly = 'GRCh37';
			   $chrId = $chrHash->{$chrNumber};	
			}
			if($tmpArr[1]=~/^[p|q]/) {
		           $tmpArr[1] = $chrNumber.$tmpArr[1];	
		        } 
                   print OUTFILE "$probe_set_id,$general_id,$tmpVar,$tmpArr[0],$tmpArr[1],$chrNumber,$chrArr[0],$assembly,$genechipname,$chrId\n";
                    @tmpArr = ();
                    } elsif($tmpVar =~/\|/) {
                    @tmpArr = split ('\|',$tmpVar);
		    $tmpArr[0] =~/(\S+)[p|q|cen](.)*/g;
		    $chrNumber = $1; 
			if(($chrNumber =~/_/) && (!(exists($chrHash->{$chrNumber})))) {
			  @chrArr = split('_',$chrNumber);
			  $assembly = $chrNumber;
			  $chrId= "";
			} else {
			   $chrArr[0] = $chrNumber;
			   $assembly = 'GRCh37';
			   $chrId = $chrHash->{$chrNumber};	
			}
			if($tmpArr[1]=~/^[p|q]/) {
		           $tmpArr[1] = $chrNumber.$tmpArr[1];	
		        } 
                   print OUTFILE "$probe_set_id,$general_id,$tmpVar,$tmpArr[0],$tmpArr[1],$chrNumber,$chrArr[0],$assembly,$genechipname,$chrId\n";
                    @tmpArr = ();
                    } elsif($tmpVar =~/-/) {
                    @tmpArr = split ('-',$tmpVar);
		    $tmpArr[0] =~/(\S+)[p|q|cen](.)*/g;
		    $chrNumber = $1; 
			if(($chrNumber =~/_/) && (!(exists($chrHash->{$chrNumber})))) {
			  @chrArr = split('_',$chrNumber);
			  $assembly = $chrNumber;
			  $chrId= "";
			} else {
			   $chrArr[0] = $chrNumber;
			   $assembly = 'GRCh37';
			   $chrId = $chrHash->{$chrNumber};	
			}
			if($tmpArr[1]=~/^[p|q]/) {
		           $tmpArr[1] = $chrNumber.$tmpArr[1];	
		        } 
                    print OUTFILE "$probe_set_id,$general_id,$tmpVar,$tmpArr[0],$tmpArr[1],$chrNumber,$chrArr[0],$assembly,$genechipname,$chrId\n";
                    @tmpArr = ();
                   }
                    else {
		    $tmpVar =~/(\S+)[p|q|cen](.)*/g;
		    $chrNumber = $1;
			if(($chrNumber =~/_/) && (!(exists($chrHash->{$chrNumber})))) {
			  @chrArr = split('_',$chrNumber);
			  $assembly = $chrNumber;
			  $chrId= "";
			} else {
			   $chrArr[0] = $chrNumber;
			   $assembly = 'GRCh37';
			   $chrId = $chrHash->{$chrNumber};	
			}
			if($tmpVar=~/^[p|q]/) {
		           $tmpVar = $chrNumber.$tmpVar;	
		        } 
                    print OUTFILE "$probe_set_id,$general_id,$tmpVar,$tmpVar,$tmpVar,$chrNumber,$chrArr[0],$assembly,$genechipname,$chrId\n";
                    }
        }
    }
}

close INFILE;
close OUTFILE;

exit;
