#!/usr/bin/env python3

import pandas as pd
import sys


js_path = sys.argv[1]
rest_path = sys.argv[2]

df_js = pd.read_csv(js_path)
df_rest = pd.read_csv(rest_path)

offset_js = df_rest.index.max() + 1  # because runs start at 0 and this is the last index that you find in the dataset

def update_run_id(run_id):
    [_, some_number] = run_id.split("_")
    return f"run_{int(some_number) + offset_js}"

df_js["__run_id"] = df_js["__run_id"].apply(update_run_id)

df_final = pd.concat([df_rest, df_js])

file_name = f"final-merged-data.csv"
df_final.to_csv(file_name, index=False) # always writes into cwd. Index not needed: was default of Pandas
