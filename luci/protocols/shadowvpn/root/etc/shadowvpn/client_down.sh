#!/bin/sh
. /lib/netifd/netifd-proto.sh

proto_init_update "$intf" 0
proto_send_update "$INTERFACE"

if [ -f /tmp/routes ]; then
  sed -i 's#route add#route del#g' /tmp/routes
  ip -batch /tmp/routes
  rm -f /tmp/routes
fi

echo $0 done