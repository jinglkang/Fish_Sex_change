#!/usr/bin/perl
use strict;
use warnings;

my @files = sort glob("*.fas");
die "No .fas files found\n" unless @files;

open my $OUT, ">", "suspicious_proteins.tsv"
    or die "Cannot create report: $!";

print $OUT "File\tSequence_ID\tLength\tATGC_percent\n";

for my $file (@files) {
    open my $IN, "<", $file or die "Cannot open $file: $!";

    my ($id, $seq) = ("", "");

    while (my $line = <$IN>) {
        chomp $line;
        $line =~ s/\r$//;

        if ($line =~ /^>(.*)/) {
            check_seq($file, $id, $seq, $OUT) if $id ne "";
            $id = $1;
            $id =~ s/\s.*//;
            $seq = "";
        } else {
            $line =~ s/\s+//g;
            $seq .= uc($line);
        }
    }

    check_seq($file, $id, $seq, $OUT) if $id ne "";
    close $IN;
}

close $OUT;
print "Finished: suspicious_proteins.tsv\n";

sub check_seq {
    my ($file, $id, $seq, $out) = @_;
    my $len = length($seq);
    return if $len == 0;

    my $atgc = () = $seq =~ /[ATGC]/g;
    my $pct = 100 * $atgc / $len;

    if ($pct >= 80) {
        printf $out "%s\t%s\t%d\t%.2f\n",
            $file, $id, $len, $pct;
    }
}
