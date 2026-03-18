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
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          zapCliBin = pkgs.callPackage ./packages/zap-cli-bin.nix { };
          chipHostTools = pkgs.callPackage ./packages/chip-host-tools.nix {
            inherit zapCliBin;
          };
        in
        {
          zap-cli-bin = zapCliBin;
          chip-host-tools = chipHostTools;
          default = chipHostTools;
        }
      );
    };
}
