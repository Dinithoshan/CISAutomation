source audit.sh
source config.sh

    # # ############################################################################################################################################

    IPv6_status 
    wireless_int_check 
    packet_re_send
    ip_forwrd_dis
    source_rt_pac       
    icmp_redirect
    sec_icmp_redirect   
    packt_log           
    brodcst_icmp   
    bogus_icmp        
    rvrs_path_filtr   
    tcp_syn_cookies   
    IPv6_router_ad    
    dccp_disbl
    sctp_disbl
    rds_disbl
    tipc_disbl

    # # ############################################################## Configure ufw section ##############################################################


    ufw_ins
    ip_tbl_persis
    ufw_enable
    ufw_lback_traf
    ufw_outbound_conf   
    mis_firewall_rules
    ufw_deny_policies

    # # ############################################################## Configure nftables section ##############################################################

    nftabls_install
    ufw_status
    iptabl_flush     
    nftabl_exist     
    base_chains_exist
    loopback_int
    est_connections       
    nft_deny_polic 
    nftables_enabled         
    nft_ruls_perme

    # # ########################################################### Configure  iptables section ##############################################################

    # #---------------- iptables software ----------------------------

    iptabls_installed
    nftbls_not_ins
    ufw_not_inst_disbld

    # #-----------------ipv4 config --------------------------------------

    iptbl_deny_policy
    iptbl_lback_traf           
    iptabls_site_policy 
    firewll_rule_exist

    # #-----------------ipv6 config -------------------------------------

    ipv6_default_poli 
    ip6_lback_traff           
    ip6_site_policy    
    ip6_firewll_rule_exist

























#########################################################################################################################################################
################################################################### code to autorun configs after audits ###################################################################
#########################################################################################################################################################

    IPv6_status_output=$(IPv6_status)
    echo "$IPv6_status_output"

    wireless_int_check_output=$(wireless_int_check)
    echo "$wireless_int_check_output"

    packet_re_send_output=$(packet_re_send)
    echo "$packet_re_send_output"

    ip_forwrd_dis_output=$(ip_forwrd_dis)
    echo "$ip_forwrd_dis_output"

    source_rt_pac_output=$(source_rt_pac)
    echo "$source_rt_pac_output"

    icmp_redirect_output=$(icmp_redirect)
    echo "$icmp_redirect_output"

    sec_icmp_redirect_output=$(sec_icmp_redirect)  
    echo "$sec_icmp_redirect_output"

    packt_log_output=$(packt_log)        
    echo "$packt_log_output"

    brodcst_icmp_output=$(brodcst_icmp)
    echo "$brodcst_icmp_output"

    bogus_icmp_output=$(bogus_icmp)      
    echo "$bogus_icmp_output" 

    rvrs_path_filtr_output=$(rvrs_path_filtr)  
    echo "$rvrs_path_filtr_output"

    tcp_syn_cookies_output=$(tcp_syn_cookies)  
    echo "$tcp_syn_cookies_output"

    IPv6_router_ad_output=$(IPv6_router_ad)    
    echo "$IPv6_router_ad_output"

    dccp_disbl_output=$(dccp_disbl)
    echo "$dccp_disbl_output"

    sctp_disbl_output=$(sctp_disbl)
    echo "$sctp_disbl_output"

    rds_disbl_output=$(rds_disbl)
    echo "$rds_disbl_output"

    tipc_disbl_output=$(tipc_disbl)
    echo "$tipc_disbl_output"

