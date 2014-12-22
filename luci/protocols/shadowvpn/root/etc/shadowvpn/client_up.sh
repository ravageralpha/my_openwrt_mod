#!/bin/sh
. /lib/netifd/netifd-proto.sh

LOCAL_ADDRESS="10.7.0.2"
REMOTE_ADDRESS="10.7.0.1"
DEFAULT_GATEWAY_IP="`netstat -r -n | awk '/:/ { next; } /^(default|0\.0\.0\.0)/ { print $2; }'`"
DEFAULT_GATEWAY="`netstat -r -n | awk '/:/ { next; } /^(default|0\.0\.0\.0)/ { print $8; }'`"

echo $DEFAULT_GATEWAY_IP > /var/etc/shadowvpn_defaultgw_ip

proto_init_update "$intf" 1
proto_add_ipv4_address "$LOCAL_ADDRESS" 24 "$LOCAL_ADDRESS"

# you know what? ubus sucks...
ifconfig "$intf" mtu "$mtu"
route add "$server" gw "$DEFAULT_GATEWAY_IP"

proto_add_ipv4_route "$REMOTE_ADDRESS" 0

chnroutes="/etc/chinadns_chnroute.txt"
if [ -f "$chnroutes" ]; then
	sed -e "s/^/route add &/g" -e "s/$/ via $DEFAULT_GATEWAY_IP dev $DEFAULT_GATEWAY/g" \
			$chnroutes > /tmp/routes
	ip -batch /tmp/routes
fi

proto_send_update "$INTERFACE"

echo $0 done
