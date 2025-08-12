{
  pkgs,
  ...
}:
{
  imports = [
    ./ryleu
  ];

  users = {
    defaultUserShell = pkgs.bash;
  };

  programs = {
    zsh.enable = true;
  };
}
