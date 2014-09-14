my_openwrt_mod
==============

Install
-------

Add this line to your feeds.conf.default.

    src-git ramod git://github.com/ravageralpha/my_openwrt_mod.git 

And comment this line 

    #src-git luci http://git.openwrt.org/project/luci.git


And run

    ./scripts/feeds update -a && ./scripts/feeds install -a
