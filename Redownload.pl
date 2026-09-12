#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Parallel::ForkManager;

my @folds=<data/GCA_*>;
my %hash;
foreach my $fold (@folds) {
        my @fnas=<$fold/*.fna>;
        if (@fnas >= 1) {
                #print "$fold\t$fnas[0]\n";
                $hash{$fold}++;
        } else {
                #system("rm -rf $fold");
        }
}

my $fetch="fetch.txt";
open FETCH, $fetch or die "can not open $fetch\n";
while (<FETCH>) {
        chomp;
        my @a=split /\t/;
        my $id;
        if (/(data\/GCA.*?)\//) {
                $id=$1;
                if ($hash{$id}) {
                        next;
                } else {
                        print "$_\n";
                }
        }
}
