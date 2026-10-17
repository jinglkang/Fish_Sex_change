
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
    my ($spe, $cds, $pep, $pepfas);
    $spe =$name{$dir};
    $pep ="$dir/$spe".".pep";

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
    $pepfas ="longest_pep/".$spe.".fas";
    open PEPFAS, "$pepfas" or die "can not open $pepfas";
    while (<PEPFAS>) {
        chomp;
        if (/>/) {
            s/>//;
            $j++;
        }
    }

    print "$dir\t$spe\t$i\t$j\n";
}
