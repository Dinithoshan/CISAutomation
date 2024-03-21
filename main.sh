#!/bin/bash
#Author: Dinith Oshan
#Date: 18/03/2024


#import of the sources
source audit-log.sh
source configure-log.sh   

 
#Importing the Audit Functions
# verify-auditd-installed
# verify-auditd-enabled
# verify-auditd-active
# find-grub2
# check-backlog-limit
# check-data-retention
# check-changes-admin-scope
# check-other-user-actions-logged #HAVE A LOOK AT THIS AWK NOT WORKING PROPERLY
# check-changes-to-sudo-log-file



# check-log-files-less-permissive







#Importing configure scripts
# configure-auditd            
# add_grub_options
# set_max_log_file
# set_audit_parameters
# configure-audit-rules
configure-other-user-actions-logged






# configure-permission-mode-audit-log-files 