#     #####################################################################

    ufw_ins_output=$(ufw_ins)
    echo "$ufw_ins_output"

    ip_tbl_persis_output=$(ip_tbl_persis)
    echo "$ip_tbl_persis_output"

    ufw_enable_output=$(ufw_enable)
    echo "$ufw_enable_output"

    ufw_lback_traf_output=$(ufw_lback_traf)
    echo "$ufw_lback_traf_output"

    ufw_outbound_conf_output=$(ufw_outbound_conf)   ### fail due to manual
    echo "$ufw_outbound_conf_output"

    mis_firewall_rules_output=$(mis_firewall_rules)
    echo "$mis_firewall_rules_output"

    ufw_deny_policies_output=$(ufw_deny_policies)
    echo "$ufw_deny_policies_output"

    nftabls_install_output=$(nftabls_install)
    echo "$nftabls_install_output"

    ufw_status_output=$(ufw_status)
    echo "$ufw_status_output"

    iptabl_flush_output=$(iptabl_flush)    
    echo "$iptabl_flush_output"

    nftabl_exist_output=$(nftabl_exist)   
    echo "$nftabl_exist_output"

    base_chains_exist_output=$(base_chains_exist)
    echo "$base_chains_exist_output"

    loopback_int_output=$(loopback_int)
    echo "$loopback_int_output"

    est_connections_output=$(est_connections)  
    echo "$est_connections_output"

    nft_deny_polic_output=$(nft_deny_polic) 
    echo "$nft_deny_polic_output"

    nftables_enabled_output=$(nftables_enabled)      
    echo "$nftables_enabled_output"

    nft_ruls_perme_output=$(nft_ruls_perme)
    echo "$nft_ruls_perme_output"


    iptabls_installed_output=$(iptabls_installed)
    echo "$iptabls_installed_output"

    nftbls_not_ins_output=$(nftbls_not_ins)
    echo "$nftbls_not_ins_output"

    ufw_not_inst_disbld_output=$(ufw_not_inst_disbld)
    echo "$ufw_not_inst_disbld_output"

    iptbl_deny_policy_output=$(iptbl_deny_policy)
    echo "$iptbl_deny_policy_output"

    iptbl_lback_traf_output=$(iptbl_lback_traf)
    echo "$iptbl_lback_traf_output"

    iptabls_site_policy_output=$(iptabls_site_policy) ###################### (((mannual)))
    echo "$iptabls_site_policy_output"

    firewll_rule_exist_output=$(firewll_rule_exist)
    echo "$firewll_rule_exist_output"

    ipv6_default_poli_output=$(ipv6_default_poli) 
    echo "$ipv6_default_poli_output"

    ip6_lback_traff_output=$(ip6_lback_traff)
    echo "$ip6_lback_traff_output"

    ip6_site_policy_output=$(ip6_site_policy) ###################### (((mannual)))
    echo "$ip6_site_policy_output"

    ip6_firewll_rule_exist_output=$(ip6_firewll_rule_exist)
    echo "$ip6_firewll_rule_exist_output"



# ############################ configuration


    print_red() {
    echo -e "\e[31m$1\e[0m"
    }

#     # Inform user about automatic configuration
    print_red "Automatic configuration process will start in 5 seconds. Press Ctrl+C to cancel."


    check_and_execute() {
    local output=$1
    local message=$2
    local remediation=$3
    
    if echo "$output" | grep -i -q "Audit FAIL"; then
        echo "$output"
        echo "$message"
        $remediation
    fi
    }

#     # Countdown
    for i in {5..1}; do
    print_red "$i..."
    sleep 1
    done

