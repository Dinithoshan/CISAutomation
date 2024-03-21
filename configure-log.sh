#!/bin/bash
#Author: Dinith Oshan
#Date: 18/03/2024







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
function configure-audit-rules {
    printf "
-w /etc/sudoers -p wa -k scope
-w /etc/sudoers.d -p wa -k scope
" >> /etc/audit/rules.d/50-scope.rules
    augenrules --load
    if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then 
        printf "Rebootrequired to load rules\n"; 
    fi
}

#creating audit rules to configure actions as other user is logged
function configure-other-user-actions-logged() {
  # Define the rules
  rules="# This script creates audit rules for monitoring elevated privileges
-a always,exit -F arch=b64 -C euid!=uid -F auid!=unset -S execve -k user_emulation
-a always,exit -F arch=b32 -C euid!=uid -F auid!=unset -S execve -k user_emulation
  "

  # Create the audit rules file (ensure /etc/audit/rules.d/ exists)
  sudo mkdir -p /etc/audit/rules.d/
  sudo echo "$rules" >> /etc/audit/rules.d/50-user_emulation.rules

  # Reload the auditd service to apply the new rules
  sudo augenrules --load

  echo "Audit rules for monitoring elevated privileges created successfully!"
}


function configure-permission-mode-audit-log-files {
    find "$(dirname $( awk -F"=" '/^\s*log_file\s*=\s*/ {print $2}'/etc/audit/auditd.conf | xargs))" -type f \( ! -perm 600 -a ! -perm 0400 -a ! -perm 0200 -a ! -perm 0000 -a ! -perm 0640 -a ! -perm 0440 -a ! -perm 0040 \) exec chmod u-x,g-wx,o-rwx {} +
}