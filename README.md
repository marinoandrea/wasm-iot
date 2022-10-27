# IoT with WebAssembly: Comparison of Programming Languages and Runtime Environments

This repository contains the experimental setup for the experiments conducted during the Green Lab course 2022 at Vrije Universiteit, Amsterdam.

Our research studies sustainability and performance implications of WASM-based implementations for typical IoT computing tasks. Our aim is to understand the viability of this technology in real-world applications with respect to energy efficiency and memory footprint.

This main repository holds the necessary configuration files and scripts for setting up the testing environment as we aimed for full reproducibility. We leverage [Docker](https://www.docker.com/) (v20.10.18) and [Ansible](https://www.ansible.com/) (v2.13.2) to make this setup as streamlined as possible.

In order to actually run the experiments we leverage the [Experiment Runner](https://github.com/S2-group/experiment-runner) tool which we forked and extended in this [other repository](https://github.com/marinoandrea/experiment-runner-green-lab-2022) (also available as a Git submodule).

## Setup

### Preliminary Dependencies

Our setup is fully automated via Ansible which in turn depends on Python 3. Therefore, these two represent our only direct dependencies. If you have Python 3 installed on your system you can simply run:

```bash
python3 -m pip install --user ansible
```

### Experimental Setup

Our experimental setup uses the localhost for benchmark compilation (targeting WASM) and then transfers the executables to the \[pis\] group which consists of the remote edge devices. We also provide the necessary playbooks to install our selected WASM runtimes on the devices.

The compilation step requires some dependencies. Specifically, we need to setup a Docker + `docker-compose` environment. In order to do so, `ansible` must run with elevated privileges.

#### Install Docker packages

Run the following command, this will prompt you to insert the sudo password for the current user on `localhost`:

```bash
ansible-playbook playbooks/docker.yml -bkK
```

#### Compile Benchmarks

Run the following command to compile all the selected benchmarks for all languages:

```bash
ansible-playbook playbooks/compilation.yml
```
