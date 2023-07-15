As described in the paper, we combine the three benchmarks.
Here, we provide both the transformed data as well as the original data.

Because of runtime issues, we were not able to run the whole experiment in one go, but rather had to do three runs that are spread over the folders:
- `rest` contains all runs for C, Go, and Rust
- `js` contains all runs for JavaScript. Because we had to interrupt one full execution, we have here two datasets that we merged: The missing runs in `js/base_dataset` were filled in with some of the runs from `js/extension_data`. That means, that both of these contain raw data that we did not use for our evaluation in their `run_table.csv` and in their `run_XX` folders.

To increase the reproducability, we have added three scripts in `scripts` to combine and aggregate the data properly:
1. `merge_js.py`: Combines both JavaScript runs into a single file (`{TIMESTAMP}_merged-js.csv`) of the same format of `run_table.csv`. It does **NOT** merge the raw data points captured during a single run. If you are interested in these, you need to pick the right folders yourself by hand (look inside the script to see what we use in the end).
2. `merge_all_data.py`: Merges the `run_table.csv` of JavaScript and the other programming languages together. Increases the run_id of JavaScript to not cause collisions.
3. `aggegate_data.py`: Aggregates the data (over the group Language-Runtime-Id sums every other attribute, only cpu_usage is the mean of the three values).

You can execute all three scripts in a row from this folder by running
```
transform_data.sh
```
This will create the required files in this directory.
Note that we require a few dependencies like Pandas. If you want to reuse our requirements.txt, please look in the folder `environment/dataTransformation` for it.
If you want to use docker to avoid setting up your own environment, go to the same directory and execute
```
docker compose up
```
and the files will be created for you.
