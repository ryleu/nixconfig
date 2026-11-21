# how home-manager runs inside the system build. the module itself is
# imported by the host builder
{
  flake.modules.nixos.base = {
    home-manager = {
      backupFileExtension = "bak";
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
