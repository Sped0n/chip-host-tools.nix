# chip-host-tools

Standalone flake for Project CHIP host tooling.

Packages
- `chip-host-tools`: builds `chip-tool` and `chip-cert`
- `zap-cli-bin`: packages prebuilt `zap-cli`
- `default`: alias of `chip-host-tools`

Build examples

```sh
nix build .#chip-host-tools
nix build .#zap-cli-bin
nix build .#default
```

Run examples

```sh
./result/bin/chip-tool --help
./result/bin/chip-cert help
./result/bin/zap-cli --version
```

Remote flake usage

```nix
inputs.chip-host-tools.url = "github:Sped0n/chip-host-tools";

home.packages = [
  inputs.chip-host-tools.packages.${pkgs.system}.chip-host-tools
];
```
