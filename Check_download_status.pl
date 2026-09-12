#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Parallel::ForkManager;

my @folds=<GCA_*>;
foreach my $fold (@folds) {
        my @fnas=<$fold/*.fna>;
        if (@fnas >= 1) {
                print "$fold\t$fnas[0]\n";
        } else {
                system("rm -rf $fold");
        }
}
