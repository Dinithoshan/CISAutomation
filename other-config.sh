#!/bin/bash

source initial-setup-config.sh

config_tmp_partition
config_tmp_nodev
config_tmp_noexec
config_var_nosuid
config_tmp_separate_partition
config_var_tmp_nodev
config_var_tmp_nosuid
config_var_tmp_noexec
config_var_log_partition_separate
config_var_log_partition_nodev
config_var_log_partition_noexec
config_var_log_partition_nosuid
config_var_log_audit_separate_partition
config_var_log_audit_partition_noexec
config_var_log_audit_partition_nodev
config_var_log_audit_partition_nosuid
config_home_separate_partition
config_home_partition_nodev
config_home_partition_nosuid
config_dev_shm_partition_nodev
config_dev_shm_partition_noexec
config_dev_shm_partition_nosuid
config_pkg_manager_repos
config_gpg_keys
config_bootloader_pwd
config_single_user_auth
config_aide
config_gdm_disable_usr_list
config_gdm_screenlock_usr_idle
config_gnome_display_manager_removal