
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
    my ($spe, $cds, $pep);
    $spe =$name{$dir};
    $cds ="$dir/$spe".".cds";
    $pep ="$dir/$spe".".pep";
    my @gffs=<$dir/*.gff>;
    my $gff =$gffs[0]; my %conv;
    open GFF, $gff or die "can not open $gff\n";
    while (<GFF>) {
        chomp;
        my @a=split;
        if ($a[2] && ($a[2] eq "mRNA" || $a[2]=~/gene_segment/)) {
            my ($tranID, $geneID)=$a[8]=~/ID\=(.*?)\;Parent\=(.*?)\;/;
            $conv{$tranID}=$geneID;
        }
    }

    my (%prot, %nucl, %hash1, %hash2); my ($pepfas, $nucfas, $gene, $tran, $seq);
    my (@trans, @genes);
    
    $pepfas ="longest_pep/".$spe.".fas";
    open PEPFAS, ">$pepfas" or die "can not create $pepfas";

    $nucfas ="longest_nuc/".$spe.".fas";
    open NUCFAS, ">$nucfas" or die "can not create $nucfas";

    open PEP, $pep or die "can not open $pep\n";
    while (<PEP>) {
        chomp;
        if (/>/) {
            s/>//;
            $tran=$_;
            push @trans, $tran;
        } else {
            $prot{$tran}.=$_;
        }
    }

    open CDS, $cds or die "can not open $cds\n";
    while (<CDS>) {
        chomp;
        if (/>/) {
            s/>//;
            $tran=$_;
        } else {
            $nucl{$tran}.=$_;
        }
    }

    foreach my $tranid (@trans) {
        $gene=$conv{$tranid};
        unless (defined $gene && $gene ne "") {
            print "WARNING: Cannot map protein ID to gene: $dir\t$spe\t$tranid\n";
            next;
        }

        $hash1{$gene}++;
        push @genes, $gene if $hash1{$gene}==1;
        $seq=$prot{$tranid};
        my $len=length($seq);
        if ($hash2{$gene}) {
            my $oldlen=$hash2{$gene}->{'len'};
            my $newlen=$len;
            if ($newlen > $oldlen) {
                $hash2{$gene}={
                    'tran' => $tranid,
                    'len'  => $len,
                    'seq'  => $seq
                };  
            }
        } else {
            $hash2{$gene}={
                'tran' => $tranid,
                'len'  => $len,
                'seq'  => $seq
            };
        }
    }

    foreach my $geneid (@genes) {
        my $tranid=$hash2{$geneid}->{'tran'};
        my $pepseq=$hash2{$geneid}->{'seq'};
        my $nucseq=$nucl{$tranid};

        print PEPFAS ">$tranid\n$pepseq\n";
        print NUCFAS ">$tranid\n$nucseq\n";
    }
}
