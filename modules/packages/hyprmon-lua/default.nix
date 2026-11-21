# hyprmon with a patch to make it work with lua dispatchers
{
  perSystem =
    { pkgs, lib, ... }:
    {
      # linux only
      packages = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        hyprmon-lua = pkgs.hyprmon.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [ ./lua-dispatch.patch ];
        });
      };
    };
}
