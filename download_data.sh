#!/bin/bash
set -euo pipefail

mkdir -p raw truth

# Reference: GRCh38 (no alt, decoy, etc.)
wget -O raw/GRCh38.fa.gz https://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/RefSeq_assembly/GCF_000001405.39_GRCh38.p13/genomic.fna.gz
gunzip -c raw/GRCh38.fa.gz > raw/GRCh38.fa
samtools faidx raw/GRCh38.fa

# NA12878 Exome BAM (HG001) - Illumina NovaSeq, ~100x
wget -O raw/NA12878_exome.bam https://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/NA12878/NIST_NA12878_HG001_latest_release/Exome/NIST_NA12878_HG001_GIAB_highconf_v3.3.2_exome.bam
wget -O raw/NA12878_exome.bam.bai https://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/NA12878/NIST_NA12878_HG001_latest_release/Exome/NIST_NA12878_HG001_GIAB_highconf_v3.3.2_exome.bam.bai

# Truth VCF + High-confidence BED
wget -O truth/GIAB_HG001_GRCh38_1_22_v3.3.2_highconf.vcf.gz https://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/release/NA12878_HG001/NISTv3.3.2/GRCh38/HG001_GRCh38_1_22_v3.3.2_highconf.vcf.gz
wget -O truth/GIAB_HG001_GRCh38_1_22_v3.3.2_highconf.vcf.gz.tbi https://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/release/NA12878_HG001/NISTv3.3.2/GRCh38/HG001_GRCh38_1_22_v3.3.2_highconf.vcf.gz.tbi
wget -O truth/highconf.bed https://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/release/NA12878_HG001/NISTv3.3.2/GRCh38/HG001_GRCh38_1_22_v3.3.2_highconf_CGregions.bed.gz
gunzip -c truth/highconf.bed.gz > truth/highconf.bed
