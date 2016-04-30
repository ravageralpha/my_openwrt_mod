#!/bin/sh
. /lib/functions.sh
. ../netifd-proto.sh
init_proto "$@"

proto_tun2socks_init_config() {
	proto_config_add_string "server"
	proto_config_add_string "remote"
	proto_config_add_string "interface"
	proto_config_add_string "localnet"
	proto_config_add_int "udprelay"
	proto_config_add_string "opts"
	proto_config_add_string "localdns"
	no_device=1
	available=1
}

proto_tun2socks_setup() {
	local config="$1"

	json_get_vars server interface localnet remote udprelay opts localdns

	grep -q tun /proc/modules || insmod tun

	logger -t tun2socks "initializing..."
	proto_add_host_dependency "$config" "$remote" $interface
	
	[ -n "$localdns" ] && {
		for i in $(echo $localdns | tr "," "\n")
		do
			proto_add_host_dependency "$config" "$i" $interface
		done
	}

	proto_export INTERFACE="$config"
	logger -t tun2socks "executing tun2socks"

	local localip="`/bin/ipcalc.sh $localnet | grep IP | cut -d'=' -f2`"
	local netmask="`/bin/ipcalc.sh $localnet | grep NETMASK | cut -d'=' -f2`"

	proto_run_command "$config" \
	/usr/bin/tun2socks \
		--logger syslog \
		--loglevel 1 \
		--tundev "vpn-$config" \
		--netif-ipaddr "$localip" \
		--netif-netmask "$netmask" \
		--socks-server-addr "$server" \
		${udprelay:+--enable-udprelay} \
		${opts:+$opts}

	[ -f "/etc/tun2socks/client_up.sh" ] && {
		/bin/sh /etc/tun2socks/client_up.sh \
			"$config" "vpn-$config" "$localnet"
	}
}

proto_tun2socks_teardown() {
	local config="$1"
	logger -t tun2socks "bringing down tun2socks"
	proto_kill_command "$config"
	[ -f "/etc/tun2socks/client_down.sh" ] && {
		/bin/sh /etc/tun2socks/client_down.sh \
			"$config" "vpn-$config"
	}
}

add_protocol tun2socks
