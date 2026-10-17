#!/usr/bin/perl
use strict;
use warnings;

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


my @peps=<GCA*.pep>;
foreach my $pep (@peps) {
    my ($id, $spe, $fas);
    ($id)=$pep=~/(.*)\.pep/;
    $spe =$name{$id};


    my $i;
    open PEP, $pep or die "can not open $pep\n";
    while (<PEP>) {
        chomp;
        if (/>/) {
            s/>//;
            $i++;
        }
    }

    my $j;
    $fas =$spe.".fas";
    open FAS, "longest_pep/$fas" or die "can not open longest_pep/$fas";
    while (<FAS>) {
        chomp;
        if (/>/) {
            s/>//;
            $j++;
        }
    }

    print "$spe\t$i\t$j\n";
}
