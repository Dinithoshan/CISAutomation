#!/bin/bash

configure_audit_sudo_log() {
    local SUDO_LOG_FILE=$(grep -r 'logfile' /etc/sudoers* | sed -e 's/.*logfile=//;s/,? .*//' -e 's/"//g')

    if [ -n "${SUDO_LOG_FILE}" ]; then
        printf "-w ${SUDO_LOG_FILE} -p wa -k sudo_log_file\n" >> /home/ubuntu/Desktop/50-sudo.rules
    else
        printf "ERROR: Variable 'SUDO_LOG_FILE' is unset.\n"
    fi
}

# Call the function
configure_audit_sudo_log

function audit {
  SUDO_LOG_FILE_ESCAPED=$(grep -r 'logfile' /etc/sudoers* | sed -e 's/.*logfile=//;s/,? .*//' -e 's/"//g' -e 's|/|\\/|g')
  [ -n "${SUDO_LOG_FILE_ESCAPED}" ] && awk -v pattern="SUDO_LOG_FILE_ESCAPED' is unset.\n"
}


# configure_audit_sudo_log

function test {
    grep -w "mounts" /etc/audit/rules.d/*.rules
}

test
