# Description: Updates xc to latest version
sudo sh -c "curl -H 'Cache-Control: no-cache' -s https://raw.githubusercontent.com/xordeio/xc/main/xc?$(date +%s) > /usr/bin/xc && chmod +x /usr/bin/xc"
