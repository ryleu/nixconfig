# the amd bc-250. boots into steam but can switch to hyprland
{
  hosts.temple = {
    stateVersion = "26.11";

    parts = {
      base = { };
      desktop = { };
      gaming = { };

      session.kind = "game";
      network = {
        stack = "networkmanager";
        wifi = "iwd";
      };
      # does not support TPM and won't always have a keyboard attached
      disk.encrypted = false;
    };

    users.ryleu.parts = {
      minecraft = { };
    };
  };
}
