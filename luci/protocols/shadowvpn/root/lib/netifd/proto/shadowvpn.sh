#!/bin/sh
. /lib/functions.sh
. ../netifd-proto.sh
init_proto "$@"

proto_shadowvpn_init_config() {
	proto_config_add_string "server"
	proto_config_add_int "port"
	proto_config_add_string "password"
	proto_config_add_string "mtu"
	proto_config_add_string "concurrency"
	proto_config_add_string "interface"
	no_device=1
	available=1
}

proto_shadowvpn_setup() {
	local config="$1"

	json_get_vars server port password mtu concurrency interface usertoken localnet

	grep -q tun /proc/modules || insmod tun

	logger -t shadowvpn "initializing..."

	serv_addr=
	for ip in $(resolveip -t 10 "$server"); do
		( proto_add_host_dependency "$config" "$ip" $interface )
		serv_addr=1
	done
	[ -n "$serv_addr" ] || {
		logger -t shadowvpn "Could not resolve server address: '$server'"
		sleep 60
		proto_setup_failed "$config"
		exit 1
	}

	mkdir -p /var/etc
	sed -e "s#|SERVER|#$server#g" \
		-e "s#|PORT|#$port#g" \
		-e "s#|PASSWORD|#$password#g" \
		-e "s#|NET|#$localnet#g" \
		-e "s#|INTERFACE|#vpn-$config#g" \
		-e "s#|MTU|#$mtu#g" \
		-e "s#|CONCURRENCY|#$concurrency#g" \
		/etc/shadowvpn/client.conf.template > /var/etc/shadowvpnclient.conf

	if [[ -n $usertoken ]]; then
		echo "user_token=$usertoken" >> /var/etc/shadowvpnclient.conf
	fi

	proto_export INTERFACE="$config"
	logger -t shadowvpn "executing ShadowVPN"

	proto_run_command "$config" \
	/usr/bin/shadowvpn -c /var/etc/shadowvpnclient.conf
}

proto_shadowvpn_teardown() {
	local config="$1"
	logger -t shadowvpn "bringing down ShadowVPN"
	proto_kill_command "$config"
	rm -f /var/etc/shadowvpnclient.conf
}

add_protocol shadowvpn
