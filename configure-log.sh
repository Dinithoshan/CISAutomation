#!/bin/bash
#Author: Dinith Oshan
#Date: 18/03/2024




#Make sure you make a function for sudo augenrules --reload




#Install, enable and start auditd
function configure-auditd {
    echo 'Installing and configuring auditd'
    apt install auditd audispd-plugins
    systemctl --now enable auditd
}

# Add options to GRUB_CMDLINE_LINUX
function add-grub-options() {
    echo 'Adding Grub Options'
    options="audit=1 audit_backlog_limit=8192"

    # Check if GRUB_CMDLINE_LINUX is already defined in /etc/default/grub
    if grep -q "^GRUB_CMDLINE_LINUX=" /etc/default/grub; then
        # If defined, add options to existing line
        sudo sed -i "s/\(^GRUB_CMDLINE_LINUX=\"[^\"]*\)\"/\1 $options\"/" /etc/default/grub
    else
        # If not defined, create a new line with options
        sudo bash -c "echo 'GRUB_CMDLINE_LINUX=\"$options\"' >> /etc/default/grub"
    fi
}

#Ensure audit log storage size is configured
#max_log_file should be set as site policy (Default value is 8) This value is sufficient for an endpoint workstation

function set-audit-parameters() {
    # Set max_log_file_action parameter
    sudo sed -i "s/^max_log_file_action =.*/max_log_file_action = keep_logs/" /etc/audit/auditd.conf
    echo "max_log_file_action set to 'keep_logs' in /etc/audit/auditd.conf"

    # Set max_log_file parameter
    sudo sed -i "s/^max_log_file =.*/max_log_file = 8/" /etc/audit/auditd.conf
    echo "max_log_file set to '8' in /etc/audit/auditd.conf"

    #set space_left_action parameter
    sudo sed -i "s/^space_left_action =.*/space_left_action = email/" /etc/audit/auditd.conf
    echo "space_left_action set to 'email' in /etc/audit/auditd.conf"

    #set action_mail_acct parameter
    sudo sed -i "s/^action_mail_acct =.*/action_mail_acct = root/" /etc/audit/auditd.conf
    echo "action_mail_acct set to 'root' in /etc/audit/auditd.conf"

    #set action_space_left_action parameter
    sudo sed -i "s/^admin_space_left_action =.*/admin_space_left_action = halt/" /etc/audit/auditd.conf
    echo "admin_space_left_action to 'halt' in /etc/audit/auditd.conf"

}


#NEED TO ADD VALIDATION TO HANDLE IF RULES FILE NAME EXISTS.
#Ensure changes to the system administration scope is collected. - 4.1.3.1
function configure-audit-rules {
    rules="# This script creates audit rules for monitoring changes to scope of admins
-w /etc/sudoers -p wa -k scope
-w /etc/sudoers.d -p wa -k scope
  "
  sudo mkdir -p /etc/audit/rules.d/
  sudo echo "$rules" >> /etc/audit/rules.d/50-scope.rules
  echo "Audit rules for monitoring changes to scope of admins created successfully!"
}

#creating audit rules to configure actions as other user is logged - 4.1.3.2
function configure-other-user-actions-logged() {
  rules="# This script creates audit rules for monitoring elevated privileges
-a always,exit -F arch=b64 -C euid!=uid -F auid!=unset -S execve -k user_emulation
-a always,exit -F arch=b32 -C euid!=uid -F auid!=unset -S execve -k user_emulation
  "
  sudo mkdir -p /etc/audit/rules.d/
  sudo echo "$rules" >> /etc/audit/rules.d/50-user_emulation.rules
  echo "Audit rules for monitoring elevated privileges created successfully!"
}


#creating audit rules to trigegr when events that modify date/time information are collected. 4.1.3.4
function configure-other-user-actions-logged() {
  rules="# This script creates audit rules for events that modify date and time.
-a always,exit -F arch=b64 -S adjtimex,settimeofday,clock_settime -k time-change
-a always,exit -F arch=b32 -S adjtimex,settimeofday,clock_settime -k time-change
-w /etc/localtime -p wa -k time-change
"
  sudo mkdir -p /etc/audit/rules.d/
  sudo echo "$rules" >> /etc/audit/rules.d/50-time-change.rules
  echo "Audit rules for for events that modify date and time created successfully!"
}


