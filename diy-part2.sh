#!/bin/bash

pushd package/lean
rm -rf luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config
popd

# 更改主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

#修复核心及添加温度显示
#sed -i 's|pcdata(boardinfo.system or "?")|luci.sys.exec("uname -m") or "?"|g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm
#sed -i 's/or "1"%>/or "1"%> ( <%=luci.sys.exec("expr `cat \/sys\/class\/thermal\/thermal_zone0\/temp` \/ 1000") or "?"%> \&#8451; ) /g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm

# 去除 luci-app-socat与socat冲突文件
sed -i '/INSTALL_CONF/d' feeds/packages/net/socat/Makefile
sed -i '/socat\.init/d' feeds/packages/net/socat/Makefile

# 去除 lean的老版smartdns
rm -rf feeds/packages/net/smartdns
rm -rf package/feeds/packages/smartdns

mkdir ./package/self_add
pushd package/self_add

# Add Lienol access cnotrol
svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-control-timewol
svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-control-webrestriction
svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-control-weburl
svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-timecontrol

# Add ssr plus
https://github.com/fw876/helloworld.git

# Add luci-app-socat 
svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-socat

# Add self settings
git clone https://github.com/WROIATE/openwrt-settings

# Add luci-app-ustb
git clone https://github.com/WROIATE/luci-app-ustb

# Add luci-app-mqos
git clone https://github.com/WROIATE/luci-app-mqos

# Add ServerChan
git clone --depth=1 https://github.com/tty228/luci-app-serverchan

# Add OpenClash
git clone --depth=1 -b master https://github.com/vernesong/OpenClash

# Add luci-app-onliner (need luci-app-nlbwmon)
# git clone --depth=1 https://github.com/rufengsuixing/luci-app-onliner

# Add luci-app-adguardhome
svn co https://github.com/Lienol/openwrt/trunk/package/diy/luci-app-adguardhome
sed -i "/.*noresolv=1/a\\\tuci set dhcp.@dnsmasq[0].cachesize=0" luci-app-adguardhome/root/etc/init.d/AdGuardHome
svn co https://github.com/WROIATE/openwrt-package/trunk/AdguardHome

# Add luci-app-adblockplus
# git clone https://github.com/garypang13/luci-app-adblock-plus

# Add smartdns
svn co https://github.com/Lienol/openwrt-packages/trunk/net/smartdns
sed -i "s/PKG_SOURCE_VERSION:.*/PKG_SOURCE_VERSION:=Release33/g" smartdns/Makefile
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-smartdns

# Add OpenAppFilter
git clone --depth=1 https://github.com/destan19/OpenAppFilter

# Add unblockmusic
# git clone https://github.com/WROIATE/luci-app-unblockneteasemusic
# rm -rf luci-app-unblockneteasemusic/UnblockNeteaseMusic
git clone https://github.com/immortalwrt/luci-app-unblockneteasemusic
popd

# Mod zzz-default-settings
pushd package/lean/default-settings/files
sed -i "/-j REDIRECT --to-ports 53/d" zzz-default-settings
sed -i "/REDIRECT --to-ports 53/a\echo '# iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53' >> /etc/firewall.user" zzz-default-settings
# sed -i "/exit 0/i\echo 'echo \"performance\" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor' >> /etc/rc.loacl" zzz-default-settings
popd

# 修改限制时间防止passwall在nginx下无法使用 uwsgi ini file
pushd feeds/packages/net/uwsgi/files-luci-support
sed -i "s/limit-as = 1000/limit-as = 100000/g" luci-webui.ini
popd
