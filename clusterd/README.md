# Delivery Orchestrator

## Build

Below are the linux distributions we currently have instructions for.

| Distribution   | Description                          |
| -------------- | -----------------------------------  |
| `ubuntu-24.04` | Ubuntu 24.04.1 (Noble Numbat)        |
| `ubuntu-22.04` | Ubuntu 22.04.1 LTS (Jammy Jellyfish) |
| `rocky-9`      | Rocky Linux 9                        |
| `rocky-8`      | Rocky Linux 8                        |
| `azure-3`      | Azure Linux 3                        |

To build a container image, simply clone the repository to your machine and from inside the `halon-docker/clusterd` directory run the below command, substituting `ubuntu-24.04` with any of the distributions above and the example credentials with those provided by us.

```
HALON_REPO_USER=exampleuser
HALON_REPO_PASS=examplepass
docker build -t halon/clusterd:1.1.2 -f images/ubuntu-24.04/Dockerfile \
             --build-arg HALON_REPO_USER=${HALON_REPO_USER} \
             --build-arg HALON_REPO_PASS=${HALON_REPO_PASS} \
             --platform=linux/amd64 \
             images/ubuntu-24.04
```
