#!/bin/bash
#Author: Dinith Oshan
#Date: 18/03/2024


#import of the sources
source audit-log.sh
source configure-log.sh   

 
#Importing the Audit Functions
# verify-auditd-installed #4.1.1.1
# verify-auditd-enabled
# verify-auditd-active
# find-grub2
# check-backlog-limit
# check-data-retention
# check-changes-admin-scope #4.1.3.1
# check-other-user-actions-logged (NOT WORKING)
# check-changes-to-sudo-log-file
# check-privileged-commands-logged
# check-unsuccessful-access-attempt-logged-disk #4.1.3.7
# check-unsuccessful-access-attempt-logged-running #4.1.3.7
# check-changes-user-group-information #4.1.3.8
# check-changes-dac-permission-moidification #4.1.3.9
# check-file-system-mounts #4.1.3.10
# check-audit-session-initiation-information #4.1.3.11
# check-audit-login-logout #4.1.3.12
# check-audit-file-deletion #4.1.3.13 (NOT WORKING)
# check-audit-modify-mac #4.1.3.14
check-audit-attempts-chcon-use #4.1.3.15 (NOT WORKING)



# check-log-files-less-permissive







#Importing configure scripts
# configure-auditd            
# add_grub_options
# set_max_log_file
# set_audit_parameters
# configure-audit-rules
# configure-other-user-actions-logged
# configure-privileged-command-logs #4.1.3.6
# configure-audit-file-access-attempts #4.1.3.7
# configure-audit-modify-user-group-information  #4.1.3.8
# configure-audit-dac-permission-modification #4.1.3.9
# configure-audit-file-system-mounts #4.1.3.10
# configure-audit-session-initiation #4.1.3.11
# configure-audit-login-logout #4.1.3.12
# configure-audit-file-deletion #4.1.3.13
# config-audit-modify-mac #4.1.3.14
# config-audit-chcon-usage-attempts #4.1.3.15





# configure-permission-mode-audit-log-files 