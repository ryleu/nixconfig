{
  flake.modules.nixos.base.programs.ssh.startAgent = true;

  flake.modules.homeManager.gui.programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig = ''
      PreferredAuthentications publickey,password
      IdentitiesOnly true
      IdentityFile ~/.ssh/id_ed25519
    '';
    settings."*" = {
      AddKeysToAgent = "yes";
      ForwardAgent = true;
      Compression = true;
    };
  };
}
