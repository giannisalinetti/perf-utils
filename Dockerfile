FROM docker.io/library/centos
MAINTAINER Gianni Salinetti <gsalinet@redhat.com>

RUN yum update -y && \
    yum install -y perf bcc-tools sysstat \
    pcp pcp-system-tools pcp-pmda-trace pcp-pmda-bcc \
    python3 lsof tcpdump strace ltrace \
    valgrind dmidecode elfutils pciutils && \
    yum clean all -y

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
