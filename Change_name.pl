#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

my %hash;
my $spes="speces_list.txt";
open SPES, $spes or die "can not open $spes\n";
while (<SPES>) {
        chomp;
        my @a=split /\t/;
        $hash{$a[1]}=$a[0];
}

my @folds=<GCA_*>;
foreach my $fold (@folds) {
    my @fnas=<$fold/*.fna>;
    my $name=$hash{$fold};
    if (@fnas >= 1) {
        my $fna=$fnas[0];
        my $newnm=$name.".fa";
        #print "$fna\t$newnm\n";
        system("mv $fna $newnm");
    }
}
