#!/bin/sh
. /lib/functions.sh
. ../netifd-proto.sh
init_proto "$@"

proto_shadowvpn_init_config() {
	proto_config_add_string "server"
	proto_config_add_int "port"
	proto_config_add_string "password"
	no_device=1
	available=1
}

proto_shadowvpn_setup() {
	local config="$1"

	json_get_vars server port password

	grep -q tun /proc/modules || insmod tun

	logger -t shadowvpn "initializing..."

	[ -z "$server" ] || [ -z "$port" ] || [ -z "$password" ] && {
		logger -t shadowvpn "Missing required configuration"
		proto_setup_failed "$config"
		exit 1
	}

	mkdir -p /var/etc
	sed -e "s#|SERVER|#$server#g" \
		-e "s#|PORT|#$port#g" \
		-e "s#|PASSWORD|#$password#g" \
		-e "s#|INTERFACE|#vpn-$config#g" \
		/etc/shadowvpn/client.conf.template > /var/etc/shadowvpnclient.conf

	proto_export INTERFACE="$config"
	logger -t shadowvpn "executing ShadowVPN"
	proto_run_command "$config" \
	/usr/bin/shadowvpn -c /var/etc/shadowvpnclient.conf
}

proto_shadowvpn_teardown() {
	local config="$1"
	logger -t shadowvpn "bringing down ShadowVPN"
	proto_kill_command "$config"
	rm /var/etc/shadowvpnclient.conf
}

add_protocol shadowvpn
