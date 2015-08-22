#!/bin/sh
. /lib/netifd/netifd-proto.sh

LOCAL_ADDR="${net%???}"
MASK="$(echo $net | tail -c3)"
REMOTE_ADDR="$(echo "$LOCAL_ADDR" | sed -e "s#\(.*\)\..*#\1#").1"
DEFAULT_GATEWAY="$(ip route show 0/0 | sort -k 7 | head -n 1 | sed -e 's/.* via \([^ ]*\).*/\1/')"

proto_init_update "$intf" 1
proto_add_ipv4_address "$LOCAL_ADDR" $MASK "" "$LOCAL_ADDR"

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
