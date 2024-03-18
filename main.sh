#!/bin/bash
#Author: Dinith
#Date: 18/03/2024


#import of the sources
source audit-log.sh
source configure-log.sh


#Importing the Audit Functions
verify-auditd-installed 
verify-auditd-enabled
verify-auditd-active
find-grub2
check-backlog-limit
check_log_storage_size








#Importing configure scripts
configure-auditd
add_grub_options