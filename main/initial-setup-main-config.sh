#!/bin/bash
source initial-setup-config.sh

#Config Scripts
config_disable_cramfs
config_disable_squashfs
config_disable_udf
# config_tmp_partition
# config_tmp_nodev
# config_tmp_noexec
# config_var_nosuid
# config_tmp_separate_partition
# config_var_tmp_nodev
# config_var_tmp_nosuid
# config_var_tmp_noexec
# config_var_log_partition_separate
# config_var_log_partition_nodev
# config_var_log_partition_noexec
# config_var_log_partition_nosuid
# config_var_log_audit_separate_partition
# config_var_log_audit_partition_noexec
# config_var_log_audit_partition_nodev
# config_var_log_audit_partition_nosuid
# config_home_separate_partition
# config_home_partition_nodev
# config_home_partition_nosuid
# config_dev_shm_partition_nodev
# config_dev_shm_partition_noexec
# config_dev_shm_partition_nosuid
config_disable_automounting
config_usb_storage
#config_pkg_manager_repos
#config_gpg_keys
# config_bootloader_pwd
config_bootloader_config_permissions
# config_single_user_auth
config_aide
config_aslr
config_file_sys_integrity_check
config_prelink_not_installed
config_automatic_err_reporting_disabled
config_core_dumps_restricted
config_apparmor_installed
config_apparmor_enabled_bootloader
config_apparmor_profiles_enforce_complain
config_apparmor_profiles_enforcing
config_motd
config_local_login_banner
config_remote_login_banner
config_etc_motd_permissions
config_etc_issue_permissions
config_etc_issue_net_permissions
# config_gnome_display_manager_removal
config_gdm_banner
# config_gdm_disable_usr_list
# config_gdm_screenlock_usr_idle
config_screen_lock_override
config_disable_automatic_mounting_media_gnome_users
config_lock_disable_automatic_mounting_media_gnome_users
config_set_autorun_never_true_gdm_users
config_lock_autorun_never_true
config_gdm_custom_conf
config_update_packages