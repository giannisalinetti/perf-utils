#!/bin/bash
set -e -o pipefail

echo -e "                    ________           ________________"       
echo -e "_______________________  __/    ____  ___  /___(_)__  /"_______
echo -e "___  __ \  _ \_  ___/_  /________  / / /  __/_  /__  /__  ___/"
echo -e "__  /_/ /  __/  /   _  __//_____/ /_/ // /_ _  / _  / _(__  )" 
echo -e "_  .___/\___//_/    /_/         \__,_/ \__/ /_/  /_/  /____/"  
echo -e "/_/\n"                                                           
echo -e "### Performance analysis and troubleshooting tools collection ###\n" 

# Mount Kernel debugfs (needed by bcc and tracing)
mount -t debugfs none /sys/kernel/debug/

# Install kernel headers for bcc tools
if [[ -n ${install_headers} && ${install_headers} == 'true' ]]; then
    echo "Installing package kernel-devel to provide embedded kernel headers..."
    yum install -y -q kernel-devel
    echo "Package $(rpm -q kernel-devel) installed successfully."
fi

exec "$@"
