#!/bin/bash
#Author: Dinith  OShan
#Date: 18 March 2024

#There isn't one size fits all to loggiing solutions and enterprises should use what is feasible for them.
#There is a Disparity with 64 bit and 32 bit systems with arch parameter
#64 bit OS requires two parameters and 32 bit requires only one.




## Ensure Auditing is enabled.

#Ensure auditd is installed (Automated)
function verify-auditd-installed {
    dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n'auditd audispd-plugins
}


#Ensure auditd service is enabled(Automated)
function verify-auditd-enabled {
    output=$(systemctl is-enabled auditd) 
    echo $output
}

#Ensure auditd service is active (Autmated)
function verify-auditd-active {
    output=$(systemctl is-active auditd)
    echo 'auditd service: '$output
}

#Ensure aduditing for processes that start prior to auditd is enabled [grub2] (Automated)
function find-grub2 {
    find /boot -type f -name 'grub.cfg' -exec grep -Ph -- '^\h*linux' {} + | grep -v 'audit=1'
}

#Ensure audit_backlog _limit is sufficient
function  check-backlog-limit {
    find /boot -type f -name 'grub.cfg' -exec grep -Ph -- '^\h*linux' {} + | grep -Pv 'audit_backlog_limit=\d+\b'
}

#Ensure audit log storage size is configured
function check_log_storage_size {
    grep -Po -- '^\h*max_log_file\h*=\h*\d+\b' /etc/audit/auditd.conf
}
