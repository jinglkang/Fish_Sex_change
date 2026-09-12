#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Parallel::ForkManager;

my @txts=<*.sex.txt>;
foreach my $txt (@txts) {
    my %hash;
    open TXT, $txt or die "can not open $txt\n";
    my $spe;
    while (<TXT>) {
        chomp;
        next if /^Assembly/;
        my @a=split /\t/;
        $spe=$a[-1];
        if ($hash{$spe} && $hash{$spe}->{'numb'} < $a[-2]) {
            $hash{$spe}={
                'info' => $_,
                'numb' => $a[-2]
            };
        } else {
            $hash{$spe}={
            'info' => $_,
            'numb' => $a[-2]
            };
        }
    }
    my $pre=$hash{$spe}->{'info'};
    print "$pre\n";
}
