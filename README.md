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
- bpftrace

The bcc tools were directly compiled to make them work on Linux kernels newer 
than 5.4 (https://github.com/iovisor/bcc/issues/2546).

## How to run
The perf-utils container must be executed as a privileged container. 
To run the container directly from podman/docker CLI:
```
$ sudo podman run -it --rm \
  --privileged --network=host --pid=host \
  -v /lib/modules:/lib/modules:ro -v /usr/src:/usr/src:ro -v /proc:/proc -v /:/mnt/rootdir \
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
  -v /lib/modules:/lib/modules:ro -v /proc:/proc -v /:/mnt/rootdir \
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

### Storage benchmark with fio
Fio is a tool to benchmark storage IOPS and can be useful to evaluate disk 
performances with etcd.
This example of fio show a write/sync test on an RHCOS system. The directory 
used is the /var/tmp of the system (which is writable) mount to the to the 
`/mnt/rootdir/var/tmp` folder in the container:
```
# fio --rw=write --ioengine=sync --fdatasync=1 \
--directory=/mnt/rootdir/var/tmp --size=22m --bs=2300 --name=fiotest
```

The output shows sync percentiles in usecs. One of the main etcd best practices is to 
ensure that the `wal_fsync_duration_seconds` 99th percentile must be under
10ms. This means that etcd should take less than 10ms to write to the wal file,
including both `write` and `fdatasync` syscalls. 

The fio command example above simulates the sequential writes of etcd 
(`--rw=write`) followed by fdatasync (`--fdatasync=1`). The size value is an
approximazione of an etcd write to the wal file.
Update the size accordingly to the average write value of you cluster (write
syscall returns the written bytes in ssize_t format). The following example
uses strace to track down writes to wal files.
```
# strace -p <etcd_pid> -f -e write,fdatasync -yy 2>&1 | grep '\.wal'
```

The output of the fsync/fdatasync from the fio command should be under 10000 usecs.

If the system is already running a consistent workload (like an etcd instance) 
the output of the fsyncs will be greater.


### Running on OpenShift
The provided Helm charts is a useful tool to run a perf-utils pod in OpenShift
with a parametric approach to dynamically provide the node name. You must have 
**cluster-admin** privileges on your cluster.

To install the chart with custom *noodeName*:
```
$ helm install ./helm/perf-utils --set nodeName=master-0 --generate-name
```

Once started you will notice a pod running in the namespace:
```
$ oc get pods
NAME                 READY   STATUS    RESTARTS   AGE
master-0-perfutils   1/1     Running   0          7s
```

You can run `oc rsh` or `oc exec` to run a shell in the container and 
execute commands.
```
$ oc exec -it master-0-perfutils /bin/bash
```

By default the chart sets the host root file system mount point under the `/host` 
folder.

### Maintainers
Gianni Salinetti <gsalinet@redhat.com>
