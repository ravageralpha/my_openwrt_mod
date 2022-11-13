my_openwrt_mod
==============

Install
-------

Add this line to your feeds.conf.default.

    src-git-full ramod https://github.com/ravageralpha/my_openwrt_mod.git

And run

    ./scripts/feeds update -a && ./scripts/feeds install -a
