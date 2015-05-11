You should configure firewall manually to work properly.

/etc/config/network

config interface 'shadowvpn'
    option proto 'shadowvpn'
    option server 'xxx'
    option port 'xxx'
    option password 'xxx'
    option auto '0'
    option mtu '1440'
    option concurrency '1'
    option interface 'wan'

/etc/config/firewall

config zone
    option name 'vpn'
    option input 'ACCEPT'
    option output 'ACCEPT'
    option forward 'REJECT'
    option masq '1'
    option network 'shadowvpn'
    option mtu_fix '1'

config forwarding
    option src 'vpn'
    option dest 'lan'

config forwarding
    option src 'lan'
    option dest 'vpn'

