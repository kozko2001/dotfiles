# This file must be generated on the target machine by running:
#   nixos-generate-config --show-hardware-config > hardware-configuration.nix
# Then replace this file with the generated output.

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # FIXME: fill in after running nixos-generate-config on the machine
}
