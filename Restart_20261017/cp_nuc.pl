#!/usr/bin/perl
use strict;
use warnings;
use File::Copy qw(move);

my $info="../../Genome_info_download.csv";
my %name;
open INFO, $info or die "can not open $info\n";
while (<INFO>) {
    chomp;
    my @a=split /\,/;
    $a[-1]=~s/\s+$//;
    $a[-1]=~s/\s+/_/g;
    $name{$a[0]}=$a[-1];
}

my @nucs=<GC*cds>;
foreach my $nuc (@nucs) {
    my ($id, $spe, $fas);
    ($id)=$nuc=~/(.*)\.cds/;
    $spe =$name{$id};
    $fas =$spe.".fas";
    #print "cp $nuc longest_nuc/$fas\n";
    system("cp $nuc longest_nuc/$fas");
}
