# Environment

Here are all files located that are used to setup the Raspberry PIs with the needed software.
We use Ansible in version 2.13.2 with Python 3.10.6 and jinja 3.1.2 on the host system.

The folder structure is as follows:

- inventory: contains the definition(s) for the machines that shall be managed by Ansible
- playbooks: contains all playbooks that will be executed. At the moment, only playbooks to install both WASM runtimes are here.

## Setup

Our experimental setup uses the localhost for benchmark compilation (targeting WASM) and then transfers the executables to the \[pis\] group which consists of the remote edge devices.

The compilation step requires some dependencies. Specifically, we need to setup a Docker + `docker-compose` environment. In order to do so, `ansible` must run with elevated privileges.

### Install Docker packages

Run the following command, this will prompt you to insert the sudo password for the current user on `localhost`:

```bash
ansible-playbook playbooks/docker.yml -bkK
```
