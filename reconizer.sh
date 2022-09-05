#!/usr/bin/env bash



red='\033[1;31m'
green='\033[1;32m'
blue='\033[1;33m'
yellow='\033[1;33m'
reset='\033[0m'

STD_OUT="&>/dev/null"
STD_ERR="2>/dev/null"

axiom="False"

tools=~/Tools
subdomains_list=$tools/sub_brute_small.txt
GOTATOR_TIMEOUT="timeout 200"
COMMON_WEB_PORTS="81,300,591,593,832,981,1010,1311,1099,2082,2095,2096,2480,3000,3128,3333,4243,4567,4711,4712,4993,5000,5104,5108,5280,5281,5601,5800,6543,7000,7001,7396,7474,8000,8001,8008,8014,8042,8060,8069,8080,8081,8083,8088,8090,8091,8095,8118,8123,8172,8181,8222,8243,8280,8281,8333,8337,8443,8500,8834,8880,8888,8983,9000,9001,9043,9060,9080,9090,9091,9092,9200,9443,9502,9800,9981,10000,10250,11371,12443,15672,16080,17778,18091,18092,20720,32000,55440,55672"


banner(){
printf "\n${green}"
printf " ______                     _                    \n"
printf " | ___ \                   (_)                   \n"
printf " | |_/ /___  ___ ___  _ __  _ _______ _ __       \n"
printf " |    // _ \/ __/ _ \| '_ \| |_  / _ \ '__|      \n"
printf " | |\ \  __/ (_| (_) | | | | |/ /  __/ |         \n"
printf " \_| \_\___|\___\___/|_| |_|_/___\___|_|         \n"
printf "                                                 \n${reset}"
}


start()
{
	dir=$PWD/Recon/$domain
	mkdir -p $dir
	cd $dir
	mkdir -p .tmp/
	tools=~/Tools
	tools_installed
	printf "\n${green}#############################################################################${reset}\n"
	printf "\n"
	printf "${red}Target: $domain ${reset}" | notify -silent 2>/dev/null
	printf "\n"
}


tools_installed()
{
	printf "${yellow} Checking the installation of tools${reset}\n"
	printf "${green}###########################################################################${reset}\n"

	eval type -P amass $STD_OUT && printf "${green} [*] Amass [YES]${reset}\n" || printf "${red} [*] Amass [NO]${reset}\n"
	eval type -P subfinder $STD_OUT && printf "${green} [*] Subfinder [YES]${reset}\n" || printf "${red} [*] Subfinder [NO]${reset}\n"
	eval type -P findomain $STD_OUT && printf "${green} [*] Findomain [YES]${reset}\n" || printf "${red} [*] Findomain [NO]${reset}\n"
	eval type -P assetfinder $STD_OUT && printf "${green} [*] assetfinder [YES]${reset}\n" || printf "${red} [*] assetfinder [NO]${reset}\n"
	eval type -P gau $STD_OUT && printf "${green} [*] Gau [YES]${reset}\n" || printf "${red} [*] Gau [NO]${reset}\n"
	eval type -P massdns $STD_OUT && printf "${green} [*] Massdns [YES]${reset}\n" || printf "${red} [*] Massdns [NO]${reset}\n"
	eval type -P puredns $STD_OUT && printf "${green} [*] Puredns [YES]${reset}\n" || printf "${red} [*] Puredns [NO]${reset}\n"
	eval type -P tlsx $STD_OUT && printf "${green} [*] Tlsx [YES]${reset}\n" || printf "${red} [*] Tlsx [NO]${reset}\n"
	eval type -P gotator $STD_OUT && printf "${green} [*] Gotator [YES]${reset}\n" || printf "${red} [*] Gotator [NO]${reset}\n"
	eval type -P httpx $STD_OUT && printf "${green} [*] Httpx [YES]${reset}\n" || printf "${red} [*] Httpx [NO]${reset}\n"
	eval type -P gospider $STD_OUT && printf "${green} [*] Gospider [YES]${reset}\n" || printf "${red} [*] Gospider [NO]${reset}\n"
	eval type -P unfurl $STD_OUT && printf "${green} [*] Unfurl [YES]${reset}\n" || printf "${red} [*] Unfurl [NO]${reset}\n"
	eval type -P analyticsrelationships $STD_OUT && printf "${green} [*] Analyticsrelationships [YES]${reset}\n" || printf "${red} [*] Analyticsrelationships [NO]${reset}\n"
	eval type -P nuclei $STD_OUT && printf "${green} [*] Nuclei [YES]${reset}\n" || printf "${red} [*] Nuclei [NO]${reset}\n"
	eval type -P gowitness $STD_OUT && printf "${green} [*] Gowitness [YES]${reset}\n" || printf "${red} [*] Gowitness [NO]${reset}\n"
	eval type -P notify $STD_OUT && printf "${green} [*] Notify [YES]${reset}\n" || printf "${red} [*] Notify [NO]${reset}\n"
	
	[ -f $tools/ctfr/ctfr.py ] && printf "${green} [*] ctfr.py [YES]${reset}\n" || printf "${bred} [*] ctfr.py [NO]${reset}\n"
	[ -f $tools/dnsvalidator/dnsvalidator/dnsvalidator.py ] && printf "${green} [*] dnsvalidator [YES]${reset}\n" || printf "${bred} [*] dnsvalidator [NO]${reset}\n"
	[ -f $tools/dorks_hunter/dorks_hunter.py ] && printf "${green} [*] dorks_hunter [YES]${reset}\n" || printf "${bred} [*] dorks_hunter [NO]${reset}\n"

	printf "${green}##############################################################################${reset}\n\n"
}