#     # Call check_and_execute function for each command
    check_and_execute "$IPv6_status_output" "The IPv6 status output contains AUDIT FAIL. Performing action..." IPv6_status_reme
    check_and_execute "$wireless_int_check_output" "The wireless interface check output contains AUDIT FAIL. Performing action..." wireless_int_check_reme
    check_and_execute "$packet_re_send_output" "The packet re-send output contains AUDIT FAIL. Performing action..." packet_re_send_reme
    check_and_execute "$ip_forwrd_dis_output" "The IP forwarding disable output contains AUDIT FAIL. Performing action..." ip_forwrd_dis_reme
    check_and_execute "$source_rt_pac_output" "The source route packet output contains AUDIT FAIL. Performing action..." source_rt_pac_reme
    check_and_execute "$icmp_redirect_output" "The ICMP redirect output contains AUDIT FAIL. Performing action..." icmp_redirect_reme
    check_and_execute "$sec_icmp_redirect_output" "The secure ICMP redirect output contains AUDIT FAIL. Performing action..." sec_icmp_redirect_reme
    check_and_execute "$packt_log_output" "The packet log output contains AUDIT FAIL. Performing action..." packt_log_reme
    check_and_execute "$brodcst_icmp_output" "The broadcast ICMP output contains AUDIT FAIL. Performing action..." brodcst_icmp_reme
    check_and_execute "$bogus_icmp_output" "The bogus ICMP output contains AUDIT FAIL. Performing action..." bogus_icmp_reme
    check_and_execute "$rvrs_path_filtr_output" "The reverse path filter output contains AUDIT FAIL. Performing action..." rvrs_path_filtr_reme
    check_and_execute "$tcp_syn_cookies_output" "The TCP SYN cookies output contains AUDIT FAIL. Performing action..." tcp_syn_cookies_reme
    check_and_execute "$IPv6_router_ad_output" "The IPv6 router advertisement output contains AUDIT FAIL. Performing action..." IPv6_router_ad_reme
    check_and_execute "$dccp_disbl_output" "The DCCP disable output contains AUDIT FAIL. Performing action..." dccp_disbl_reme
    check_and_execute "$sctp_disbl_output" "The SCTP disable output contains AUDIT FAIL. Performing action..." sctp_disbl_reme
    check_and_execute "$rds_disbl_output" "The RDS disable output contains AUDIT FAIL. Performing action..." rds_disbl_reme
    check_and_execute "$tipc_disbl_output" "The TIPC disable output contains AUDIT FAIL. Performing action..." tipc_disbl_reme
    check_and_execute "$ufw_ins_output" "The UFW insertion output contains AUDIT FAIL. Performing action..." ufw_ins_reme
    check_and_execute "$ip_tbl_persis_output" "The IP table persistence output contains AUDIT FAIL. Performing action..." ip_tbl_persis_reme
    check_and_execute "$ufw_enable_output" "The UFW enable output contains AUDIT FAIL. Performing action..." ufw_enable_reme
    check_and_execute "$ufw_lback_traf_output" "The UFW loopback traffic output contains AUDIT FAIL. Performing action..." ufw_lback_traf_reme
    check_and_execute "$ufw_outbound_conf_output" "The UFW outbound configuration output contains AUDIT FAIL. Performing action..." ufw_outbound_conf_reme
    check_and_execute "$mis_firewall_rules_output" "The mismatched firewall rules output contains AUDIT FAIL. Performing action..." mis_firewall_rules_reme
    check_and_execute "$ufw_deny_policies_output" "The UFW deny policies output contains AUDIT FAIL. Performing action..." ufw_deny_policies_reme
    check_and_execute "$nftabls_install_output" "The nftables installation output contains AUDIT FAIL. Performing action..." nftabls_install_reme
    check_and_execute "$ufw_status_output" "The UFW status output contains AUDIT FAIL. Performing action..." ufw_status_reme
    check_and_execute "$iptabl_flush_output" "The iptables flush output contains AUDIT FAIL. Performing action..." iptabl_flush_reme
    check_and_execute "$nftabl_exist_output" "The nftables existence output contains AUDIT FAIL. Performing action..." nftabl_exist_reme
    check_and_execute "$base_chains_exist_output" "The base chains existence output contains AUDIT FAIL. Performing action..." base_chains_exist_reme
    check_and_execute "$loopback_int_output" "The loopback interface output contains AUDIT FAIL. Performing action..." loopback_int_reme
    check_and_execute "$est_connections_output" "The established connections output contains AUDIT FAIL. Performing action..." est_connections_reme
    check_and_execute "$nft_deny_polic_output" "The nftables deny policies output contains AUDIT FAIL. Performing action..." nft_deny_polic_reme
    check_and_execute "$nftables_enabled_output" "The nftables enabled status output contains AUDIT FAIL. Performing action..." nftables_enabled_reme
    check_and_execute "$nft_ruls_perme_output" "The nftables rules permission output contains AUDIT FAIL. Performing action..." nft_ruls_perme_reme
    check_and_execute "$iptabls_installed_output" "The iptables installation output contains AUDIT FAIL. Performing action..." iptabls_installed_reme
    check_and_execute "$nftbls_not_ins_output" "The nftables not installed output contains AUDIT FAIL. Performing action..." nftbls_not_ins_reme
    check_and_execute "$ufw_not_inst_disbld_output" "The UFW not installed or disabled output contains AUDIT FAIL. Performing action..." ufw_not_inst_disbld_reme
    check_and_execute "$iptbl_deny_policy_output" "The iptables deny policy output contains AUDIT FAIL. Performing action..." iptbl_deny_policy_reme
    check_and_execute "$iptbl_lback_traf_output" "The iptables loopback traffic output contains AUDIT FAIL. Performing action..." iptbl_lback_traf_reme
    check_and_execute "$iptabls_site_policy_output" "The iptables site policy output contains AUDIT FAIL. Performing action..." iptabls_site_policy_reme
    check_and_execute "$firewll_rule_exist_output" "The firewall rule existence output contains AUDIT FAIL. Performing action..." firewll_rule_exist_reme
    check_and_execute "$ipv6_default_poli_output" "The IPv6 default policy output contains AUDIT FAIL. Performing action..." ipv6_default_poli_reme
    check_and_execute "$ip6_lback_traff_output" "The IPv6 loopback traffic output contains AUDIT FAIL. Performing action..." ip6_lback_traff_reme
    check_and_execute "$ip6_site_policy_output" "The IPv6 site policy output contains AUDIT FAIL. Performing action..." ip6_site_policy_reme
    check_and_execute "$ip6_firewll_rule_exist_output" "The IPv6 firewall rule existence output contains AUDIT FAIL. Performing action..." ip6_firewll_rule_exist_reme
