#!/usr/bin/env python
import json
import pandas as pd
from pathlib import Path

results = []

for json_file in Path("results").glob("*summary.json"):
    caller = json_file.name.split(".")[0].replace("_", " ").title()
    if "gatk" in caller.lower():
        caller = "GATK"
    elif "freebayes" in caller.lower():
        caller = "FreeBayes"
    elif "deepvariant" in caller.lower():
        caller = "DeepVariant"

    data = json.load(open(json_file))
    metric = data["summary"]["METRIC"]

    row = {
        "Caller": caller,
        "Precision": float(metric["Precision"]),
        "Recall": float(metric["Recall"]),
        "F1": float(metric["F1_Score"]),
    }
    results.append(row)

df = pd.DataFrame(results)
df.to_csv("results/metrics_summary.csv", index=False)
print(df)
