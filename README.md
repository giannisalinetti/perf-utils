# Perf-Utils - Performance Analisys Utilities

This is the repository of the perf-utils image that holds a set of utilities
for performance analisys and troubleshooting, especially useful on immutable
systems like Fedora CoreOS and Red Hat CoreOS.
Perf-utils is based on CentOS base image.

## Installed Packages
The following packages are installed:
- perf
- pcp
- pcp-system-tools
- pcp-pmda-trace
- lsof
- sysstat
- tcpdump
- strace
- ltrace
- valgrind
- dmidecode
- elfutils
- python3
- pciutils

# Compiled tools
The following list of tools was directly compiled into the image:
- bcc

The bcc tools were directly compiled to make them usable on Linux kernels newer 
than 5.4 (https://github.com/iovisor/bcc/issues/2546).

## How to run
The perf-utils container must be executed as a privileged container. 
To run it, use the `perf-utils` script or the following podman/docker command:
```
$ sudo podman run -it --rm \
  --privileged --network=host --pid=host \
  -v /lib/modules:/lib/modules:ro -v /usr/src:/usr/src:ro -v /proc:/proc \
  quay.io/gbsalinetti/perf-utils
```

### BCC Tools prerequisites
To use the BCC tools the `kernel-devel` package, which contains kernel headers, 
must be already installed in the host.

### Maintainers
Gianni Salinetti <gsalinet@redhat.com>
