#!/bin/bash
set -euo pipefail

echo "Step 1: Download data"
bash data/download_data.sh

echo "Step 2: Run GATK"
bash callers/gatk.sh

echo "Step 3: Run FreeBayes"
bash callers/freebayes.sh

echo "Step 4: Run DeepVariant"
bash callers/deepvariant.sh

echo "Step 5: Benchmark with hap.py"
python benchmark/run_hap.py

echo "Step 6: Parse results"
python benchmark/parse_hap.py

echo "Step 7: Plot"
python analysis/plot_roc.py

echo "Done! Check results/ folder"
