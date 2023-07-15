# Environment

Here are all files located that are used to setup the Raspberry PIs with the needed software.
We use Ansible in version 2.13.2 with Python 3.10.6 and jinja 3.1.2 on the host system.

The folder structure is as follows:

- inventory: contains the definition(s) for the machines that shall be managed by Ansible
- playbooks: contains all playbooks that will be executed.
- dataTransformation: contains Dockerfiles that provide the environment we used to transform our experiment data
