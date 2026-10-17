#!/usr/bin/perl
use strict;
use warnings;
use File::Copy qw(move);

my $info="../Genome_info_download.csv";
my %name;
open INFO, $info or die "can not open $info\n";
while (<INFO>) {
    chomp;
    my @a=split /\,/;
    $a[-1]=~s/\s+$//;
    $a[-1]=~s/\s+/_/g;
    $name{$a[0]}=$a[-1];
}


my @dirs=<GC*>;
foreach my $dir (@dirs) {
    my ($spe, $cds, $pep);
    my (@geno, @gff);
    @geno=glob("$dir/*.fna");
    @gff =glob("$dir/*.gff");
    if ((! @geno) || ((! @gff))) {
        die "we didn't find fna or gff in $dir\n";
    }
    $spe =$name{$dir};
    $cds ="$dir/$spe".".cds";
    $pep ="$dir/$spe".".pep";

    my $cmd1="gffread -g $geno[0] -x $cds -y $pep $gff[0]";
    #print "$cmd1\n";
    system($cmd1);
}
