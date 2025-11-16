#!/usr/bin/env python
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from pathlib import Path
import json

sns.set(style="whitegrid", font_scale=1.3)

# === Load ROC data from hap.py ===
roc_data = []
for roc_file in Path("results").glob("*.roc.all.csv.gz"):
    caller = roc_file.name.split(".")[0].replace("_", " ").title()
    if "gatk" in caller.lower(): caller = "GATK"
    if "freebayes" in caller.lower(): caller = "FreeBayes"
    if "deepvariant" in caller.lower(): caller = "DeepVariant"

    df = pd.read_csv(roc_file)
    df["Caller"] = caller
    df["FPR"] = 1 - df["SPEC"]
    roc_data.append(df[["FPR", "RECALL", "Caller"]])

roc_df = pd.concat(roc_data)

# === Plot ROC ===
plt.figure(figsize=(8, 7))
for caller in roc_df["Caller"].unique():
    sub = roc_df[roc_df["Caller"] == caller]
    plt.plot(sub["FPR"], sub["RECALL"], label=f"{caller}", linewidth=2.5)

plt.plot([0, 1], [0, 1], 'k--', label="Random")
plt.xlim(0, 1)
plt.ylim(0, 1)
plt.xlabel("False Positive Rate")
plt.ylabel("True Positive Rate (Recall)")
plt.title("ROC Curve: Variant Callers on NA12878 Exome (GIAB High-Conf)")
plt.legend()
plt.tight_layout()
plt.savefig("results/roc_curve.png", dpi=300)
plt.show()

# === Runtime (manually added or via time command) ===
runtimes = {
    "GATK": 245,         # minutes (example)
    "FreeBayes": 78,
    "DeepVariant": 112
}
rt_df = pd.DataFrame(list(runtimes.items()), columns=["Caller", "Runtime (min)"])

plt.figure(figsize=(7, 5))
sns.barplot(data=rt_df, x="Caller", y="Runtime (min)", palette="viridis")
plt.title("Runtime Comparison (NA12878 Exome, 8 cores)")
plt.tight_layout()
plt.savefig("results/runtime.png", dpi=300)
plt.show()

# Save summary
metrics = pd.read_csv("results/metrics_summary.csv")
summary = pd.merge(metrics, rt_df, on="Caller")
summary.to_csv("results/final_summary.csv", index=False)
print("\n=== Final Summary ===")
print(summary)
