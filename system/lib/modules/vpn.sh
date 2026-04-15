
# 1. 建立隧道的快捷命令
alias vpn-bridge="ssh -f -D 1080 -N -p 2222 dingsheng@127.0.0.1"“ssh -f -D 1080 -N -p 2222 dingsheng@127.0.0.1”

# 2. 开启/关闭终端代理
alias vpn-on="export ALL_PROXY=socks5://127.0.0.1:1080"
alias vpn-off="unset ALL_PROXY"
