#!/bin/sh

uci -q batch <<-EOF >/dev/null
	delete ucitrack.@pdnsd[-1]
	add ucitrack pdnsd
	set ucitrack.@pdnsd[-1].init=pdnsd
	commit ucitrack
EOF

rm -f /tmp/luci-indexcache
exit 0
