## README

build with:

linux: `sudo nixos-rebuild --flake .#tower switch`
mac: 
  1. install nix `sh <(curl -L https://nixos.org/nix/install) --daemon`
  2. install nix-darwin 
  ```
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
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



