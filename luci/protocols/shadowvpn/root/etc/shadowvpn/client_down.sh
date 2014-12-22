#!/bin/sh
. /lib/netifd/netifd-proto.sh

DEFAULT_GATEWAY_IP="`cat /var/etc/shadowvpn_defaultgw_ip`"

proto_init_update "$intf" 0
proto_send_update "$INTERFACE"

if [ -f /tmp/routes ]; then
  sed -i 's#route add#route del#g' /tmp/routes
  ip -batch /tmp/routes
  rm -f /tmp/routes
fi

route del "$server" gw "$DEFAULT_GATEWAY_IP"
route add default gw "$DEFAULT_GATEWAY_IP"
rm -f "/var/etc/shadowvpn_defaultgw_ip"

echo $0 done