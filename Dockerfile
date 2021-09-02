FROM docker.io/library/fedora
MAINTAINER Gianni Salinetti <gsalinet@redhat.com>

USER root

# Install dependencies to build bcc-tools
RUN dnf update -y && \
    dnf install -y wget elfutils-libelf-devel cmake ethtool iperf3 libstdc++ \
        libstdc++-devel bison flex ncurses-devel python3-netaddr python3-pip \
        gcc gcc-c++ make zlib-devel luajit luajit-devel clang clang-devel \
        llvm llvm-devel llvm-static openssl kernel-devel && \
    dnf clean all -y && rm -rf /var/cache/dnf

# Build bcc tools with libbpf submodule
RUN wget -O /tmp/bcc.tar.gz https://github.com/iovisor/bcc/releases/download/v0.21.0/bcc-src-with-submodule.tar.gz && \
    tar --no-same-owner -zxvf /tmp/bcc.tar.gz -C /tmp && \
    make -C /tmp/bcc/libbpf-tools && \
    sh -c 'find /tmp/bcc/libbpf-tools/ -type f -perm 0755 -exec mv {} /usr/local/bin/ \;' && \
    sh -c 'find /tmp/bcc/libbpf-tools/ -type l -name *dist -o -name *lower -exec mv {} /usr/local/bin/ \;' && \
    rm -rf /tmp/bcc*

# Install Warp binary release
RUN wget -O /tmp/warp_0.5.0_Linux_x86_64.tar.gz https://github.com/minio/warp/releases/download/v0.5.0/warp_0.5.0_Linux_x86_64.tar.gz && \
    tar --no-same-owner -zxvf /tmp/warp_0.5.0_Linux_x86_64.tar.gz -C /tmp && \
    mv /tmp/warp /usr/local/bin && \
    rm -rf /tmp/warp_logo.png /tmp/LICENSE /tmp/README.md

# Install performance and troubleshooting tools
RUN  dnf install -y \
        perf sysstat pcp pcp-system-tools pcp-pmda-trace \
        python3 lsof tcpdump strace ltrace iotop nmon htop \
        valgrind dmidecode elfutils pciutils man bind-utils fio \
        hdparm lvm2 iptables nftables bpftrace && \
    dnf clean all -y

WORKDIR /

COPY entrypoint.sh pmcd_service.sh /
RUN chmod +x /entrypoint.sh /pmcd_service.sh


ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
