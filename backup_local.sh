#! /bin/bash

set -e

[[ $EUID = 0 ]] && >&2 echo "Do not run as root" && exit 1

local_dotfiles=./local
[ ! -d $local_dotfiles ] && >&2 echo "${local_dotfiles} not found" && exit 1

[ ! -e ./local.tar.gz ] || rm ./local.tar.gz
[ ! -e ./local.tar.gz.gpg ] || rm ./local.tar.gz.gpg

tar czf ./local.tar.gz $local_dotfiles
gpg -c --force-mdc --s2k-mode 3 --s2k-count 65011712 ./local.tar.gz

# decrypt: gpg local.tar.gz.gpg
# extract: tar xzf local.tar.gz

[ ! -e ./local.tar.gz ] || rm ./local.tar.gz
echo "done"