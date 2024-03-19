#!/bin/bash
#Author: Dinith  Oshan
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

#Ensure Data Retention is configured
function check-data-retention {
    grep -Po -- '^\h*max_log_file\h*=\h*\d+\b' /etc/audit/auditd.conf
    grep max_log_file_action /etc/audit/auditd.conf  
    grep ^space_left_action /etc/audit/auditd.conf
    grep -E 'admin_space_left_action\s*=\s*(halt|single)' /etc/audit/auditd.conf
}

#Ensure Changes to the system administration scope (sudoers) is collected (Automated)
function check-changes-admin-scope {

    # Iterate over files in /etc/audit/rules.d/
    for file in /etc/audit/rules.d/*.rules; do
        # Check for relevant rules using awk
        awk '/^ *-w/ && /\/etc\/sudoers/ && / +-p *wa/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$/)' "$file"
    done

    auditctl -l | awk '/^ *-w/ && /\/etc\/sudoers/ && / +-p *wa/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$/)'
         
}
