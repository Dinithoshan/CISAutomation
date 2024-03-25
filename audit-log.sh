#!/bin/bash
#Author: Dinith  Oshan
#Date: 18 March 2024

#There isn't one size fits all to loggiing solutions and enterprises should use what is feasible for them.
#There is a Disparity with 64 bit and 32 bit systems with arch parameter
#64 bit OS requires two parameters and 32 bit requires only one.





## Ensure Auditing is enabled.
#Ensure auditd is installed (Automated) 4.1.1.1
function verify-auditd-installed {
    dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n'auditd audispd-plugins
}

#Ensure auditd service is enabled(Automated) 4.1.1.2
function verify-auditd-enabled {
    output=$(systemctl is-enabled auditd)
    echo $output
}

#Ensure auditd service is active (Autmated) 4.1.1.2
function verify-auditd-active {
    output=$(systemctl is-active auditd)
    echo 'auditd service: '$output
}

#Ensure aduditing for processes that start prior to auditd is enabled [grub2] (Automated)4.1.1.3
function find-grub2 {
    find /boot -type f -name 'grub.cfg' -exec grep -Ph -- '^\h*linux' {} + | grep -v 'audit=1'
}

#Ensure audit_backlog _limit is sufficient 4.1.1.4
function check-backlog-limit {
    find /boot -type f -name 'grub.cfg' -exec grep -Ph -- '^\h*linux' {} + | grep -Pv 'audit_backlog_limit=\d+\b'
}

#Ensure Data Retention is configured
function check-data-retention {
    grep -Po -- '^\h*max_log_file\h*=\h*\d+\b' /etc/audit/auditd.conf #4.1.2.1
    grep max_log_file_action /etc/audit/auditd.conf #4.1.2.2
    grep ^space_left_action /etc/audit/auditd.conf #4.1.2.3
    grep -E 'admin_space_left_action\s*=\s*(halt|single)' /etc/audit/auditd.conf #4.1.2.3
}

#Ensure Changes to the system administration scope (sudoers) is collected (Automated) - 4.1.3.1
function check-changes-admin-scope {

    # Iterate over files in /etc/audit/rules.d/
    for file in /etc/audit/rules.d/*.rules; do
        # Check for relevant rules using awk
        awk '/^ *-w/ && /\/etc\/sudoers/ && / +-p *wa/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$/)' "$file"
    done

    auditctl -l | awk '/^ *-w/ && /\/etc\/sudoers/ && / +-p *wa/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$/)'
    

}



#Ensure actions as another users are always logged - 4.1.3.2
function check-other-user-actions-logged {
    output= grep -r -l -E '^ *-a *always,exit| -F *arch=b[2346]{2}|(-F *auid!=(unset|-1|4294967295))|(-C *euid!=uid|-C *uid!=euid)| -S *execve|( key= *[!-~]* *$|-k *[!-~]* *$)' /etc/audit/rules.d/*.rules

    output2= auditctl -l | awk '/^ *-a *always,exit/ &&/ -F *arch=b[2346]{2}/ &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) &&(/ -C *euid!=uid/||/ -C *uid!=euid/) &&/ -S *execve/ &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'

    if [ -z "$output" ]
    then
        echo "Audit Passed: On disk configuration configured to log actions as another user"
    else
        echo "Audit Failed: On disk configuration not configured to log actions as another user"
    fi

    if [ -z "$output2" ]
    then
        echo "Audit Passed: Running configuration confifgured to log actions as another user"
    else
        echo "Audit Failed: Running configuration not configured to log actions as another user"
    fi

}


#Ensure events that modify the sudo log file are collected (Automated)
function check-changes-to-sudo-log-file {
    
    SUDO_LOG_FILE_ESCAPED=$(  | sed -e 's/.*logfile=//;s/,? .*//' -e 's/"//g' -e 's|/|\\/|g')
    [ -n "${SUDO_LOG_FILE_ESCAPED}" ] && awk "/^ *-w/ \
    &&/"${SUDO_LOG_FILE_ESCAPED}"/ \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules \
    || printf "ERROR: Variable 'SUDO_LOG_FILE_ESCAPED' is unset.\n"

}



#Ensure events that modify date and time are collected 4.1.3.4
function check-events-modify-date-time-info {
    awk '/^ *-a *always,exit/ \
    &&/ -F *arch=b[2346]{2}/ \
    &&/ -S/ \
    &&(/adjtimex/ \
        ||/settimeofday/ \
        ||/clock_settime/ ) \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules
    awk '/^ *-w/ \
    &&/\/etc\/localtime/ \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules
}

#Ensure use of privileghed commands are collected 4.1.3.6
function check-privileged-commands-logged {
    for PARTITION in $(findmnt -n -l -k -it $(awk '/nodev/ { print $2 }' /proc/filesystems | paste -sd,) | grep -Pv "noexec|nosuid" | awk '{print $1}'); do
        for PRIVILEGED in $(find "${PARTITION}" -xdev -perm /6000 -type f); do
            grep -qr "${PRIVILEGED}" /etc/audit/rules.d && printf "OK:
    '${PRIVILEGED}' found in auditing rules.\n" || printf "Warning:
    '${PRIVILEGED}' not found in on disk configuration.\n"
        done
    done
}

