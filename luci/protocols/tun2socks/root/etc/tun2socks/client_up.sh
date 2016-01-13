#!/bin/sh
. /lib/netifd/netifd-proto.sh

INTERFACE="$1"
INTF="$2"
LOCALNET="$3"

REMOTE_ADDR="${LOCALNET%???}"
MASK="$(echo $LOCALNET | tail -c3)"
TUNIP="$(echo "$REMOTE_ADDR" | sed -e "s#\(.*\)\..*#\1#").1"
DEFAULT_GATEWAY="$(ip route show 0/0 | sort -k 7 | head -n 1 | sed -e 's/.* via \([^ ]*\).*/\1/')"

proto_init_update "$INTF" 1
proto_add_ipv4_address "$TUNIP" $MASK "" "$TUNIP"

proto_add_ipv4_route "0.0.0.0" 1 "$REMOTE_ADDR"
proto_add_ipv4_route "128.0.0.0" 1 "$REMOTE_ADDR"

chnroutes="/etc/chinadns_chnroute.txt"
if [ -f "$chnroutes" ]; then
	sed -e "s/^/route add &/g" -e "s/$/ via $DEFAULT_GATEWAY/g" \
			$chnroutes > /tmp/routes
	/usr/bin/ip -batch /tmp/routes
fi

proto_send_update "$INTERFACE"

echo $0 done
