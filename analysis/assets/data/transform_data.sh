#!/bin/sh

# merge JS
python3 scripts/merge_js.py js/base_dataset/run_table.csv js/extension_dataset/run_table.csv

# combine both data
python3 scripts/merge_all_data.py merged-js.csv rest/run_table.csv # first arg name determined by previous script 

# aggregate
python3 scripts/aggregate_data.py final-merged-data.csv # first arg name determined by previous script
