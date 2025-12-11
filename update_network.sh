#!/bin/bash

#list of common utils
tools=("ip" "netstat" "curl" "wget" "traceroute" "nmap")
#list of missing utils
missing=""
#connection flag
connected=0

# Goes through list of utilities and checks if their command works
check_tools() { 
    for tool in "${tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            if [ connected==1 ]; then 
                if [[ "$tool" == "netstat" || "$tool" == "ip" ]]; then #net-tools handles ip and netstat
                    pkg="net-tools"
                    sudo apt install --only-upgrade "$pkg" -y &> /dev/null
                    echo -e "\033[1;35m$tool : Present and Updated\033[0m"
                else
                    sudo apt install --only-upgrade "$tool" -y &> /dev/null
                    echo -e "\033[1;35m$tool : Present and Updated\033[0m"
                fi
            else
                echo -e "\033[1;35m$tool : Present"
            fi
        else
            echo -e "\033[1;35m$tool : Not Present"
            local pkg="$tool"
            if [[ "$tool" == "netstat" || "$tool" == "ip" ]]; then #net-tools handles ip and netstat
                pkg="net-tools"
            fi
            missing+="$pkg "
        fi
    done
}

#checks if Google DNS can be reached, won't attempt installs if not reachable
check_connection() {
    if ping -c 1 -q 8.8.8.8 &> /dev/null; then
        echo -e "\033[1;35mInternet is connected\033[0m"
        connected=1
    else
        echo -e "\033[1;35mERROR: Cannot reach Google, aborting updates..\033[0m"
    fi
}

#installs network utilities not found in check_tools
update() {
    install_cmd="sudo apt install -y"
    echo "Attempting to install missing packages..\033[0m"
    if [[ -n "$missing" && $connected==1 ]]; then
        if $install_cmd $missing &> /dev/null; then
            echo "Installation Successful"
        else
            echo "Installation FAILED"
        fi
    else
        echo -e "\033[1;35mAll recommended network tools are installed\033[0m"
        ip a
        echo -e "\033[1;35mUpgradable Packages...\033[0m"
        apt list --upgradable
    fi
}
#run and exit
check_connection

check_tools

update

exit 0
