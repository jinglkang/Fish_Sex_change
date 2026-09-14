#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

my $len="Total_length.txt";
open LEN, $len or die "can not open $len\n";
while (<LEN>) {
        chomp;
        my @a=split;
        if (/^Assembly/) {
                print "$_\tTlength_download\n";
        } else {
                my @fnas=<~/Desktop/Genomes/ncbi_dataset/data/$a[0]/*.fna>;
                my $info=$_;
                open FNA, "$fnas[0]" or die "can not open $fnas[0]\n";
                my $len;
                while (<FNA>) {
                        chomp;
                        next if /^>/;
                        my @b=split;
                        $len+=length($b[0]);
                }
                print "$info\t$len\n";
        }
}