######################################## OSINT Section ###########################################

osint_init()
{
	mkdir -p OSINT/
	printf "${green}##############################################################################${reset}\n\n"
	printf "${green}Starting OSINT Enumeration${reset}\n" | notify -silent 2>/dev/null
}

google_dorks()
{
	printf "${green}##############################################################################${reset}\n\n"
	printf "${yellow}Google Dorking Started${reset}\n\n" | notify -silent 2>/dev/null
	python3 $tools/dorks_hunter/dorks_hunter.py -d $domain -o OSINT/dorks.txt
}

github_dorks()
{
	printf "${green}##############################################################################${reset}\n\n"
	printf "${yellow}Github Dorking Started${reset}\n\n" | notify -silent 2>/dev/null
	gitdorks_go -gd $tools/gitdorks_go/Dorks/medium_dorks.txt -nws 15 -target $domain -tf $tools/.github_tokens -ew 3 | anew -q OSINT/gitdorks.txt
	
}

email_osint()
{
	printf "${green}##############################################################################${reset}\n\n"
	printf "${yellow}Email OSINT Started${reset}\n" | notify -silent 2>/dev/null
	emailfinder -d $domain > .tmp/tmp_emailfinder.txt
	[ -s ".tmp/tmp_emailfinder.txt" ] && cat .tmp/tmp_emailfinder.txt | awk 'matched; /^--------------/ { matched = 1 }' | anew -q OSINT/emails.txt
	
}

