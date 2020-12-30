#!/bin/sh

wget -q https://raw.githubusercontent.com/cokebar/gfwlist2dnsmasq/master/gfwlist2dnsmasq.sh && chmod +x gfwlist2dnsmasq.sh
./gfwlist2dnsmasq.sh -l -o list.txt

cat >/etc/smartdns/address.conf <<EOF
# Add domains which you want to force to an IP address here.
# The example below send any host in example.com to a local webserver.
# address /domain/[ip|-|-4|-6|#|#4|#6]
# address /www.example.com/1.2.3.4, return ip 1.2.3.4 to client
# address /www.example.com/-, ignore address, query from upstream, suffix 4, for ipv4, 6 for ipv6, none for all
# address /www.example.com/#, return SOA to client, suffix 4, for ipv4, 6 for ipv6, none for all

# specific ipset to domain
# ipset /domain/[ipset|-]
# ipset /www.example.com/block, set ipset with ipset name of block 
# ipset /www.example.com/-, ignore this domain

# specific nameserver to domain
# nameserver /domain/[group|-]
# nameserver /www.example.com/office, Set the domain name to use the appropriate server group.
# nameserver /www.example.com/-, ignore this domain

EOF

gfwlist=$(cat ./list.txt)
for line in $gfwlist; do
	echo "address /$line/#6" >>/etc/smartdns/address.conf
done
rm list.txt ./gfwlist2dnsmasq.sh