#Creating audit rules to ensure events that modify they system's network environment are collected 4.1.3.5
function configure-system-network-env {
    rules="# This script creates audit rules for events that systems network environment
-a always,exit -F arch=b64 -S sethostname,setdomainname -k system-locale
-a always,exit -F arch=b32 -S sethostname,setdomainname -k system-locale
-w /etc/issue -p wa -k system-locale
-w /etc/issue.net -p wa -k system-locale
-w /etc/hosts -p wa -k system-locale
-w /etc/networks -p wa -k system-locale
-w /etc/network/ -p wa -k system-locale
"
  sudo mkdir -p /etc/audit/rules.d/
  sudo echo "$rules" >> /etc/audit/rules.d/50-system_local.rules
  echo "Audit rules for for events that modify system's network environment created successfully!"
}

#Creating audit rule that monitor the use of privileged commands 4.1.3.6
function configure-privileged-command-logs {
  UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
  AUDIT_RULE_FILE="/etc/audit/rules.d/50-privileged.rules"
  NEW_DATA=()
  for PARTITION in $(findmnt -n -l -k -it $(awk '/nodev/ { print $2 }' /proc/filesystems | paste -sd,) | grep -Pv "noexec|nosuid" | awk '{print $1}'); do
    readarray -t DATA < <(find "${PARTITION}" -xdev -perm /6000 -type f | awk -v UID_MIN=${UID_MIN} '{print "-a always,exit -F path=" $1 " -F perm=x -F auid>="UID_MIN" -F auid!=unset -k privileged" }')
    for ENTRY in "${DATA[@]}"; do
      NEW_DATA+=("${ENTRY}")
    done
  done
  readarray &> /dev/null -t OLD_DATA < "${AUDIT_RULE_FILE}"
  COMBINED_DATA=( "${OLD_DATA[@]}" "${NEW_DATA[@]}" )
  printf '%s\n' "${COMBINED_DATA[@]}" | sort -u > "${AUDIT_RULE_FILE}"
}

#Configure audit rule that logs file access attempts are collected 4.1.3.7
function configure-audit-file-access-attempts {
  UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
  [ -n "${UID_MIN}" ] && printf "
-a always,exit -F arch=b64 -S creat,open,openat,truncate,ftruncate -F exit=-EACCES -F auid>=${UID_MIN} -F auid!=unset -k access
-a always,exit -F arch=b64 -S creat,open,openat,truncate,ftruncate -F exit=-EPERM -F auid>=${UID_MIN} -F auid!=unset -k access
-a always,exit -F arch=b32 -S creat,open,openat,truncate,ftruncate -F exit=-EACCES -F auid>=${UID_MIN} -F auid!=unset -k access
-a always,exit -F arch=b32 -S creat,open,openat,truncate,ftruncate -F exit=-EPERM -F auid>=${UID_MIN} -F auid!=unset -k access" >> /etc/audit/rules.d/50-access.rules || printf "ERROR: Variable 'UID_MIN'is unset. \n"
}


#Configure log that modify user/group information 4.1.3.8
function configure-audit-modify-user-group-information {
  rules="# This script creates audit rules for events that modify user/group information
-w /etc/group -p wa -k identity
-w /etc/passwd -p wa -k identity
-w /etc/gshadow -p wa -k identity
-w /etc/shadow -p wa -k identity
"
  sudo mkdir -p /etc/audit/rules.d/
  sudo echo "$rules" >> /etc/audit/rules.d/50-identity.rules
  echo "Audit rules for for events that modify user/group information created successfully!"
}



function configure-permission-mode-audit-log-files {
    find "$(dirname $( awk -F"=" '/^\s*log_file\s*=\s*/ {print $2}'/etc/audit/auditd.conf | xargs))" -type f \( ! -perm 600 -a ! -perm 0400 -a ! -perm 0200 -a ! -perm 0000 -a ! -perm 0640 -a ! -perm 0440 -a ! -perm 0040 \) exec chmod u-x,g-wx,o-rwx {} +
}