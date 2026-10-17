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
