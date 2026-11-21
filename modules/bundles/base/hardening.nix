{
  flake.modules.nixos.base = {
    # copyfail mitigation: make these modules impossible to load
    boot.extraModprobeConfig = ''
      install algif_aead /bin/false
      install esp4 /bin/false
      install esp6 /bin/false
      install rxrpc /bin/false
    '';
  };
}
