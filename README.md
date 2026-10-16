# Sex change
## Genome assembly information download
```bash
# 根据物种名查找ncbi上哪些物种有基因组组装信息
# (base) shichuang001@login01 Thu Sep 03 2026 13:20:23 ~/software
conda create -n ncbi_datasets
conda activate ncbi_datasets
conda install -c conda-forge ncbi-datasets-cli
# (ncbi_datasets) shichuang001@login01 Thu Sep 03 2026 13:30:26 ~/jlkang
mkdir Sexchange; cd Sexchange
# (ncbi_datasets) shichuang001@login01 Thu Sep 03 2026 13:38:46 ~/jlkang/Sexchange
wget https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdmp.zip
unzip taxdmp.zip # names.dmp has the taxon id
conda install -c bioconda perl-app-cpanminus
cpanm Parallel::ForkManager
# datasets summary genome taxon 'Monopterus albus' --as-json-lines | dataformat tsv genome --fields accession,assminfo-name,annotinfo-name,annotinfo-release-date,assminfo-level,assmstats-number-of-scaffolds,organism-name
# (ncbi_datasets) shichuang001@login01 Thu Sep 03 2026 16:40:11 ~/jlkang/Sexchange
nohup perl Check_ncbi_genomeInfo.pl > GenomeInfo_dowload.process 2>&1 &
# [1] 3739056
# There are 1022 species with genome assembly

# 提取出在ncbi上有组装基因组的物种信息及下载编号
mkdir GenomeInfo;mv *.sex.txt GenomeInfo/
# (ncbi_datasets) shichuang001@login01 Thu Sep 03 2026 19:51:05 ~/jlkang/Sexchange/GenomeInfo
perl Keep_spe_withGenome.pl > Total_genomeInfo.txt # Extract the information which has the genome assembly

# 提取出我们感兴趣的物种进行下载
# (ncbi_datasets) shichuang001@login01 Thu Sep 03 2026 19:54:11 ~/jlkang/Sexchange/GenomeInfo
mv Total_genomeInfo.txt ../
# (ncbi_datasets) shichuang001@login01 Thu Sep 03 2026 20:08:19 ~/jlkang/Sexchange
perl Pick_spes.pl > Total_genomeInfo2.txt

# 开始下载：datasets
# (base) shichuang001@login01 Thu Sep 10 2026 21:14:39 ~/jlkang/Sexchange/Genomes
conda activate ncbi_datasets
nohup datasets download genome accession --inputfile accessions.txt --dehydrated --include genome,gff3,gtf --filename fish_genomes.zip > Genomes_download.process 2>&1 &
# [1] 1349424
unzip fish_genomes.zip
nohup datasets rehydrate --directory ./ > Genomes_download.process 2>&1 &

# (base) shichuang001@login02 Sat Sep 12 2026 11:34:55 ~/jlkang/Sexchange/Genomes/ncbi_dataset/data
# 只下载了一部分就停了，检查一下哪些下载好了，没下载好了把它删除
perl Check_download_status.pl
# (base) shichuang001@login02 Sat Sep 12 2026 11:34:55 ~/jlkang/Sexchange/Genomes/ncbi_dataset/
# 修改fetch.txt，已经下载好了的不要再下载，然后再重新下载
perl Redownload.pl > fetch.txt.2
# 把之前的fetch.txt改一下名字，防止重复下载
mv fetch.txt fetch_before.txt; mv fetch.txt.2 fetch.txt
# (ncbi_datasets) shichuang001@login01 Sat Sep 12 2026 11:33:39 ~/jlkang/Sexchange/Genomes
nohup datasets rehydrate --directory ./ > Genomes_download.process 2>&1 &
# [1] 346475

# 更改基因组文件名字: 根据物种和ncbi id的对应关系（speces_list.txt）
# kangjingliang@KangdeMacBook-Pro-2 一  9 14 2026 12:18:26 ~/Desktop/Genomes/ncbi_dataset/data
perl Change_name.pl
# 移除掉有gtf文件的基因组，然后压缩
mv Xyrichtys_novacula.fa Xyrichtys_novacula.gtf ../
tar -zcvf Genomes.tar.gz *.fa
# 有一些基因组太小了，可能没有下载完整，重新下载
# 得确认下基因组是否下载完整
# kangjingliang@KangdeMacBook-Pro-2 一  9 14 2026 15:33:41 ~/Desktop/Genomes
conda create -n bioinfo
# (base) kangjingliang@KangdeMacBook-Pro-2 一  9 14 2026 15:37:06 ~/Desktop/Genomes
conda activate bioinfo
conda install -c bioconda seqkit
datasets summary genome accession --inputfile accessions.txt --as-json-lines | dataformat tsv genome --fields accession,organism-name,assmstats-total-sequence-len > Total_length.txt
perl compare_length_1.pl > Compare_Tlenth.txt
perl compare_length_2.pl > Compare_Tlenth_new.txt
# 有13个没下载完整（>），16个反而多了（<），41个下载完整了
# 服务器里md5sum -c 文件名：校验文件是否下载完整
# Yulong已经下载完整

# 下载基因组信息
datasets summary genome taxon --inputfile species.txt \
--reference \
--as-json-lines | \
dataformat tsv genome \
--fields accession,assminfo-name,assminfo-level,assmstats-total-number-of-chromosomes,assmstats-number-of-scaffolds,assmstats-total-sequence-len,assmstats-contig-n50,assmstats-scaffold-n50,annotinfo-status,organism-name \
> genomes.tsv

# 安装RERconverge
# (base) shichuang001@login01 Tue Sep 15 2026 20:57:45 ~
conda create -n RERconverge
conda activate RERconverge
```
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
