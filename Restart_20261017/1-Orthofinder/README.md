# Orthofinder构建同源基因
## 1. 运行Orthofinder
```bash
# 激活conda环境
# (base) shichuang001@login01 Sat Oct 17 2026 23:39:49 ~/jlkang/genome_and_gff/sex_change/longest_pep
conda activate orthofinder_env
sbatch orthofinder.job
# Submitted batch job 891368

cat *.fas|grep '>'|wc -l
# 1912182
cat *.fas|grep '>'|sort -u|wc -l
# 1912143
# 表明有的id是重复的
# 把header都改一下: 
cat *.fas|grep '>'|perl -alne '$hash{$_}++;END{foreach $key (keys %hash){print "$key\t$hash{$key}" if $hash{$key}>1}}'
```

以下是重复的，但是我觉得应该不会影响
```txt
>rna-ND5	4
>rna-CYTB	4
>rna-ND6	4
>rna-ND1	4
>rna-ATP6	4
>rna-ND4L	4
>rna-COX3	4
>rna-ATP8	4
>rna-COX1	4
>rna-ND4	4
>rna-COX2	4
>rna-ND2	4
>rna-ND3	4
```

找出可能被判定为核苷酸的序列，可疑序列将会输入至suspicious_proteins.tsv
- perl find_suspicious_proteins.pl
```bash
# (orthofinder_env) shichuang001@login01 Sun Oct 18 2026 00:54:45 ~/jlkang/genome_and_gff/sex_change/longest_pep
perl find_suspicious_proteins.pl
# 产生suspicious_proteins.tsv
```

把判定80%位点为ATCG的序列去除掉
- remove_suspicious_proteins.pl
```bash
# (orthofinder_env) shichuang001@login01 Sun Oct 18 2026 00:54:45 ~/jlkang/genome_and_gff/sex_change/longest_pep
perl remove_suspicious_proteins.pl
```

```txt
Filtering finished!
Input files:      72
Total sequences:  1912182
Sequences kept:   1912088
Sequences removed:94
Output directory: longest_pep_2/
Removal log:      longest_pep_2/removed_sequences.tsv
```

新的全部序列存放于longest_pep_2/
```bash
# (orthofinder_env) shichuang001@login01 Sun Oct 18 2026 01:11:08 ~/jlkang/genome_and_gff/sex_change/longest_pep/longest_pep_2
sbatch orthofinder.job
# Submitted batch job 893022
```
**注意：序列中如果存在被判定为核苷酸序列以及"."，会导致orthofinder一直停留在diamond建库的步骤**
- orthofinder.job
```txt
#!/bin/bash
#SBATCH -J orthofinder # 指定作业名
#SBATCH -p base # 指定队列
#SBATCH -N 1 # 请求节点数
#SBATCH -n 100 # 请求核心数
#SBATCH --gres=gpu:0 # 请求gpu数
#SBATCH -o logs/%j.orthofinder # 标准输出文件
#SBATCH -e logs/%j.orthofinder # 错误输出文件
echo ${SLURM_JOB_NODELIST} # 作业占用节点列表
echo start on $(date) # 开始时间
orthofinder -f ./ -t 100 # 执行命令
echo end on $(date) # 结束时间
```

**orthofinder跑完之后，根据其结果的物种数在iTol里面画图，显示各个物种的性状**
- trait_annotation_itol_corrected.txt
结果发现非性逆转物种太少了，需要增加非性逆转的鱼类
**重新筛选：专注于鲈形目(Perciformes)性别逆转物种。首先，全部基因组的N50必须大于1M；然后，在这些基因组里面被报道有性逆转全部留下；最后，剩下的雌雄异体物种各科每个属只保留一个物种的基因组（假如有多个物种基因组，选择N50最大的那个）**
- filter_genome.pl
