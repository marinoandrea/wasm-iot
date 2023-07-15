#!/usr/bin/env python3

import pandas as pd
import sys

if __name__ == '__main__':
    input_file = sys.argv[1]

    df = pd.read_csv(input_file)
    df_grouped = df.groupby(["language", "runtime", "id"])
    df_final = df_grouped[["energy_usage", "execution_time", "memory_usage", "storage"]].sum()
    df_final = df_final.join(df_grouped[["cpu_usage"]].mean())

    file_name = f"aggregated-data.csv"
    df_final.to_csv(file_name)  # always writes into cwd. Index needed: Is now languages, runtime and id
