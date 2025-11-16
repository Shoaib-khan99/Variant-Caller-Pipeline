# Variant Caller Benchmarking Pipeline 🧬

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.10](https://img.shields.io/badge/python-3.10-blue.svg)](https://www.python.org/downloads/)
[![Conda](https://img.shields.io/badge/conda-managed-green.svg)](https://docs.conda.io/)
[![Docker](https://img.shields.io/badge/docker-supported-blue.svg)](https://www.docker.com/)

A **reproducible bioinformatics pipeline** to benchmark **GATK HaplotypeCaller**, **FreeBayes**, and **DeepVariant** on the **NA12878 exome dataset** using the **Genome in a Bottle (GIAB) high-confidence truth set**.

Generates:
- ROC curves
- Precision, Recall, F1-score
- Runtime comparison
- Publication-ready plots

---

## 📋 Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Repository Structure](#repository-structure)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Step-by-Step Execution](#step-by-step-execution)
- [Results](#results)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Citation](#citation)
- [License](#license)

---

## Overview

This project compares three state-of-the-art **small variant callers**:
| Caller         | Type           | Strengths |
|----------------|----------------|---------|
| **GATK HaplotypeCaller** | GATK Best Practices | High accuracy, widely used |
| **FreeBayes**     | Bayesian haplotype | Fast, good for population data |
| **DeepVariant**   | Deep Learning (CNN) | Excellent in complex regions |

Benchmarked on:
- **Sample**: NA12878 (HG001)
- **Data**: Illumina exome (~100x)
- **Truth**: GIAB v3.3.2 high-confidence VCF + BED
- **Reference**: GRCh38 (no alts)

Evaluation uses **`hap.py`** (from Illumina) with **stratification** and **RTG vcfeval** engine.

---

## Features

- Fully **Dockerized** callers → no local installation
- Automatic data download (GIAB, reference)
- Snakemake-free, simple bash + Python workflow
- `hap.py` stratification & ROC generation
- Pandas + Matplotlib + Seaborn plots
- Runtime tracking
- MIT licensed → free to use/modify

---
## Prerequisites

| Tool        | Requirement |
|-------------|-----------|
| **OS**      | Linux / macOS / WSL2 |
| **Docker**  | [Install Docker](https://docs.docker.com/get-docker/) |
| **Conda**   | [Miniconda](https://docs.conda.io/en/latest/miniconda.html) (recommended) |
| **Storage** | ~25 GB free (data + Docker images) |
| **RAM**     | ≥16 GB recommended |
| **CPU**     | ≥8 threads for DeepVariant |

> **Docker is required** — all tools run in containers.

---

## Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/yourusername/variant-caller-benchmark.git
cd variant-caller-benchmark

# 2. Create conda environment
conda env create -f environment.yml
conda activate variant-benchmark

# 3. Run everything
chmod +x run_all.sh
./run_all.sh


Step-by-Step Execution
1. Download Data
bashbash data/download_data.sh
Downloads:

GRCh38.fa
NA12878_exome.bam + .bai
GIAB truth VCF + high-conf BED

2. Run Callers (Docker)
bashbash callers/gatk.sh
bash callers/freebayes.sh
bash callers/deepvariant.sh
3. Benchmark with hap.py
bashpython benchmark/run_hap.py
4. Parse Results
bashpython benchmark/parse_hap.py
5. Generate Plots
bashpython analysis/plot_roc.py

Results
After running run_all.sh, check the results/ folder:
Example Output
text=== Final Summary ===
      Caller  Precision    Recall        F1  Runtime (min)
0       GATK     0.9972    0.9951    0.9961            245
1   FreeBayes     0.9910    0.9885    0.9897             78
2 DeepVariant     0.9985    0.9978    0.9981            112
Generated Files

roc_curve.png → ROC comparison
runtime.png → Bar plot of runtime
final_summary.csv → Table of metrics
*.roc.all.csv.gz → Raw ROC data


Customization
Change Sample
Edit data/download_data.sh and replace BAM/VCF paths.
Use WGS

Replace exome BAM with WGS
Use full GIAB high-conf regions

Add More Callers

Add .sh script in callers/
Update CALLERS dict in run_hap.py
Re-run

Enable GPU for DeepVariant
bash--make_examples_extra_args="use_ref_for_cram=true" \
--run_deepvariant_extra_args="use_hp_information=true" \
--intermediate_results_dir /tmp \
--num_shards $(nproc) \
--use_gpu


Copyright (c) 2025 Shoaib Khan

Permission is hereby granted, free of charge, to any person obtaining a copy...
See LICENSE for full text.

⭐ Star on GitHub!
If you find this useful, please star the repo!
