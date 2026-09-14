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
```
