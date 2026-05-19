{ inputs, pkgs, ... }:
let
  master_pkgs = import inputs.master_pkgs {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  programs.zed-editor.userSettings.agent_servers.claude-acp = {
    type = "registry";
    env.CLAUDE_CODE_EXECUTABLE = "${master_pkgs.claude-code}/bin/claude";
  };
}