#Ensure unsuccessful file access attempts are collected 4.1.3.7
function check-unsuccessful-access-attempt-logged-disk {
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    [ -n "${UID_MIN}" ] && awk "/^ *-a *always,exit/ \
    &&/ -F *arch=b[2346]{2}/ \
    &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
    &&/ -F *auid>=${UID_MIN}/ \
    &&(/ -F *exit=-EACCES/||/ -F *exit=-EPERM/) \
    &&/ -S/ \
    &&/creat/ \
    &&/open/ \
    &&/truncate/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules \
    || printf "ERROR: Variable 'UID_MIN' is unset.\n"
}

function check-unsuccessful-access-attempt-logged-running {
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    [ -n "${UID_MIN}" ] && auditctl -l | awk "/^ *-a *always,exit/ \
    &&/ -F *arch=b[2346]{2}/ \
    &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
    &&/ -F *auid>=${UID_MIN}/ \
    &&(/ -F *exit=-EACCES/||/ -F *exit=-EPERM/) \
    &&/ -S/ \
    &&/creat/ \
    &&/open/ \
    &&/truncate/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" \
    || printf "ERROR: Variable 'UID_MIN' is unset.\n"
}




#Ensure events that modify user/group information are collected (Automated) 4.1.3.8
function check-changes-user-group-information {
    output= awk '/^ *-w/ \
    &&(/\/etc\/group/ \
        ||/\/etc\/passwd/ \
        ||/\/etc\/gshadow/ \
        ||/\/etc\/shadow/ \
        ||/\/etc\/security\/opasswd/) \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules

    output2= auditctl -l | awk '/^ *-w/ \
    &&(/\/etc\/group/ \
        ||/\/etc\/passwd/ \
        ||/\/etc\/gshadow/ \
        ||/\/etc\/shadow/ \
        ||/\/etc\/security\/opasswd/) \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'

    echo "Disk Rules: $output"
    echo "Running Configuration: $output2"
}

#Check DAC permission modification events are colelcted 4.1.3.9 - Not COnfiguration Working Audit not working.
function check-changes-dac-permission-moidification {
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    [ -n "${UID_MIN}" ] && awk "/^ *-a *always,exit/ \
    &&/ -F *arch=b[2346]{2}/ \
    &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
    &&/ -S/ \
    &&/ -F *auid>=${UID_MIN}/ \
    &&(/chmod/||/fchmod/||/fchmodat/ \
        ||/chown/||/fchown/||/fchownat/||/lchown/ \
        ||/setxattr/||/lsetxattr/||/fsetxattr/ \
        ||/removexattr/||/lremovexattr/||/fremovexattr/) \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules \
    || printf "ERROR: Variable 'UID_MIN' is unset.\n"
}


#Ensure successful file system mounts are collected 4.1.3.10
function check-file-system-mounts {
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    [ -n "${UID_MIN}" ] && auditctl -l | awk "/^ *-a *always,exit/ \
    &&/ -F *arch=b[2346]{2}/ \
    &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
    &&/ -F *auid>=${UID_MIN}/ \
    &&/ -S/ \
    &&/mount/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" \
    || printf "ERROR: Variable 'UID_MIN' is unset.\n"
}

#Ensure session initiation information is collected
function check-audit-session-initiation-information {
    awk '/^ *-w/ \
    &&(/\/var\/run\/utmp/ \
        ||/\/var\/log\/wtmp/ \
        ||/\/var\/log\/btmp/) \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules
}

#Ensure login and logout events are collected 4.1.3.12
function check-audit-login-logout {
    awk '/^ *-w/ \
    &&(/\/var\/log\/lastlog/ \
        ||/\/var\/run\/faillock/) \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules
}


#Ensure file deletion events by users aere collected 4.1.3.13
function check-audit-file-deletion {
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    [ -n "${UID_MIN}" ] && awk "/^ *-a *always,exit/ \
    &&/ -F *arch=b[2346]{2}/ \
    &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
    &&/ -F *auid>=${UID_MIN}/ \
    &&/ -S/ \
    &&(/unlink/||/rename/||/unlinkat/||/renameat/) \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules \
    || printf "ERROR: Variable 'UID_MIN' is unset.\n"
}

#Ensure events that modify the system's mandatory access controls are collected 4.1.3.14
function check-audit-modify-mac {
    awk '/^ *-w/ \
    &&(/\/etc\/apparmor/ \
        ||/\/etc\/apparmor.d/) \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules
}

#Ensure successful and unsuccessful attempts to ise the chcon command are recorded 4.1.3.15
function check-audit-attempts-chcon-use {
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    [ -n "${UID_MIN}" ] && printf "
    -a always,exit -F path=/usr/bin/chcon -F perm=x -F auid>=${UID_MIN} -F
    auid!=unset -k perm_chng
    " >> /etc/audit/rules.d/50-perm_chng.rules || printf "ERROR: Variable
    'UID_MIN' is unset.\n"
}






########MAKE SURE YOU DO CONFIGURING AUDITD RULES
########REST OF THE WORK STARTING FROM PAGE 531

#Ensure audit log files are mode 0640 or less permissive (Automated)
function check-log-files-less-permissive {
    output=$(stat -Lc "%n %a" " $(dirname $( awk -F"=" '/^\s*log_file\s*=\s*/ {print $2}' /etc/audit/auditd.conf | xargs))"/* | grep -v '[0,2,4,6][0,4]0')
    echo $output                            
    if [ -z "$output" ]
    then
        echo "Log files more permissive than 0640: AUDIT Failed"
    else
        echo "Log files more permissive than 0640: AUDIT Passed"
    fi
}