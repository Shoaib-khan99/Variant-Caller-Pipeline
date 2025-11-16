#!/bin/bash
set -euo pipefail

BAM=../data/raw/NA12878_exome.bam
REF=../data/raw/GRCh38.fa
BED=../data/truth/highconf.bed
OUT=NA12878_gatk.vcf.gz

docker run --rm -v $(pwd)/../data:/data broadinstitute/gatk:4.5.0.0 \
  gatk --java-options "-Xmx16g" HaplotypeCaller \
  -R /data/raw/GRCh38.fa \
  -I /data/raw/NA12878_exome.bam \
  -L /data/truth/highconf.bed \
  -O /data/$OUT \
  --native-pair-hmm-threads 8

mv ../data/$OUT .
bgzip -d $OUT
bgzip $OUT.gz
tabix -p vcf $OUT
