#!/bin/bash

source ssh-config.sh

function remote-installation() {
    sshpass -p $PASSWORD ssh -p $PORT $USERNAME@$IP "cd /home/$USERNAME/ && mkdir CISBOT"
    scp -r * $USERNAME@$IP:/home/$USERNAME/CISBOT
    sshpass -p $PASSWORD ssh -p $PORT $USERNAME@$IP "$INSTALL_COMMAND"
}

function remote-set-rollback() {
    sshpass -p $PASSWORD ssh -p $PORT $USERNAME@$IP "$SET_ROLLBACK_COMMAND"
}

function remote-rollback() {
    sshpass -p $PASSWORD ssh -p $PORT $USERNAME@$IP "$ROLLBACK_COMMAND"
}

function remote-network-audit() {
    sshpass -p $PASSWORD ssh -p $PORT $USERNAME@$IP "$NETWORK_AUDIT_COMMAND"
}

function remote-network-config(){
    sshpass -p $PASSWORD ssh -p $PORT $USERNAME@$IP "$NETWORK_CONFIG_COMMAND"
}

function remote-logging-audit() {
    sshpass -p $PASSWORD ssh -p $PORT $USERNAME@$IP "$LOGGING_AUDIT_COMMAND"
}

function remote-logging-config() {
    sshpass -p $PASSWORD ssh -p $PORT $USERNAME@$IP "$LOGGING_CONFIG_COMMAND"
}

function remote-initial-setup-audit() {
    sshpass -p $PASSWORD ssh -p $PORT $USERNAME@$IP "$INITIAL_SETUP_AUDIT_COMMAND"
}

function remote-initial-setup-config() {
    sshpass -p $PASSWORD ssh -p $PORT $USERNAME@$IP "$INITIAL_SETUP_CONFIG_COMMAND"
}

function remote-services-audit() {
    sshpass -p $PASSWORD ssh -p $PORT $USERNAME@$IP "$SERVICES_AUDIT_COMMAND"
}

function remote-services-config() {
    sshpass -p $PASSWORD ssh -p $PORT $USERNAME@$IP "$SERVICES_CONFIG_COMMAND"
}


function remote-system-maintenance-audit() {
    sshpass -p $PASSWORD ssh -p $PORT $USERNAME@$IP "$SMAINTENANCE_AUDIT_COMMAND"
}

function remote-system-maintenance-config() {
    sshpass -p $PASSWORD ssh -p $PORT $USERNAME@$IP "$SMAINTENANCE_CONFIG_COMMAND"
}



remote-installation
remote-set-rollback
remote-network-audit
remote-logging-audit
remote-initial-setup-audit
remote-services-audit