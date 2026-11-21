# allow emulating aarch64-linux
{
  flake.modules.nixos.dev = {
    boot.binfmt = {
      emulatedSystems = [ "aarch64-linux" ];
      preferStaticEmulators = true;
    };
  };
}
