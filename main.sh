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
# check-other-user-actions-logged #HAVE A LOOK AT THIS AWK NOT WORKING PROPERLY
# check-changes-to-sudo-log-file
# check-privileged-commands-logged
# check-unsuccessful-access-attempt-logged-disk #4.1.3.7
# check-unsuccessful-access-attempt-logged-running #4.1.3.7
check-changes-user-group-information #4.1.3.8




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






# configure-permission-mode-audit-log-files 