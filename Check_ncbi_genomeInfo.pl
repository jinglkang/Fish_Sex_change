#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Parallel::ForkManager;

# datasets summary genome taxon 'Monopterus albus' --as-json-lines | dataformat tsv genome --fields accession,assminfo-name,annotinfo-name,annotinfo-release-date,assminfo-level,assmstats-number-of-scaffolds,organism-name

my $spe="Species.txt";
my @cmds; my $i;
open SPE, $spe or die "can not open $spe\n";
while (<SPE>) {
    chomp;
    my $name=$_;
    $i++;
    my $cmd="datasets summary genome taxon \'$name\' --as-json-lines";
    $cmd.=" | dataformat tsv genome --fields accession,assminfo-name,annotinfo-name,annotinfo-release-date,assminfo-level,assmstats-number-of-scaffolds,organism-name > $i.sex.txt";
    $cmd.=" ; [ ! -s \"$i.sex.txt\" ] && rm -f $i.sex.txt";
    #print "$cmd\n";
    push @cmds, $cmd;
}

my $manager = new Parallel::ForkManager(5);
foreach my $cmd (@cmds) {
    $manager->start and next;
    system($cmd);
    $manager->finish;
}
$manager -> wait_all_children;
