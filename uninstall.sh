#!/bin/sh
# Mouad IPTV Player - remove the plugin. Subscriptions and settings are KEPT
# (/etc/enigma2/mouadiptv), so a new installation finds them again.
#   wget -q --no-check-certificate https://raw.githubusercontent.com/networkiyou-jpg/iptvmouad/main/uninstall.sh -O - | /bin/sh
echo "================================================================"
echo "  Removing Mouad IPTV Player ..."
opkg remove enigma2-plugin-extensions-mouadiptv
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/MouadIPTV 2>/dev/null
echo "  Done. Your subscriptions and settings were kept in /etc/enigma2/mouadiptv"
echo "  Restarting Enigma2 in 3 seconds ..."
echo "================================================================"
sleep 3
init 4 >/dev/null 2>&1; sleep 4; init 3 >/dev/null 2>&1 || killall -9 enigma2 >/dev/null 2>&1
exit 0
