## 基因组下载（Yulong）
### NCBI获取基因组信息
首先，利用物种拉丁名获取NCBI相关基因组信息，命令如下
```bash
datasets summary genome taxon --inputfile species.txt \
--reference \
--as-json-lines | \
dataformat tsv genome \
--fields accession,assminfo-name,assminfo-level,assmstats-total-number-of-chromosomes,assmstats-number-of-scaffolds,assmstats-total-sequence-len,assmstats-contig-n50,assmstats-scaffold-n50,annotinfo-status,organism-name \
> genomes.tsv
```

其次，根据获取的基因组信息挑选合适的基因组，这里选择了Scaffold N50大于1Mb的基因组作为筛选条件，最终保留了67个基因组。

最后，根据Assembly Accession的号进行下载，命令如下：
```bash
datasets download genome accession --inputfile acc.txt \
--include genome,gff3 \
--dehydrated --filename genomes.zip

unzip genomes.zip -d genomes

datasets rehydrate --directory genomes/
```
### 基因组注释
下载的基因组里，其中有17个基因组带注释信息，如下：
```text
GCF_001952655.1
GCF_900324485.3
GCF_001640805.2
GCF_036324505.1
GCF_963584025.1
GCF_904848185.1
GCF_963930695.1
GCF_965226575.1
GCF_022749685.1
GCA_054084025.1
GCF_900880675.2
GCF_022539595.1
GCF_030273125.1
GCF_021347895.1
GCF_011397635.1
GCA_045362495.1
GCF_018320785.1
```

其余50个基因组则使用Helixer软件进行基因预测，命令如下：
```bash
singularity run -B $PWD --nv helixer-docker_latest.sif Helixer.py \
--species "$genome" \
--temporary-dir . \
--batch-size 16 \
--fasta-path "$genome" --lineage vertebrate \
--gff-output-path "$genome".gff3
```
### 注释结果评估
注释的的结果先使用gffread软件提取对应的蛋白序列，然后使用BUSCO v6.1.0软件基于actinopterygii_odb12数据库进行完整性的评估，命令如下：
```bash
gffread -g $genome -x $genome.cds -y $genome.pep $genome.gff3

busco -i $genome.pep -m prot -l actinopterygii_odb12 --tar
```

## 提取出基因组的每个基因的最长蛋白序列
Genome_info_download.csv # 下载的基因组信息
### 1. 50个自己注释的基因组
把最长的蛋白序列文件放入longest_pep
```bash
# (base) shichuang001@login01 Fri Oct 16 2026 22:31:51 ~/jlkang/genome_and_gff/all_50/busco
mkdir longest_pep
perl Extract_longest_pep.pl
```

比较提取前后蛋白数量发现，提取完最长蛋白的数量居然是一致的。这是因为注释软件Helixer的设计目标是预测每个基因的主要基因模型，通常每个基因只输出一个转录本模型，并不专门预测可变剪接产生的多个isoform
```bash
perl Compare_pep_nb.pl
```

```txt
Amphiprion_percula	28400	28400
Cromileptes_altivelis	27377	27377
Holacanthus_passer	24560	24560
Amphiprion_clarkii	26921	26921
Labroides_dimidiatus	25354	25354
Epinephelus_awoara	28707	28707
Lagodon_rhomboides	28854	28854
Epinephelus_bruneus	29659	29659
Eleutheronema_tetradactylum	25705	25705
Thalassoma_lucasanum	17154	17154
Cephalopholis_panamensis	21235	21235
Chrysiptera_cyanea	27458	27458
Rhabdosargus_sarba	27493	27493
Choerodon_schoenleinii	26301	26301
Cheilinus_chlorourus	26807	26807
Anthias_nicholsi	29281	29281
Scarus_rivulatus	33615	33615
Centropyge_bicolor	23381	23381
Gobius_paganellus	30933	30933
Nemipterus_japonicus	26112	26112
Premnas_biaculeatus	26971	26971
Scarus_rubroviolaceus	35796	35796
Scarus_psittacus	30911	30911
Choerodon_rubescens	26471	26471
Paralabrax_maculatofasciatus	28137	28137
Xyrichtys_novacula	26609	26609
Diplodus_puntazzo	30136	30136
Anthias_anthias	29464	29464
Hypoplectrus_unicolor	28534	28534
Spondyliosoma_cantharus	30513	30513
Ctenolabrus_rupestris	27633	27633
Serranus_cabrilla	26976	26976
Pagellus_erythrinus	29289	29289
Halichoeres_poeyi	26787	26787
Sarpa_salpa	29756	29756
Cephalopholis_fulva	27468	27468
Diplodus_annularis	30491	30491
Serranus_scriba	27306	27306
Symphodus_cinereus	26118	26118
Halichoeres_bivittatus	28081	28081
Halichoeres_radiatus	27826	27826
Diplodus_vulgaris	31204	31204
Spicara_maena	29859	29859
Symphodus_doderleini	26656	26656
Pagellus_bogaraveo	32280	32280
Coris_julis	27870	27870
Labrus_viridis	26964	26964
Symphodus_mediterraneus	26678	26678
Chrysoblephus_laticeps	28766	28766
Thalassoma_pavo	24671	24671
```

### 2. 已经有gff注释文件






