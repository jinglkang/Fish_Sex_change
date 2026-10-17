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
里面一些在目录里面，一些在目录外面，把所有的都建立目录并放入目录里面
- create_dir.pl: 建立并移动fna和gff文件至建立的目录中
```bash
# (base) shichuang001@login01 Sat Oct 17 2026 11:33:04 ~/jlkang/genome_and_gff/others
perl create_dir.pl
```

进入每个目录，依次产生每个转录本的cds和pep文件
- Generate_cds_pep.pl
```bash
# (base) shichuang001@login01 Sat Oct 17 2026 14:10:19 ~/jlkang/genome_and_gff/others
perl Generate_cds_pep.pl
```

提取每个基因最长的蛋白序列
- Extract_longest_pep_others.pl: 提取最长蛋白
```bash
# (base) shichuang001@login01 Sat Oct 17 2026 15:30:01 ~/jlkang/genome_and_gff/others
mkdir longest_pep longest_nuc
perl Extract_longest_pep_others.pl
```

比较筛选前后的数量变化
- Compare_pep_nb_others.pl
```bash
# (base) shichuang001@login01 Sat Oct 17 2026 22:38:11 ~/jlkang/genome_and_gff/others
perl Compare_pep_nb_others.pl
```

```txt
GCA_045362495.1	Lethrinus_nebulosus	30201	24231
GCA_054084025.1	Thalassoma_bifasciatum	41049	23309
GCF_001640805.2	Lates_calcarifer	45530	25237
GCF_001952655.1	Monopterus_albus	40441	21462
GCF_011397635.1	Epinephelus_fuscoguttatus	45301	23982
GCF_018320785.1	Cheilinus_undulatus	40068	23382
GCF_021347895.1	Acanthochromis_polyacanthus	46390	23982
GCF_022539595.1	Amphiprion_ocellaris	47359	23152
GCF_022749685.1	Semicossyphus_pulcher	32053	22720
GCF_030273125.1	Centropristis_striata	36638	25038
GCF_036324505.1	Eleginops_maclovinus	39251	22675
GCF_040954835.1	Lepisosteus_oculatus	48447	20712
GCF_052040795.2	Danio_rerio	94111	28558
GCF_053564925.1	Oryzias_latipes	62289	23629
GCF_900324485.3	Mastacembelus_armatus	42615	22612
GCF_900880675.2	Sparus_aurata	53177	26117
GCF_901000725.3	Takifugu_rubripes	46842	22161
GCF_904848185.1	Acanthopagrus_latus	54718	23946
GCF_963584025.1	Labrus_mixtus	39971	22904
GCF_963930695.1	Labrus_bergylta	42708	23571
GCF_964276395.1	Gasterosteus_aculeatus	59192	22929
GCF_965226575.1	Pagrus_pagrus	44931	24345
```

