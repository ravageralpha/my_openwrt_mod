#!/bin/sh
. /lib/netifd/netifd-proto.sh

INTERFACE="$1"
INTF="$2"
SERVER="$3"
DNS="$4"

proto_init_update "$INTF" 0
proto_send_update "$INTERFACE"

ip route del $SERVER
ip route del $DNS

if [ -f /tmp/routes ]; then
  sed -i 's#route add#route del#g' /tmp/routes
  ip -batch /tmp/routes
  rm -f /tmp/routes
fi

echo $0 done