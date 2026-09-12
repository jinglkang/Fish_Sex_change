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
```
