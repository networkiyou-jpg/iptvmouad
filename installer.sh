#!/bin/sh
# =====================================================================================
#  Mouad IPTV Player - installer for Enigma2 (OpenATV / OpenPLi / VTi ...)
#  Telnet / SSH:
#    wget -q --no-check-certificate https://raw.githubusercontent.com/networkiyou-jpg/iptvmouad/main/installer.sh -O - | /bin/sh
#  Telegram: @Kingsharing1
#  Subscriptions, favourites, settings and the license of the receiver are kept.
# =====================================================================================
REPO="https://raw.githubusercontent.com/networkiyou-jpg/iptvmouad/main"
PACKAGE="enigma2-plugin-extensions-mouadiptv"
IPK="${PACKAGE}.ipk"                       # fixed name: upload new versions with the same name
TMP="/tmp/${IPK}"
E2ROOT="${E2ROOT:-}"                       # empty on the receiver (used only for tests)
PLUGIN="${E2ROOT}/usr/lib/enigma2/python/Plugins/Extensions/MouadIPTV"

line() { echo "================================================================"; }
fail() { line; echo "  ERROR: $1"; line; rm -f "$TMP"; exit 1; }

line
echo "  Mouad IPTV Player - installation"
line

[ "$(id -u 2>/dev/null)" = "0" ] || [ -n "$E2ROOT" ] || fail "run this command as root"
command -v opkg >/dev/null 2>&1 || fail "opkg not found: this is not an Enigma2 receiver"
[ -d "${E2ROOT}/usr/lib/enigma2" ] || fail "Enigma2 not found on this receiver"

installed() { opkg list-installed 2>/dev/null | grep "^${PACKAGE} " | awk '{print $3}'; }
OLD=$(installed)
[ -n "$OLD" ] && echo "  Installed version : $OLD" || echo "  Installed version : none"

# ---- download -----------------------------------------------------------------------
echo "  Downloading ..."
rm -f "$TMP"
if command -v wget >/dev/null 2>&1; then
    wget -q --no-check-certificate -T 30 "${REPO}/${IPK}?t=$(date +%s)" -O "$TMP" 2>/dev/null || \
    wget -q "${REPO}/${IPK}" -O "$TMP" 2>/dev/null
fi
if [ ! -s "$TMP" ] && command -v curl >/dev/null 2>&1; then
    curl -s -k -L --max-time 60 "${REPO}/${IPK}" -o "$TMP"
fi
[ -s "$TMP" ] || fail "download failed: check the internet connection of the receiver"

SIZE=$(wc -c < "$TMP" | tr -d ' ')
HEAD=$(dd if="$TMP" bs=7 count=1 2>/dev/null)
[ "$HEAD" = "!<arch>" ] && [ "$SIZE" -gt 100000 ] || fail "the downloaded file is not a valid package (${SIZE} bytes)"
echo "  Downloaded        : ${SIZE} bytes"

# ---- install (user data in /etc/enigma2/mouadiptv is never touched) ------------------
echo "  Installing ..."
if ! opkg install --force-reinstall "$TMP"; then
    echo "  Updating the package list and retrying ..."
    opkg update >/dev/null 2>&1
    opkg install --force-reinstall "$TMP" || fail "opkg could not install the package (see the messages above)"
fi
rm -f "$TMP"
[ -f "${PLUGIN}/plugin.py" ] || fail "installation incomplete: ${PLUGIN}/plugin.py is missing"
rm -rf "${PLUGIN}/__pycache__" "${PLUGIN}/src/__pycache__" 2>/dev/null

if grep -q "^SERVER_URL = ''" "${PLUGIN}/src/license_config.py" 2>/dev/null; then
    echo "  NOTE: this package has no license server (developer build)."
fi

NEW=$(installed)
sync
line
echo "  Mouad IPTV Player ${NEW} installed successfully."
echo "  Menu > Plugins > Mouad IPTV Player"
echo "  License & Activation: open the plugin, then MENU."
echo "  Support: Telegram @Kingsharing1"
line

# ---- restart the GUI ----------------------------------------------------------------
if [ "${NORESTART:-0}" = "1" ]; then
    echo "  Restart Enigma2 to load the plugin."
    exit 0
fi
echo "  Restarting Enigma2 in 3 seconds ..."
sleep 3
if command -v systemctl >/dev/null 2>&1 && systemctl is-active enigma2 >/dev/null 2>&1; then
    systemctl restart enigma2
else
    init 4 >/dev/null 2>&1; sleep 4; init 3 >/dev/null 2>&1 || killall -9 enigma2 >/dev/null 2>&1
fi
exit 0
