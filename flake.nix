{
  description = "CHIP host tools and ZAP CLI";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
  };

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      ccacheOverlay = final: prev: {
        ccacheWrapper = prev.ccacheWrapper.override {
          extraConfig = ''
            export CCACHE_COMPRESS=1
            export CCACHE_SLOPPINESS=random_seed

            if [ -d /nix/var/cache/ccache ] && [ -w /nix/var/cache/ccache ]; then
              export CCACHE_DIR=/nix/var/cache/ccache
              export CCACHE_UMASK=007
            else
              export CCACHE_DISABLE=1
            fi
          '';
        };
      };
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ ccacheOverlay ];
          };
          zapCliBin = pkgs.callPackage ./packages/zap-cli-bin.nix { };
          chipHostTools_1_5_0_1 = pkgs.callPackage ./packages/chip-host-tools/1.5.0.1.nix {
            inherit zapCliBin;
          };
          chipHostTools_1_5_1_0 = pkgs.callPackage ./packages/chip-host-tools/1.5.1.0.nix {
            inherit zapCliBin;
          };
        in
        {
          zap-cli-bin = zapCliBin;
          chip-host-tools_1_5_0_1 = chipHostTools_1_5_0_1;
          chip-host-tools_1_5_1_0 = chipHostTools_1_5_1_0;
          chip-host-tools = chipHostTools_1_5_1_0;
          default = chipHostTools_1_5_1_0;
        }
      );
    };
}