osint_end()
{
	printf "${green}OSINT Enumeration Ended${reset}\n" | notify -silent 2>/dev/null
	printf "${green}##############################################################################${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

######################################## Subdomian Enumeration ###########################################


subdomain_init()
{
	mkdir -p subdomains/
	printf "${green}##############################################################################${reset}\n"
	printf "${green}Starting Subdomain Enumeration${reset}\n"
}

subdomain_passive()
{
	printf "${green}##############################################################################${reset}\n\n"
	printf "\n${yellow}Passive Enumeration Started${reset}\n\n" | notify -silent 2>/dev/null
	eval subfinder -d $domain -all -config /root/.config/subfinder/config.yaml -o .tmp/passive_subfinder.txt $STD_OUT
	eval assetfinder --subs-only $domain | anew -q .tmp/passive_assetfinder.txt $STD_OUT
	eval findomain -t $domain -u .tmp/passive_findomain.txt $STD_OUT
	eval amass enum -passive -d $domain -config /root/.config/amass/config.ini -o .tmp/passive_amass.txt $STD_OUT
	eval github-subdomains -d $domain -t $tools/.github_tokens -o .tmp/passive_github_subdomains.txt $STD_OUT
	eval timeout 100 gau --subs $domain --o .tmp/gau_tmp.txt $STD_OUT
	cat .tmp/gau_tmp.txt | unfurl -u domains | grep ".$domain$" | anew -q .tmp/passive_gau.txt

	Number_of_lines=$(find .tmp -type f -iname "passive*" -exec cat {} \; | sed "s/*.//" | anew .tmp/passive_subs.txt | wc -l)
	printf "\n"
	printf "\n${green}Found!!: $Number_of_lines new subdomains${reset}\n\n" | notify -silent 2>/dev/null
	printf "\n"
	printf "${yellow}Passive Enumeration Ended${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

subdomain_crt()
{
	printf "${yellow}Certficate Transparency Enumeration Started${reset}\n\n" | notify -silent 2>/dev/null
	eval python3 $tools/ctfr/ctfr.py -d $domain -o .tmp/crtsh_subs_tmp.txt $STD_OUT
	Number_of_lines=$(cat .tmp/crtsh_subs_tmp.txt | anew .tmp/crtsh_subs.txt | wc -l)
	printf "\n"
	printf "${green}Found!!: $Number_of_lines new subdomains ${reset}\n\n" | notify -silent 2>/dev/null
	printf "\n"
	printf "${yellow}Certficate Transparency Enumeration Ended${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

subdomain_analytics()
{
	printf "${yellow}Subdomain Analytics Enumeration started${reset}\n\n" | notify -silent 2>/dev/null
	eval cat .tmp/scrap_probed.txt | analyticsrelationships -ch >> .tmp/analytics_subs_tmp.txt &>/dev/null
	[ -s ".tmp/analytics_subs_tmp.txt" ] && cat .tmp/analytics_subs_tmp.txt | grep ".$domain$" | anew .tmp/analytics_subs.txt $STD_OUT
	Number_of_lines=$(cat .tmp/analytics_subs.txt | wc -l)
	printf "\n"
	printf "${green}Found!!: $Number_of_lines new subdomains ${reset}\n\n" | notify -silent 2>/dev/null
	printf "\n"
	printf "${yellow}Subdomain Analytics Enumeration Ended${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

subdomain_active()
{	
	printf "${yellow}Active Subdomain Enumeration Started${reset}\n\n" | notify -silent 2>/dev/null
	cat .tmp/passive_subs.txt .tmp/crtsh_subs.txt .tmp/analytics_subs.txt | anew -q .tmp/subs_to_resolve.txt
	if [ "$axiom"= True ]; then
		axiom-scan .tmp/subs_to_resolve.txt -m puredns-resolve -r /home/op/lists/resolvers.txt --resolvers-trusted /home/op/lists/resolvers_trusted.txt -o .tmp/subs_valid.txt &>/dev/null
	else
		eval puredns resolve .tmp/subs_to_resolve.txt -w .tmp/subs_valid.txt -r $tools/resolvers.txt --resolvers-trusted $tools/resolvers_trusted.txt $STD_OUT
	fi
	eval cat .tmp/subs_valid.txt | tlsx -san -cn -silent -ro | anew -q .tmp/subs_valid.txt $STD_OUT
	Number_of_lines=$(cat .tmp/subs_valid.txt | grep ".$domain$" | anew subdomains/subdomains.txt | wc -l)
	printf "\n"
	printf "${green}Found!!: $Number_of_lines valid subdomains ${reset}\n\n" | notify -silent 2>/dev/null
	printf "\n"
	printf "${yellow}Active Subdomain Enumeration Ended${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

subdomain_bruteforcing()
{
	printf "${yellow}Subdomain Bruteforcing Started${reset}\n\n" | notify -silent 2>/dev/null
	if [ "$axiom"= True ]; then
		axiom-scan $subdomains_list -m puredns-single $domain -r /home/op/lists/resolvers.txt --resolvers-trusted /home/op/lists/resolvers_trusted.txt -o .tmp/subs_brute_valid.txt &>/dev/null
	else
	eval puredns bruteforce $subdomains_list $domain -w .tmp/subs_brute_valid.txt -r $tools/resolvers.txt --resolvers-trusted $tools/resolvers_trusted.txt $STD_OUT
	fi 
	Number_of_lines=$(cat .tmp/subs_brute_valid.txt |  grep ".$domain$" | anew subdomains/subdomains.txt | wc -l)
	printf "\n"
	printf "${green}Found!!: $Number_of_lines new subdomains ${reset}\n\n" | notify -silent 2>/dev/null
	printf "\n"
	printf "${yellow}Subdomain Bruteforcing Ended${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

subdomain_permutations()
{
	printf "${yellow}Subdomain Permutations started${reset}\n\n" | notify -silent 2>/dev/null
	$GOTATOR_TIMEOUT gotator -sub subdomains/subdomains.txt -perm $tools/permutation_list.txt -depth 1 -numbers 10 -mindup -adv -md -silent > .tmp/gotator_out.txt
	if [ "$axiom"= True ]; then
		axiom-scan .tmp/gotator_out.txt -m puredns-resolve -r /home/op/lists/resolvers.txt --resolvers-trusted /home/op/lists/resolvers_trusted.txt -o .tmp/permutations_valid.txt &>/dev/null
	else
		eval puredns resolve .tmp/gotator_out.txt -w .tmp/permutations_valid.txt -r $tools/resolvers.txt --resolvers-trusted $tools/resolvers_trusted.txt $STD_OUT
	fi
	Number_of_lines=$(cat .tmp/permutations_valid.txt | grep ".$domains$" | anew subdomains/subdomains.txt | wc -l)
	eval rm .tmp/gotator_out.txt $STD_OUT
	printf "\n"
	printf "${green}Found!!: $Number_of_lines new subdomains ${reset}\n\n" | notify -silent 2>/dev/null
	printf "\n"
	printf "${yellow}Subdomain Permutations Ended${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

subdomain_scraping()
{
	printf "${yellow}Subdomain Scraping started${reset}\n\n" | notify -silent 2>/dev/null
	eval httpx -retries 2 -silent -l subdomains/subdomains.txt -o .tmp/scrap_probed.txt $STD_OUT
	eval gospider -S .tmp/scrap_probed.txt --js -d 2 --sitemap --robots -w -r > .tmp/gospider.txt
	sed -i '/^.\{2048\}./d' .tmp/gospider.txt
	eval cat .tmp/gospider.txt | grep -aEo 'https?://[^ ]+' | sed 's/]$//' | unfurl -u domains | grep ".$domain$" | anew -q .tmp/scrap_subs_no_resolved.txt $STD_OUT
	eval puredns resolve .tmp/scrap_subs_no_resolved.txt -w .tmp/scrap_valid.txt -r $tools/resolvers.txt --resolvers-trusted $tools/resolvers_trusted.txt $STD_OUT
	Number_of_lines=$(cat .tmp/scrap_valid.txt | grep ".$domain$" | anew subdomains/subdomains.txt | wc -l)
	eval rm .tmp/ gospider.txt $STD_OUT
	printf "\n"
	printf "${green}Found!!: $Number_of_lines new subdomains ${reset}\n\n" | notify -silent 2>/dev/null
	printf "\n"
	printf "${yellow}Subdomain Scraping Ended${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}



subdomain_takeover()
{
	printf "${yellow}Subdomain Takeover Detection started${reset}\n\n" | notify -silent 2>/dev/null
	eval nuclei -update-templates $DEBUG_STD
	cat subdomains/subdomains.txt | nuclei -silent -tags takeover -severity low,medium,high,critical -r $tools/resolvers_trusted.txt -retries 3 -o .tmp/sub_takeover.txt &>/dev/null
	Number_of_lines=$(cat .tmp/sub_takeover.txt | anew subdomains/takeovers.txt | wc -l)
	printf "\n"
	printf "${green}Found!!: $Number_of_lines subdomain takeovers${reset}\n\n" | notify -silent 2>/dev/null
	printf "\n"
	printf "${yellow}Subdomain Takeover Detection Ended${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

web_probing()
{
	mkdir -p web/
	printf "${yellow}Web probing on standard ports started${reset}\n\n" | notify -silent 2>/dev/null
	eval httpx -retries 2 -silent -timeout 10 -l subdomains/subdomains.txt -o .tmp/web_probed_tmp.txt $STD_OUT
	Number_of_lines=$(cat .tmp/web_probed_tmp.txt | anew web/webs.txt  | wc -l )
	printf "\n"
	printf "${green}Found!!: $Number_of_lines New Websites${reset}\n\n" | notify -silent 2>/dev/null
	printf "\n"
	printf "${yellow}}Web probing on standard ports Ended${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

web_probing_common()
{
	printf "${yellow}Web probing on common ports started${reset}\n\n" | notify -silent 2>/dev/null
	eval httpx -silent -p $COMMON_WEB_PORTS -l subdomains/subdomains.txt -o .tmp/web_probed_tmp.txt $STD_OUT
	Number_of_lines=$(cat .tmp/web_probed_tmp.txt | anew web/webs.txt  | wc -l )
	printf "\n"
	printf "${green}Found!!: $Number_of_lines New Websites${reset}\n\n" | notify -silent 2>/dev/null
	printf "\n"
	printf "${yellow}Web probing on common ports ended${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

web_screenshot()
{
	printf "${yellow}Web screenshots Started${reset}\n\n" | notify -silent 2>/dev/null
	eval gowitness file -f web/webs.txt -t 8 --disable-logging $STD_OUT
	printf "${yellow}Web screenshots Ended${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

subdomain_end()
{
	printf "${green}Subdomain Enumeration Ended${reset}\n" | notify -silent 2>/dev/null
	printf "${green}##############################################################################${reset}\n"
	printf "${green}##############################################################################${reset}\n\n"
}

axiom_init()
{
	printf "${green}##############################################################################${reset}\n"
	printf "${green}Starting Subdomain Enumeration With *Axiom*${reset}\n" | notify -silent 2>/dev/null
	axiom-exec 'wget -q -O - https://raw.githubusercontent.com/trickest/resolvers/main/resolvers.txt > /home/op/lists/resolvers.txt' &>/dev/null
	axiom-exec 'wget -q -O - https://raw.githubusercontent.com/trickest/resolvers/main/resolvers-trusted.txt > /home/op/lists/resolvers_trusted.txt' &>/dev/null
	mkdir -p subdomains/
}


help()
{	
	printf "Reconizer is a all-in-one Reconnaisance tool that performs\n"
	printf "subdomain using various techniques that guarantee the best results.\n"
	printf "Usage: $0 [-d domain] [-o] [-s]\n"
	printf "${blue}TARGET OPTIONS${reset}\n"
	printf "	-d example.com  Target Domain\n\n"
	printf "${blue}SCAN MODES${reset}\n"
	printf "	-n OSINT Scan\n"
	printf "	-s Subdomain Scan\n"
	printf "	-a Axiom Subdomain Scan\n"
	printf "	-f All Scan\n\n"
	printf "${blue}OUTPUT OPTIONS${reset}\n"
	printf "	-o Output Folder\n\n"
	printf "${blue}SHOW HELP SECTION${reset}\n"
	printf "	-h Display help section\n\n"
	printf "${blue}USAGE EXAMPLE${reset}\n"
	printf "OSINT Scan:\n"
	printf "./reconizer.sh -d example.com -n\n\n"
	printf "Subdomain Enumeration Scan:\n"
	printf "./reconizer.sh -d example.com -s\n\n"
	printf "Custom Output Folder Location:\n"
	printf "./reconizer.sh -d example.com -s -o /path/to/folder\n\n"
	printf "${green}##########################################################################${reset}\n"
}



banner


if [ -z "$1" ]
then
   help
   exit
fi


while getopts ":d:o:snahc" opt;do
	case ${opt} in
		d ) domain=$OPTARG
			;;
		n )
			start
			osint_init
			google_dorks
			github_dorks
			email_osint
			osint_end
			;;
		s )
			start
			subdomain_init
			subdomain_passive
			subdomain_crt
			subdomain_analytics
			subdomain_active
			subdomain_bruteforcing
			subdomain_permutations
			subdomain_scraping
			subdomain_takeover
			web_probing
			web_probing_common
			web_screenshot
			subdomain_end
			;;
		o ) output_folder=$OPTARG
			;;
		f )
			start
			osint_init
			google_dorks
			github_dorks
			email_osint
			osint_end
			subdomain_init
			subdomain_passive
			subdomain_crt
			subdomain_analytics
			subdomain_active
			subdomain_bruteforcing
			subdomain_permutations
			subdomain_scraping
			subdomain_takeover
			web_probing
			web_probing_common
			web_screenshot
			subdomain_end
			;;
		a )
			axiom="True"
			start
			axiom_init
			subdomain_passive
			subdomain_crt
			subdomain_analytics
			subdomain_active
			subdomain_bruteforcing
			subdomain_permutations
			subdomain_scraping
			subdomain_takeover
			web_probing
			web_probing_common
			web_screenshot
			subdomain_end
			;;
		c )
			tools_installed
			;;
		\? | h | : | * )
			help
			;;
	esac
done
shift $((OPTIND -1))


