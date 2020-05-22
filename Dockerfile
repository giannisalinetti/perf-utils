FROM docker.io/library/centos
MAINTAINER Gianni Salinetti <gsalinet@redhat.com>

RUN yum install -y perf bcc-tools sysstat pcp lsof tcpdump strace ltrace \
    valgrind dmidecode elfutils && \
    yum clean all -y

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
