# Perf-Utils - Performance Analisys Utilities

This is the repository of the **perf-utils** image that holds a set of utilities
for performance analysis and troubleshooting. It is especially useful on immutable
systems like Fedora CoreOS and Red Hat CoreOS, or production systems where no extra 
packages can be installed.

The perf-utils image is based on the official CentOS base image and is available 
on [quay.io](quay.io/gbsalinetti/perf-utils).

### Warning for production systems
Running some performance tools (like strace) on production environments can impact the 
overall performances of the system. Use them at your own risk.

## Installed Packages
The following packages are installed:
- perf
- pcp
- pcp-system-tools
- pcp-pmda-trace
- lsof
- sysstat
- tcpdump
- iotop
- fio
- nmon
- htop
- strace
- ltrace
- valgrind
- dmidecode
- elfutils
- python3
- pciutils
- bind-utils
- man
- hdparm 
- lvm2 
- iptables 
- nftables

# Compiled tools
The following list of tools was directly compiled from master branch:
- bcc

The bcc tools were directly compiled to make them work on Linux kernels newer 
than 5.4 (https://github.com/iovisor/bcc/issues/2546).

## How to run
The perf-utils container must be executed as a privileged container. 
To run the container directly from podman/docker CLI:
```
$ sudo podman run -it --rm \
  --privileged --network=host --pid=host \
  -v /lib/modules:/lib/modules:ro -v /usr/src:/usr/src:ro -v /proc:/proc \
  quay.io/gbsalinetti/perf-utils
```

The `perf-utils` script from this repository manages the execution of the
container in a simple and fast way:
```
$ sudo ./perf-utils
```

### BCC Tools limitations
To use the BCC tools the `kernel-devel` package, which contains kernel headers, 
must be already installed in the host. 
On production system or distributions like like Red Hat CoreOS, 
which are engineered to be the nodes of OpenShift clusters and are minimal by default.

To workaound this issue, you can use two different approaches.

#### Approach 1: Manual container creation
If you choose to freely run your contianer, first start the container without 
mounting the `/usr/src` host directory:
```
$ sudo podman run -it --rm \
  --privileged --network=host --pid=host \
  -v /lib/modules:/lib/modules:ro -v /proc:/proc \
  quay.io/gbsalinetti/perf-utils
```

When the container is started, install the `kernel-devel` package. The pacakge
comes from the repositories built into the image and could not match the host
kernel version, so the complete functionality of all bcc tools come with no
warranty in this use case.
```
# yum install -y kernel-devel
```

#### Approach 2: Using perf-utils script
If you use the `perf-utils` script from this repository you can simply run:
```
$ sudo ./perf-utils --install-headers
```

With the above flag enabled, the entrypoint script will take care of installing 
the haeders.

Enjoy you bcc tools installed under `/usr/share/bcc/tools`!

### PCP script
Performance Co-Pilot runs the `pmcd` service in the background. While this is
normally started by systemd, the perf-utils container has no init system and
the daemon can be started manually using the file `/pmcd_service.sh`.
To start the service:
```
# /pmcd_service.sh start
```

To stop the service:
```
# /pmcd_service.sh stop
```

### Maintainers
Gianni Salinetti <gsalinet@redhat.com>
