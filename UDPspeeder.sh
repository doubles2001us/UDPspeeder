#!/bin/bash

red='\e[91m'
green='\e[92m'
yellow='\e[93m'
none='\e[0m'

[[ $(id -u) != 0 ]] && echo -e " \nOops……please use ${red}root ${none}user running ${yellow}~(^_^) ${none}\n" && exit 1

cmd="apt-get"

sys_bit=$(uname -m)

# 笨笨的检测方法
if [[ -f /usr/bin/apt-get ]] || [[ -f /usr/bin/yum ]]; then

	if [[ -f /usr/bin/yum ]]; then

		cmd="yum"

	fi

else

	echo -e " \nHaha……this ${red}rubbish script${none} doesn't support your system. ${yellow}(-_-) ${none}\n" && exit 1

fi

if [[ $sys_bit == "i386" || $sys_bit == "i686" ]]; then
	speeder_ver="speederv2_x86"
elif [[ $sys_bit == "x86_64" ]]; then
	speeder_ver="speederv2_amd64"
else
	echo -e " \n$redHaven't supported system....$none\n" && exit 1
fi

install() {
	$cmd install wget -y
# 	ver=$(curl -s https://api.github.com/repos/wangyu-/UDPspeeder/releases/latest | grep 'tag_name' | cut -d\" -f4)
	ver="20180522.0"
	UDPspeeder_download_link="https://github.com/wangyu-/UDPspeeder/releases/download/$ver/speederv2_binaries.tar.gz"
	mkdir -p /tmp/UDPspeeder
	if ! wget --no-check-certificate --no-cache -O "/tmp/UDPspeeder.tar.gz" $UDPspeeder_download_link; then
		echo -e "$red Downloading UDPspeeder failed!$none" && exit 1
	fi
	tar zxf /tmp/UDPspeeder.tar.gz -C /tmp/UDPspeeder
	cp -f /tmp/UDPspeeder/$speeder_ver /usr/bin/speederv2
	chmod +x /usr/bin/speederv2
	if [[ -f /usr/bin/speederv2 ]]; then
		clear
		echo -e " 
		$green UDPspeeder Installation is done...$none

		Input$yellow speederv2 $noneto begin....

		Notice...this is only used to install or remove...
		
		As for how to set...run in background...autostart on boot...

		Buddy....figure out by yourself...

		Problem feedback: https://github.com/233boy/UDPspeeder/issues
		
		UDPspeeder help or feedback: https://github.com/wangyu-/UDPspeeder
		"
	else
		echo -e " \n$redFailed...$none\n"
	fi
	rm -rf /tmp/UDPspeeder
	rm -rf /tmp/UDPspeeder.tar.gz
}
uninstall() {
	if [[ -f /usr/bin/speederv2 ]]; then
		UDPspeeder_pid=$(pgrep "speederv2")
		[ $UDPspeeder_pid ] && kill -9 $UDPspeeder_pid
		rm -rf /usr/bin/speederv2
		echo -e " \n$greenRemoved...$none\n" && exit 1
	else
		echo -e " \n$redHi buddy...it seems you haven't installed UDPspeeder ....nothing...$none\n" && exit 1
	fi
}
error() {

	echo -e "\n$red Input error!$none\n"

}
while :; do
	echo
	echo "........... UDPspeeder Quick Installation Tool by 233blog.com .........."
	echo
	echo "For more help: https://233blog.com/post/12/"
	echo
	echo " 1. install"
	echo
	echo " 2. remove"
	echo
	read -p "choice[1-2]:" choose
	case $choose in
	1)
		install
		break
		;;
	2)
		uninstall
		break
		;;
	*)
		error
		;;
	esac
done
