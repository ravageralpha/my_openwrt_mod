#!/bin/sh
. /lib/netifd/netifd-proto.sh

LOCAL_ADDR="10.7.0.2"
REMOTE_ADDR="10.7.0.1"
DEFAULT_GATEWAY="`netstat -r -n | awk '/:/ { next; } /^(default|0\.0\.0\.0)/ { print $2; }'`"

proto_init_update "$intf" 1
proto_add_ipv4_address "$LOCAL_ADDR" 24 "" "$LOCAL_ADDR"

ifconfig "$intf" mtu "$mtu"

proto_add_ipv4_route "0.0.0.0" 1 "$REMOTE_ADDR"
proto_add_ipv4_route "128.0.0.0" 1 "$REMOTE_ADDR"

chnroutes="/etc/chinadns_chnroute.txt"
if [ -f "$chnroutes" ]; then
	sed -e "s/^/route add &/g" -e "s/$/ via $DEFAULT_GATEWAY/g" \
			$chnroutes > /tmp/routes
	ip -batch /tmp/routes
fi

proto_send_update "$INTERFACE"

echo $0 done
