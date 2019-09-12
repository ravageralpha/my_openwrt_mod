#!/bin/sh
. /lib/netifd/netifd-proto.sh

INTERFACE="$1"
INTF="$2"
SERVER=${3%:*}
LOCAL_ADDR="${4%.*}.2"
REMOTE_ADDR="${4%.*}.1"
DEFAULT_GATEWAY="$(ip route show 0/0 | sort -k 7 | head -n 1 | sed -e 's/.* via \([^ ]*\).*/\1/')"

proto_init_update "$INTF" 1
proto_add_ipv4_address "$LOCAL_ADDR" 24 "" "$LOCAL_ADDR"

proto_add_ipv4_route "0.0.0.0" 1 "$REMOTE_ADDR"
proto_add_ipv4_route "128.0.0.0" 1 "$REMOTE_ADDR"

ip route add $SERVER via $DEFAULT_GATEWAY

chnroutes="/etc/chinadns_chnroute.txt"
if [ -f "$chnroutes" ]; then
	sed -e "s/^/route add &/g" -e "s/$/ via $DEFAULT_GATEWAY/g" \
			$chnroutes > /tmp/routes
	ip -batch /tmp/routes
fi

proto_send_update "$INTERFACE"

echo $0 done
