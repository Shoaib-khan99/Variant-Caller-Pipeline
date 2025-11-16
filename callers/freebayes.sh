#!/bin/bash
set -euo pipefail

BAM=../data/raw/NA12878_exome.bam
REF=../data/raw/GRCh38.fa
BED=../data/truth/highconf.bed
OUT=NA12878_freebayes.vcf.gz

docker run --rm -v $(pwd)/../data:/data maxulysse/freebayes:1.3.6 \
  freebayes -f /data/raw/GRCh38.fa \
  --region $(cat /data/truth/highconf.bed | tr '\n' ' ') \
  /data/raw/NA12878_exome.bam > /data/NA12878_freebayes.vcf

bgzip /data/NA12878_freebayes.vcf
tabix -p vcf /data/NA12878_freebayes.vcf.gz

mv /data/NA12878_freebayes.vcf.gz .
mv /data/NA12878_freebayes.vcf.gz.tbi .
