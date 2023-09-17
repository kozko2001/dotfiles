## README

build with:

linux: `sudo nixos-rebuild --flake .#tower switch`
mac: 
  1. install nix `sh <(curl -L https://nixos.org/nix/install) --daemon`
  1. install homebrew (nix doesn't use it if it's not installed) `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
  2. install nix-darwin 
  ```
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
 nix run --extra-experimental-features nix-command --extra-experimental-features flakes  nix-darwin -- switch --flake .#mac
  ```
  2. `darwin-rebuild switch --flake .#mac`


## after install

1. connect to localhost:8384 and setup syncthing

2. once we have keepass extract ssh keys

```
mkdir ~/.ssh
keepassxc-cli attachment-export ~/keepass/keepass.kdbx "digital ocean" "Oceans_id_rsa.pub" ~/.ssh/id_rsa.pub
keepassxc-cli attachment-export ~/keepass/keepass.kdbx "digital ocean" "Oceans_id_rsa" ~/.ssh/id_rsa
````



