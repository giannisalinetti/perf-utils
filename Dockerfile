FROM docker.io/library/centos
MAINTAINER Gianni Salinetti <gsalinet@redhat.com>

# Install tools from CentOS Repos
RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y \
        perf sysstat pcp pcp-system-tools pcp-pmda-trace \
        python3 lsof tcpdump strace ltrace iotop nmon htop \
        valgrind dmidecode elfutils pciutils man bind-utils fio && \
        hdparm lvm2 iptables nftables && \
    yum clean all -y

# This is needed since bcc make invokes python executable name
RUN alternatives --set python /usr/bin/python3

# Install dependencies to build bcc-tools
RUN yum install -y elfutils-libelf-devel cmake ethtool git iperf3 libstdc++ \
        libstdc++-devel bison flex ncurses-devel python3-netaddr python3-pip \
        gcc gcc-c++ make zlib-devel luajit luajit-devel clang clang-devel \
        llvm llvm-devel llvm-static && \
    yum clean all -y && rm -rf /var/cache/yum

RUN pip3 -q install pyroute2

# Build bcc tools
RUN git clone https://github.com/iovisor/bcc.git && \
    mkdir bcc/build && \
    cd bcc/build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr && \
    make && \
    make install && \
    cd / && \
    rm -rf /bcc

COPY entrypoint.sh pmcd_service.sh /
RUN chmod +x /entrypoint.sh

WORKDIR /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
