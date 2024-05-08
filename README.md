# POGIGA (Pocket Giga)

A project that aims to have all the necessary tools to work with your cloud infrastructure in a Docker container. In addition, the project fetches the host cloud configurations (.aws, .kube, .ssh and current directory), and mounts them as volumes inside the container, to facilitate the use of the tools.

## What's in POGIGA?

- Ansible
- Terraform
- AWS CLI v2
- SOPS
- PACU (cloud security testing tool)
- TOFU (opensource alternative to Terraform)

## How to use?

- After cloning this repository, run the `install` file.

```shell
./install
```

Anywhere, just run `pgg` or `pogiga`

## Want to remove POGIGA?

You just need to run the `uninstall` to remove the image, the script, and the alias.

## How does it work?

The `install` file will build an image with the described tools. In addition, it will create a custom command for the execution of `pogiga` in any directory.

When executing `pogiga`, you will be running a `docker run` command from the image previously created with `install`. The command is already configured to not only remove the container after an `exit` (avoiding memory waste with unused containers) and create some volumes:

- `/app`, which mounts the current directory you are in when you executed the command

- `/root/.aws/credentials`, as Read-Only, to take advantage of the AWS credentials already configured by you on the host

- `/root/.ssh`, as Read-Only, to use the host's SSH keys

- `/root/.kube`, as Read-Only, to inherit Kubernetes configurations from the host.

When executing the command, it is possible to pass the flags:

- `-a`: custom path for the AWS credentials file (default: `$HOME/.aws/credentials`)

- `-s`: custom path for the SSH keys directory (default: `$HOME/.ssh`)

- `-k`: custom path for the Kubernetes configurations directory (default: `$HOME/.kube`)

### SOPS and encrypted variable files


For reading encrypted files in our infrastructure, we use the utility lib [sops](https://github.com/getsops/sops). As default, the encryption is made with a AWS KMS stored key, and access to this key is made through AWS credentials.

To read such files, you need:

- The environment variable `AWS_PROFILE`, which points to a profile in your credentials file that has access to the ARN of the key in KMS. By default, this variable is automatically configured by POGIGA using the first profile of your AWS credentials file

- The environment variable `SOPS_ARN_KMS`, which indicates the ARN of the key in KMS. This variable is also automatically configured by POGIGA.

The container have a default `.zshrc` with a script to check if there are any files that satisfies the regex `*.sops.*`, if no `SOPS_KMS_ARN` is passed on mount. If any file matches, it sets the environment variable `SOPS_KMS_ARN` based on the file automatically.

SOPS in POGIGA only supports AWS KMS keys for now.

## Roadmap

- [ ] Automatically read `.pogiga` file on mounting for automatic configuration
- [ ] Addition of support for AGE encryption with SOPS
