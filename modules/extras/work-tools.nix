{
  flake.modules.homeManager.work-tools =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # utilities
        dbeaver-bin

        # cli
        google-cloud-sdk # provides gcloud cli
        glab
        claude-code
        liteparse
        nodejs_latest
        biome # nodejs toolchain
        libnotify
      ];
    };
}
