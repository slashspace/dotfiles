# zsh

## Navigation
..     cd ..
...    cd ../..

## Utilities
path   Print $PATH entries (one per line)
c      clear

## Git
gs        git status -sb
ga        git add .
gc        git commit -m
glog      git log --oneline --graph --all

## VPN
vpn-bridge   Establish SSH SOCKS5 tunnel (127.0.0.1:1080 via port 2222)
vpn-on       Enable terminal proxy (ALL_PROXY=socks5://127.0.0.1:1080)
vpn-off      Disable terminal proxy (unset ALL_PROXY)
