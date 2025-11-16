#!/usr/bin/env python
import os
import subprocess
import json
from pathlib import Path

TRUTH_VCF = "../data/truth/GIAB_HG001_GRCh38_1_22_v3.3.2_highconf.vcf.gz"
CONF_BED = "../data/truth/highconf.bed"
REF = "../data/raw/GRCh38.fa"

CALLERS = {
    "GATK": "NA12878_gatk.vcf.gz",
    "FreeBayes": "NA12878_freebayes.vcf.gz",
    "DeepVariant": "NA12878_deepvariant.vcf.gz"
}

os.makedirs("results", exist_ok=True)

for name, vcf in CALLERS.items():
    out_prefix = f"results/{name.lower()}"
    cmd = [
        "hap.py",
        TRUTH_VCF,
        vcf,
        "-o", out_prefix,
        "-r", REF,
        "-f", CONF_BED,
        "--engine=vcfeval",
        "--stratification", "strat.tsv",
        "-T", CONF_BED
    ]
    print(f"Running hap.py for {name}...")
    subprocess.run(cmd, check=True)

    # Save runtime
    runtime_file = f"results/{name.lower()}_runtime.txt"
    with open(runtime_file, "w") as f:
        f.write("Runtime captured via wrapper script (see logs)\n")
