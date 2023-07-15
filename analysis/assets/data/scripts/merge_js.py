#!/usr/bin/env python3

import pandas as pd
import sys

if __name__ == '__main__':
    base_file = sys.argv[1]  # path to file to add/merge INTO
    extension_file = sys.argv[2]  # path to file to add/merge FROM

    df_base = pd.read_csv(base_file)
    df_extension = pd.read_csv(extension_file)

    # reindex to better search
    df_extension_only_used = df_extension.loc[df_extension['__run_id'].isin(["run_2", "run_13", "run_14", "run_43", "run_51", "run_55"])]
    df_extension_only_used = df_extension_only_used.set_index("__run_id")

    mapping_update = [
        {
            "origin": "run_2",
            "target": "run_1",
        },
        {
            "origin": "run_13",
            "target": "run_15",
        },
        {
            "origin": "run_14",
            "target": "run_16",
        },
        {
            "origin": "run_43",
            "target": "run_43",
        },
        {
            "origin": "run_51",
            "target": "run_50",
        },
        {
            "origin": "run_55",
            "target": "run_55",
        },
    ]

    cols_to_update = ["__done", "energy_usage", "execution_time", "memory_usage", "cpu_usage", "storage"]

    # the run from origin will be inserted into target. It replaces all values defined in cols_to_update
    for elem in mapping_update:
        origin = df_extension_only_used.loc[elem["origin"]]
        for c in cols_to_update:
            df_base.loc[df_base['__run_id'] == elem["target"], c] = origin[c]

    file_name = f"merged-js.csv"
    df_base.to_csv(file_name, index=False) # always writes into cwd
