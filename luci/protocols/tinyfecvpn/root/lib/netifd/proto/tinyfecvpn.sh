#!/bin/sh
. /lib/functions.sh
. ../netifd-proto.sh
init_proto "$@"

proto_tinyfecvpn_init_config() {
	proto_config_add_string "server"
	proto_config_add_string "passwd"
	proto_config_add_string "fec"
	proto_config_add_string "subnet"
	proto_config_add_string "extra"
	no_device=1
	available=1
}

proto_tinyfecvpn_setup() {
	local config="$1"

	json_get_vars server passwd fec subnet extra

	grep -q tun /proc/modules || insmod tun

	logger -t tinyfecvpn "initializing..."

	proto_export INTERFACE="$config"
	logger -t tinyfecvpn "executing tinyfecVPN"

	proto_run_command "$config" \
	/usr/bin/tinyfecvpn -c \
			-r $server \
			-k $passwd \
			-f $fec \
			--manual-set-tun \
			--tun-dev vpn-$config \
			--sub-net $subnet \
			$extra

	[ -f "/etc/tinyfecvpn/client_up.sh" ] && {
		/bin/sh /etc/tinyfecvpn/client_up.sh \
			"$config" "vpn-$config" "$server" "$subnet"
	}

	mkdir -p /var/etc
	[ "$?" = 0 ] && echo "$config" > /var/etc/tinyfecvpn
}

proto_tinyfecvpn_teardown() {
	local config="$1"
	logger -t tinyfecvpn "bringing down tinyfecVPN"
	proto_kill_command "$config"
	[ -f "/etc/tinyfecvpn/client_down.sh" ] && {
		/bin/sh /etc/tinyfecvpn/client_down.sh \
			"$config" "vpn-$config" "$server"
	}
	rm -f /var/etc/tinyfecvpn
}

add_protocol tinyfecvpn
