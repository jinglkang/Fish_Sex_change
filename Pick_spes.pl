#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Parallel::ForkManager;

my $info="Total_genomeInfo.txt";
my %hash;
open INFO, $info or die "can not open $info\n";
while (<INFO>) {
	chomp;
	my @a=split /\t/;
	$hash{$a[-1]}=$_;
}

my $spe="Species.txt";
open SPE, $spe or die "can not open $spe\n";
while (<SPE>) {
	chomp;
	if ($hash{$_}) {
		print "$_\t$hash{$_}\n";
	} else {
		print "$_\n";
	}
}
