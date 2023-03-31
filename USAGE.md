# On the Energy Consumption and Performance of WebAssembly Binaries across Source Programming Languages and Runtime Environments in IoT

[![DOI](https://zenodo.org/badge/533303423.svg)](https://zenodo.org/badge/latestdoi/533303423)

This repository contains the experimental setup for the experiments conducted during the Green Lab course 2022 at Vrije Universiteit, Amsterdam.

Our research studies sustainability and performance implications of WASM-based implementations for typical IoT computing tasks. Our aim is to understand the viability of this technology in real-world applications with respect to energy efficiency and memory footprint.  
For this, we run different benchmarks on a Raspberry Pi 3B.

This main repository holds the necessary configuration files and scripts for setting up the testing environment as we aimed for full reproducibility. We leverage [Docker](https://www.docker.com/) (v20.10.18) and [Ansible](https://www.ansible.com/) (v6.5.0) to make this setup as streamlined as possible.

In order to actually run the experiments we leverage the [Experiment Runner](https://github.com/S2-group/experiment-runner) tool which we forked and extended in this [other repository](https://github.com/marinoandrea/experiment-runner-green-lab-2022) (also available as a Git submodule).

## Folder Structure

This repository is organized in the following subdirectories:

- **analysis**: this folder contains our data analysis scripts (mostly R with some small Python utilities) and our final assets (plots and dataset CSVs).
- **applications** this folder contains our benchmark applications, we relied on [The Computer Language Benchmarks Game](https://salsa.debian.org/benchmarksgame-team/benchmarksgame/) but we slightly modified the algorithms to comply with our runtime requirements.
- **environment**: this folder contains our Docker and Ansible setup configuration (playbooks and `docker-compose` environment) alongside and example of Ansible inventory.
- **experiment-runner**: this submodule refers to our fork of the [Experiment Runner](https://github.com/S2-group/experiment-runner), which we extended to support our experimental setup.

Each subdirectory contains a small README which provides some more details about its content.

## Setup

We have tested our setup on Ubuntu 22.04.1 and Python3.10.6.  
The Raspberry Pi runs Raspberry Pi OS Lite (64-Bit, release 2022-09-22).

### Preliminary Dependencies

Our setup is fully automated via Ansible which in turn depends on Python 3. Therefore, these two represent our only direct dependencies. If you have Python 3 installed on your system you can simply run:

```bash
python3 -m pip install --user ansible==6.5.0
```

If you experience the error `/usr/bin/python3: No module named pip`, you need to install pip. Do this by running

```bash
sudo apt install python3-pip=22.0.2+dfsg-1
```

Make sure to also (permanently) [add `~/.local/bin` to your `$PATH` variable](https://linuxconfig.org/permanently-add-a-directory-to-shell-path) so your shell can resolve the `ansible` command

### Experimental Setup

Our experimental setup uses the localhost for benchmark compilation (targeting WASM) and then transfers the executables to the \[pis\] group which consists of the remote edge devices. We also provide the necessary playbooks to install our selected WASM runtimes on the devices.

The compilation step requires some dependencies. Specifically, we need to setup a Docker + `docker-compose` environment. In order to do so, `ansible` must run with elevated privileges.

#### Install Docker packages on your local system

Run the following command, this will prompt you to insert the sudo password (two times) for the current user on `localhost`:

```bash
ansible-playbook environment/playbooks/docker.yml -bkK
```

Because the playbook adds your user to the `docker` group, you might need to restart your system for the changes to become effective.

#### Compile Benchmarks

Run the following command to compile all the selected benchmarks for all languages:

```bash
ansible-playbook environment/playbooks/compilation.yml
```

## Setup Pi

### Install sshpass

We connect to the Pis with a password. This requires the package `sshpass`:

```bash
sudo apt install sshpass=1.09-1
```

Further, you should once connect to your Pi(s) via `ssh` and add them to your known hosts for Ansible to run properly.

### Configure the inventory

To allow Ansible to connect to the Pis, add your Pi(s) to `environment/inventory/pi.ini`.
In the file committed to this repository, we assume that all Pis have the same username and password. If this is not the case for you, adapt the config by setting the login data as host variables (see [here](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html)).

### Execute the playbooks

To install the tools we use for capturing time and energy, run

```bash
ansible-playbook -v -i environment/inventory/pi.ini environment/playbooks/measure.yml
```

To install Wasmer we use for capturing time and energy, run

```bash
ansible-playbook -v -i environment/inventory/pi.ini environment/playbooks/wasmer.yml
```

To install Wasmtime we use for capturing time and energy, run

```bash
ansible-playbook -v -i environment/inventory/pi.ini environment/playbooks/wasmtime.yml
```
