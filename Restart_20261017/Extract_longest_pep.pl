
#!/usr/bin/perl
use strict;
use warnings;

my $info="../../Genome_info_download.csv";
my %name;
open INFO, $info or die "can not open $info\n";
while (<INFO>) {
    chomp;
    my @a=split /\,/;
    $a[-1]=~s/\s+$//;
    $a[-1]=~s/\s+/_/g;
    $name{$a[0]}=$a[-1];
}


my @peps=<GCA*.pep>;
foreach my $pep (@peps) {
    my (%hash1, %hash2, %hash3); my ($id, $spe, $fas, $gene, $tran, $seq);
    my (@trans, @genes);
    ($id)=$pep=~/(.*)\.pep/;
    print "Current file: $pep\n";
    print "Extracted ID: $id\n";
    $spe =$name{$id};
    if (! defined $spe) {
        die "ERROR: Cannot find ID '$id' in $info\n";
    }
    
    $fas =$spe.".fas";
    open FAS, ">longest_pep/$fas" or die "can not create longest_pep/$fas";

    open PEP, $pep or die "can not open $pep\n";
    while (<PEP>) {
        chomp;
        if (/>/) {
            s/>//;
            $tran=$_;
            push @trans, $tran;
        } else {
            $hash1{$tran}.=$_;
        }
    }

    foreach my $tranid (@trans) {
        ($gene)=$tranid=~/(.*?)\.\d+$/;
        $hash2{$gene}++;
        push @genes, $gene if $hash2{$gene}==1;
        $seq=$hash1{$tranid};
        my $len=length($seq);
        if ($hash3{$gene}) {
            my $oldlen=$hash3{$gene}->{'len'};
            my $newlen=$len;
            if ($newlen > $oldlen) {
                $hash3{$gene}={
                    'tran' => $tranid,
                    'len'  => $len,
                    'seq'  => $seq
                };  
            }
        } else {
            $hash3{$gene}={
                'tran' => $tranid,
                'len'  => $len,
                'seq'  => $seq
            };
        }
    }

    foreach my $geneid (@genes) {
        my $tranid=$hash3{$geneid}->{'tran'};
        my $seqs  =$hash3{$geneid}->{'seq'};
        print FAS ">$tranid\n$seqs\n";
    }
}
