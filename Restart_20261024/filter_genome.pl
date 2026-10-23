#!/usr/bin/perl
use strict;
use warnings;

my %hash2;

my $spe = "sex_change_species_20261023_genome_update.txt";

open my $SPE, '<', $spe
    or die "Cannot open $spe: $!\n";

while (my $line = <$SPE>) {
    chomp $line;
    my @a = split /\t/, $line, -1;

    # 输出表头
    if ($a[0] eq "Status") {
        print "$line\n";
        next;
    }

    # Scaffold N50：第14列，即 $a[13]
    my $n50 = $a[13];

    # 跳过缺失或非整数的 N50
    next unless defined $n50 && $n50 =~ /^\d+$/;

    # 筛选 Scaffold N50 >= 1 Mb
    next if $n50 < 1000000;

    # 非 gonochorism 记录直接输出
    if ($a[4] ne "gonochorism") {
        print "$line\n";
        next;
    }

    # 提取属名
    my ($genus) = $a[3] =~ /^([^_]+)/;
    next unless defined $genus;

    my $spec = $a[3];

    $hash2{$genus}{$spec} = {
        N50 => $n50,
        Inf => $line
    };
}

close $SPE;

# 按属遍历，每个属只处理一次
foreach my $genus (sort keys %hash2) {

    my $i = 0;

    # 属内按照 Scaffold N50 降序排列
    foreach my $spec (
        sort {
            $hash2{$genus}{$b}{N50}
                <=>
            $hash2{$genus}{$a}{N50}
        } keys %{ $hash2{$genus} }
    ) {
        $i++;

        # 每个属仅输出 N50 最高的两个物种
        last if $i > 1;

        print "$hash2{$genus}{$spec}{Inf}\n";
    }
}
