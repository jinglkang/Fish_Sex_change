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


my @fnas=<GCF*.fna>;
foreach my $fna (@fnas) {
    my ($id, $spe, $nm, $gff);
    ($id)=$fna=~/(GCF_\d+\.\d+?)_.*\.fna/;
    $spe =$name{$id};
    ($nm)=$fna=~/(.*)\.fna/;
    $gff =$nm.".gff";
    print "$id\t$spe\t$nm\t$gff\n";

    unless (-d $id) {
        mkdir $id or die "Cannot create directory $id: $!\n";
        move($fna, $id);
        move($gff, $id);
    }
}
