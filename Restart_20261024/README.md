# 重新下载数据，增加雌雄异体的物种
## 重新筛选
**专注于鲈形目(Perciformes)性别逆转物种。首先，全部基因组的N50必须大于1M；然后，在这些基因组里面被报道有性逆转全部留下；最后，剩下的雌雄异体物种各科每个属只保留一个物种的基因组（假如有多个物种基因组，选择N50最大的那个）**
基于sex_change_species_20261023_genome_update.txt，filter_genome.pl得到
- filter_genome.pl
```bash
# (base) kangjingliang@KangdeMacBook-Pro-2 五 10 23 2026 23:40:05 ~/Documents/2026/性逆转/20261023
perl filter_genome.pl > sex_change_species_20261024_genome.txt
```
**从species_20261024.txt中选出鲈形目(Perciformes)的鱼类，里面包含了已经下载(Status:Yes)和未下载基因组的鱼类(Status:No)**
## 下载有注释gff文件的基因组
```bash
# (ncbi_datasets) shichuang001@login01 Fri Oct 23 2026 23:27:44 ~/jlkang/genome_and_gff/sex_change
conda activate ncbi_datasets

nohup datasets download genome accession --inputfile acc_20261023.txt \
--include genome,gff3 \
--dehydrated --filename genomes_20261023_annotated.zip > datasets_download.log 2>&1 &

unzip genomes_20261023_annotated.zip -d genomes_20261023_annotated

nohup datasets rehydrate --directory genomes_20261023_annotated/ > datasets_download.log 2>&1 &
```
其中，Labroides dimidiatus来自于Kang et al. BMC Biology
