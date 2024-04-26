#!/bin/bash

LOG_AUDIT="./log-main-audit.sh"
LOG_CONFIG="./log-main-config.sh"
INITIAL_AUDIT="./initial-setup-main-audit.sh"
INITIAL_CONFIG="./initial-setup-main-config.sh"
SERVICES_AUDIT="./services-main-audit.sh"
SERVICES_CONFIG="./services-main-config.sh"
NETWORK_AUDIT="./network-main-audit.sh"
NETWORK_CONFIG="./network-main-config.sh"
RUN_ROLLBACK="./rollback-main.sh"
INSTALLATION="./installation-main.sh"

# Defining functions to execute the scripts

function execute_log_audit() {
    echo "executing Audit Log Script...."
    bash "$LOG_AUDIT"
}

function execute_log_config() {
    echo "executing Config Log Script...."
    bash "$LOG_CONFIG"
}

function execute_initial_audit() {
    echo "executing Initial Audit Script...."
    bash "$INITIAL_AUDIT"
}

function execute_initial_config() {
    echo "executing Initial Config Script...."
    bash "$INITIAL_CONFIG"
}

function execute_services_audit() {
    echo "executing Audit Services Script...."
    bash "$SERVICES_AUDIT"
}

function execute_services_config() {
    echo "executing Config Services Script...."
    bash "$SERVICES_CONFIG"
}

function execute_network_audit() {
    echo "executing Audit network Script...."
    bash "$NETWORK_AUDIT"
}

function execute_network_config() {
    echo "execute Config network Script...."
    bash "$NETWORK_CONFIG"
}

function displayhelp() {
    cat help.txt /n
}

function setrollback () {
    timeshift --create --comments "CISRestorePoint"
}

function execute_run_rollback() {
    echo "execute Run rolback Script...."
    bash "$RUN_ROLLBACK"
}

function execute_installation() {
    echo "execute Installation script...."
    bash "$INSTALLATION"
    echo "Installation Complete."
}

# Check if the script is not being run as root
if [ "$EUID" -ne 0 ]; then
    echo "Script is not running as root."
else
    # Process command line options
    while getopts "lLiIsSnNhrRx" opt; do
        case $opt in
            l)
                execute_log_audit
                ;;
            L)
                execute_log_config
                ;;
            i)
                execute_initial_audit
                ;;
            I)
                execute_initial_config
                ;;
            s)
                execute_services_audit
                ;;
            S)
                execute_services_config
                ;;
            n)
                execute_network_audit
                ;;
            N)
                execute_network_config
                ;;
            h)
                displayhelp
                ;;
            r)
                setrollback
                ;;
            R)
                execute_run_rollback
                ;;
            x)
                execute_installation
                ;;
            \?)
                echo "Invalid Option: -$OPTARG" >&2
                ;;
        esac
    done
fi
