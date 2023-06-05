# EASE 2023 – Replication package

[![DOI](https://zenodo.org/badge/533303423.svg)](https://zenodo.org/badge/latestdoi/533303423)

This repository contains the replication package and dataset of the paper published at EASE 2023 (Research track) with the title [**On the Energy Consumption and Performance of WebAssembly Binaries across Programming Languages and Runtimes in IoT**](https://dl.acm.org/doi/10.1145/3593434.3593454).

This study has been designed, developed, and reported by the following investigators:

**Anonymous while under review.**

For any information, interested researchers can contact us by sending an email to any of the investigators listed above.
A full replication package, including the software setup for conducting our experiments, benchmarks, an Ansible and Docker setup package, the final dataset generated, and scripts to analyse and visualize the resulting data are described below. 

## How to cite the dataset
If the dataset and/or experiment setup is helping your research, consider to cite our study as follows, thanks!

```
@inproceedings{10.1145/3593434.3593454,
author = {Wagner, Linus and Mayer, Maximilian and Marino, Andrea and Soldani Nezhad, Alireza and Zwaan, Hugo and Malavolta, Ivano},
title = {On the Energy Consumption and Performance of WebAssembly Binaries across Programming Languages and Runtimes in IoT},
year = {2023},
isbn = {9798400700446},
publisher = {Association for Computing Machinery},
address = {New York, NY, USA},
url = {https://doi.org/10.1145/3593434.3593454},
doi = {10.1145/3593434.3593454},
booktitle = {Proceedings of the 27th International Conference on Evaluation and Assessment in Software Engineering},
pages = {72–82},
numpages = {11},
location = {Oulu, Finland},
series = {EASE '23}
}
```

### Overview of the replication package
---

This replication package is structured as follows:

```
    /
    .
    |--- analysis/                      The data that has been generated through our experiments, scripts to process, analyse, and visualize this data, and the final visualization results.
    |--- applications                   The benchmarks used in our experiments. Four different computational problems, implemented in four different porgramming languages.
    |--- environment                    An Ansible setup used to automatically deploy the experiment setup on multiple network devices at once, and a Docker setup to compile our benchmarks to WASM executables.
    |--- experiment-runner @ 1613d3d    The experiment setup based on an ICSE 2012 tool demo paper. This Git submodule represents our modifications to the original project to fit the needs of this paper.
```

The `experiment-runner @ 1613d3d` is based on *Robot Runner* introduced by Stan Swanborn et al. in [Robot Runner: A Tool for Automatically Executing Experiments on Robotics Software](https://doi.org/10.1109/ICSE-Companion52605.2021.00029), and was forked from [this repository](https://github.com/S2-group/experiment-runner).

Each of the folders listed above are described in details in the remaining of this readme. Crutially, the [USAGE.md](./USAGE.md) describe how to use this replication package in detail.

### Analysis
---
This folder contains the data that has been generated through our experiments, scripts to process, analyse, and visualize this data, and the final visualization results.
```
analysis
    .
    |--- assets/                                        The dataset used to generate visualizations, as well as the final graphs.
        |--- data/                                      The cleaned dataset generated through experimentation.
            |--- dataset_aggregated_benchmarks.tsv      The data is stored as a TSV file, containing all data columns generated per experiment run, including the specific benchmark used, energy usage, execution time, memory usage, and cpu usage.
        |--- plots/                                     The generated plots, based on the dataset above. We generated three different types of plots, taking all data points into account as feasible.
            |--- boxplots
            |--- density
            |--- histograms
    |--- core/                                          A set of basic analysis utilities that is used throughout the analysis and visualization of data repeatedly. This includes effect size estimation, hypothesis testing, normality tests, outlier removal, and more.
    |--- utils/                                         A set of basic utilities to simplify the process of working with our dataset.
        |--- latex/                                     A set of utilities to generate LaTeX code for tables from our data that were used in the final paper.
        |--- fix_decimal_notation.py                    A tool to limit the number of decimal places in our data representation to allow for use in 3rd party tools such as Excel.
        |--- merge_benchmarks_results.py                A tool to group our benchmark data by language and runtime used to simplify the visual inspection.
    |--- visualization/                                 Scripts to generate our final graphs. They use the shared analysis components listed in the 'core' folder above.
        |--- boxplots.r
        |--- density.r
        |--- histograms.r
```

The data in the TSV file has been generated from several results and different experimentat runs. The data was merged by hand, however, this is the only manual interaction within this process.

### Applications
---
This folder contains the benchmarks used in our experiments. Four different computational problems, implemented in four different porgramming languages.
All benchmarks are taken from [The Computer Language Benchmarks Game](https://benchmarksgame-team.pages.debian.net/benchmarksgame/index.html) and, if needed, adapter for our purposes.
They do not use multi-threading, as WASM does not support that out-of-the-box.
```
applications
    .
    |--- binarytrees/       Implementation of the binary tree problem as a benchmark in C, Go, JavaScript, and Rust.
        |--- c/
        |--- go/
        |--- javascript/
        |--- rust/
    |--- helloBenchmark/    Implementation of 'Hello World' to test functionality of compilation to WASM in C, Go, JavaScript, and Rust.
        |--- c/
        |--- go/
        |--- javascript/
        |--- rust/
    |--- nbody/             Implementation of the n-body problem as a benchmark in C, Go, JavaScript, and Rust.
        |--- c/
        |--- go/
        |--- javascript/
        |--- rust/
    |--- spectral-norm/     Implementation of the spectal norm problem as a benchmark in C, Go, JavaScript, and Rust.
        |--- c/
        |--- go/
        |--- javascript/
        |--- rust/
```

### Environment
---
This folder contains an Ansible setup used to automatically deploy the experiment setup on multiple network devices at once, and a Docker setup to compile our benchmarks to WASM executables.
```
environment
    .
    |--- compilation/               A Docker Compose setup to compile our Rust and JavaScript benchmarks automatically to WASM binaries using Docker. C and Go can be compiled using simple commands.
        |--- javascript/            Docker setup to compile JavaScript benchmarks.
            |--- Dockerfile
        |--- rust/                  Docker setup to compile Rust benchmarks.
            |--- Dockerfile
        |--- docker-compose.yaml    Docker Compose file to initialize complilation.
    |--- inventory/                 Inventory directory for Ansible playbooks.
        |--- pi.ini                 Definition of devices the experiment should be setup on, as well as Ansible configuration.
    |--- playbooks/                 Ansible playbooks for the setup of our experiment.
        |--- compilation.yaml       Compilation of benchmarks into WASM binaries.
        |--- docker.yaml            Automatic installation of Docker to enable compilation of JavaScript and Rust using Docker setup.  
        |--- installRunner.yaml     Installation of experiment-runner to setup and run experiments.
        |--- measure.yaml           Install measuring tools used to measure power usage and run time of benchmarks. This includes Time and PowerJoular, as well as the basic Python packages to run Python.
        |--- wasmer.yaml            Install the WASM runtime Wasmer.
        |--- wasmtime.yaml          Install the WASM runtime WasmTime.
```

The following tools are installed and used through this environment setup:

- [Python](https://www.python.org/)
- [Docker](https://www.docker.com/)
- [Time](https://man7.org/linux/man-pages/man1/time.1.html)
- [PowerJoular](https://github.com/joular/powerjoular)
- [experiment-runner](https://github.com/marinoandrea/experiment-runner)
- [Wasmer](https://wasmer.io/)
- [Wasmtime](https://wasmtime.dev/)

### Experiment Runner
---

Our experiment setup uses the [experiment-runner](https://github.com/S2-group/experiment-runner) to execute experiments in a controlled environment. This experiment runner comes with its own documentation, which can be found in the corresponding repository. However, we modified it to fit our needs. We will highlight the most important additions below:

```
experiment-runner @ 1613d3d
    .
    |--- WasmExperiment/                    Folder containing assets required for our experiments.         
        |--- Binaries/                      WASM binaries for each benchmark in each teste language.
        |--- Experiment/                    Experiment setup.
            |--- RunnerConfig.py            Configuration for the experiment runner that uses our custom plugin (see below) to run our experiment and measure results. The configuration we used for our experiment is defined in our paper.
    |--- experiment-runner/
        |--- ConfigValidator/
        |--- EventManager/
        |--- ExperimentOrchestrator/
        |--- ExtendedTyping/
        |--- Plugins/
            |--- Profilers/
            |--- WasmExperiments/           Our custom plugin for this experiment.
                |--- ProcessManager.py      A class wrapping a process. It allows to control the process' execution, as well as monitoring using the 'Time' program.
                |--- Profiler.py            A class providing a basic interface to profile an arbitrary process, as well as a specific implementation for measuring performance with 'ps' and energy consumption using 'PowerJoular'. These profilers are then bundled in a wrapping profiler that measures both for the same process.
                |--- Runner.py              A class providing a simplified interaction interface with the experiment runner, and a implementation of this interface to perform our experiment, handling both, the execution of the correct binaries in a corresponding run, as well as the data measurement using the profiler defined above.
            |--- CodecarbonWrapper.py
        |--- ProcessManager/
    |--- test-standalone/
    |--- test/
    |--- requirements.txt
``` 

## License

**Further information pending.**
