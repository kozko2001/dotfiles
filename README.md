## README

### Hosts

| Host | Description |
|------|-------------|
| `framework` | Framework 13 AMD 7040 laptop |
| `tower` | Desktop tower |
| `new-moriarty` | NAS / home server |
| `mate` | Secondary machine |
| `mac` | macOS (nix-darwin) |

### Build

**Linux (framework / tower / new-moriarty / mate) — preferred:**
```
nh os switch        # rebuild and activate (framework has flake path pre-configured)
nh os switch --ask  # for other hosts, or pass hostname explicitly
```

**Linux — manual:**
```
sudo nixos-rebuild switch --flake .#framework
sudo nixos-rebuild switch --flake .#tower
```

**mac:**
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

## test nvim config 

```
XDG_CONFIG_HOME=/home/kozko/tmp/dotfiles/apps  nvim .
```
## update flake inputs

```
nix flake update
nh os switch
```

**Single input** (e.g. only update nixpkgs):
```
nix flake update nixpkgs
nh os switch
```

## remote rebuild

```
nixos-rebuild switch \
  --flake .#new-moriarty \
  --target-host kozko@192.168.1.245 \
  --use-remote-sudo --ask-sudo-password
```

## Secrets

I don't use secrets for the nix configuration (yet :P)

But for some external programs that I want them to have access to certain API tokens etc... I do.

You can encrypt with

```
age -R ~/.ssh/id_rsa.pub > apps/nvim/openai.age
```

and decrypt with...

```
age -d -i ~/.ssh/id_rsa apps/nvim/openai.age
```


