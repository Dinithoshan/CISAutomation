#!/bin/bash

source services-audit.sh
source services-configuration.sh

#audit functions
sync
x_window_system
avahi_server
cups
dhcp_server
LDAP_server
NFS
DNS_server
FTP_server
HTTP_server
IMAP_and_POP3
samba
HTTP_proxy_server
SNMP
NIS
mail_transfer
rsync_service_installed
rsync_service_inactive
rsync_service_masked
NIS_client
rsh_client
talk_client
telnet_client
LDAP_client
RPC
nonessential_services

#configuration functions
sync_config
X_windows_system_config
avahi_server_config
cups_config
DHCP_config
LDAP_config
NFS_config
DNS_config
FTP_config
HTTP_config
IMAP_and_POP3_config
SAMBA_config
HTTP_proxy_server_config
SNMP_config
NIS_server_config
mail_trasfer_agent_config
rsync_service_config
NIS_client_config
rsh_client_config
talk_client_config
telnet_client_config
LDAP_client_config
RPC_config
nonessential_services_config