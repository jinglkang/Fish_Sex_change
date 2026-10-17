#!/usr/bin/perl
use strict;
use warnings;
use File::Path qw(make_path);

# ATGC percentage threshold
my $threshold = 80.0;

# Input: all *.fas files in current directory
# Output: longest_pep_2/ with unchanged filenames
my $outdir = "longest_pep_2";
make_path($outdir) unless -d $outdir;

my @files = sort glob("*.fas");
die "ERROR: No .fas files found in current directory!\n"
    unless @files;

open my $LOG, ">", "$outdir/removed_sequences.tsv"
    or die "Cannot create removal log: $!\n";

print {$LOG} "File\tSequence_ID\tLength\tATGC_percent\n";

my ($total, $removed, $kept) = (0, 0, 0);

for my $file (@files) {
    open my $IN, "<", $file
        or die "Cannot open $file: $!\n";

    open my $OUT, ">", "$outdir/$file"
        or die "Cannot create $outdir/$file: $!\n";

    my $header;
    my @seq_lines;

    while (my $line = <$IN>) {
        if ($line =~ /^>/) {
            if (defined $header) {
                process_record(
                    $file, $header, \@seq_lines, $OUT, $LOG,
                    \$total, \$removed, \$kept, $threshold
                );
            }

            $header = $line;
            @seq_lines = ();
        }
        else {
            push @seq_lines, $line if defined $header;
        }
    }

    # Process the final sequence in each file
    if (defined $header) {
        process_record(
            $file, $header, \@seq_lines, $OUT, $LOG,
            \$total, \$removed, \$kept, $threshold
        );
    }

    close $IN;
    close $OUT;
}

close $LOG;

print "\nFiltering finished!\n";
print "Input files:      ", scalar(@files), "\n";
print "Total sequences:  $total\n";
print "Sequences kept:   $kept\n";
print "Sequences removed:$removed\n";
print "Output directory: $outdir/\n";
print "Removal log:      $outdir/removed_sequences.tsv\n";

sub process_record {
    my ($file, $header, $seq_lines, $out, $log,
        $total_ref, $removed_ref, $kept_ref, $threshold) = @_;

    my $seq = join("", @$seq_lines);
    $seq =~ s/\s+//g;

    my $len = length($seq);
    return if $len == 0;

    my $atgc = () = $seq =~ /[ATGC]/ig;
    my $pct = 100 * $atgc / $len;

    my ($id) = $header =~ /^>\s*(\S+)/;
    $id = "UNKNOWN" unless defined $id;

    $$total_ref++;

    if ($pct >= $threshold) {
        printf {$log} "%s\t%s\t%d\t%.2f\n",
            $file, $id, $len, $pct;

        $$removed_ref++;
    }
    else {
        print {$out} $header;
        print {$out} @$seq_lines;

        $$kept_ref++;
    }
}
