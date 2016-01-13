#!/bin/sh
. /lib/netifd/netifd-proto.sh

INTERFACE="$1"
INTF="$2"

proto_init_update "$INTF" 0
proto_send_update "$INTERFACE"

if [ -f /tmp/routes ]; then
  sed -i 's#route add#route del#g' /tmp/routes
  /usr/bin/ip -batch /tmp/routes
  rm -f /tmp/routes
fi

echo $0 done