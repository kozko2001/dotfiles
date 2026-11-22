{ pkgs, ... }:
let
  # MCP server that lets an LLM drive Blender (https://github.com/ahujasid/mcp-for-blender,
  # formerly `blender-mcp`). Not in nixpkgs, and its `mcp` dependency is newer than the
  # one nixpkgs ships, so it is run through uvx (uv caches the environment).
  # One-time setup: `mcp-for-blender setup` installs the Blender addon and registers
  # the server with Claude Code. The addon must be enabled inside Blender.
  mcp-for-blender = pkgs.writeShellScriptBin "mcp-for-blender" ''
    exec ${pkgs.uv}/bin/uvx mcp-for-blender@2.3.1 "$@"
  '';
in {
  home.packages = [
    pkgs.blender
    mcp-for-blender
  ];
}
