#!/bin/bash

ARGS="-it --rm --privileged --network=host --pid=host"
MOUNTS="-v /lib/modules:/lib/modules:ro -v /usr/src:/usr/src:ro -v /proc:/proc"
IMG="quay.io/gbsalinetti/perf-utils"

if [ -x /usr/bin/podman ]; then
    /usr/bin/podman run ${ARGS} ${MOUNTS} ${IMG}
elif [ -x /usr/bin/docker]; then
    /usr/bin/docker run ${ARGS} ${MOUNTS} ${IMG}
else
    echo "Fatal: container runtime not installed"
    exit 1
fi
