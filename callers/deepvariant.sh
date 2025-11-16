#!/bin/bash
set -euo pipefail

BAM=../data/raw/NA12878_exome.bam
REF=../data/raw/GRCh38.fa
BED=../data/truth/highconf.bed
OUT=NA12878_deepvariant.vcf.gz

docker run --rm -v $(pwd)/../data:/data google/deepvariant:1.6.1 \
  /opt/deepvariant/bin/run_deepvariant \
  --model_type WES \
  --ref /data/raw/GRCh38.fa \
  --reads /data/raw/NA12878_exome.bam \
  --regions /data/truth/highconf.bed \
  --output_vcf /data/$OUT \
  --num_shards 8

mv ../data/$OUT .
mv ../data/$OUT.tbi .
