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