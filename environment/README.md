# Environment
Here are all files located that are used to setup the Raspberry PIs with the needed software.
We use Ansible in version 2.13.2 with Python 3.10.6 and jinja 3.1.2 on the host system.

The folder structure is as follows:
- inventory: contains the definition(s) for the machines that shall be managed by Ansible
- playbooks: contains all playbooks that will be executed. The subdirectories are organized by runtime. Each subdirectory is organized as follows:
  - There is a {runtime_name}.yml that installs the runtime
  - There is at least one {programing_language}.yml that installs everything needed to run code from {programing_language}.
  - There is a folder *resources* containing files accessed by Ansible to, for example, copy to the Pis.
