#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

my $len="Compare_Tlenth.txt";
open LEN, $len or die "can not open $len\n";
while (<LEN>) {
        chomp;
        my @a=split;
        if (/^Assembly/) {
                print "$_\tCompare\n";
        } elsif ($a[-2] > $a[-1]) {
                print "$_\t>\n";
        } elsif ($a[-2] == $a[-1]) {
                print "$_\t==\n";
        } else {
                print "$_\t<\n";
        }
}
