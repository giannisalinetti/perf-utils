# Perf-Utils - Performance Analisys Utilities

This is the repository of the perf-utils image that holds a set of utilities
for performance analisys and troubleshooting, especially useful on immutable
systems like Fedora CoreOS and Red Hat CoreOS.
Perf-utils is based on CentOS base image.

## Installed Packages
The following packages are installed:
- perf
- bcc-tools
- pcp
- lsof
- sysstat
- tcpdump
- strace
- ltrace
- valgrind
- dmidecode
- elfutils

## How to run
The perf-utils container must be executed as a privileged container. To run it,
use the `run.sh` script or the following:
```
$ sudo podman run -it --rm \
  --privileged --network=host --pid=host \
  -v /lib/modules:/lib/modules:ro -v /usr/src:/usr/src:ro -v /proc:/proc \
  quay.io/gbsalinetti/perf-utils
```

### Maintainers
Gianni Salinetti <gsalinet@redhat.com>
