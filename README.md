# chip-host-tools.nix

Standalone flake for Project CHIP host tooling.

## Packages

- `chip-host-tools`: builds `chip-tool` and `chip-cert`
- `zap-cli-bin`: packages prebuilt `zap-cli`
- `default`: alias of `chip-host-tools`

## Usage

Build examples

```sh
nix build .#chip-host-tools
nix build .#zap-cli-bin
nix build .#default
```

Run examples

```sh
nix run github:Sped0n/chip-host-tools.nix#chip-host-tools -- --help
nix run github:Sped0n/chip-host-tools.nix#zap-cli-bin -- --version
```

Shell examples

```sh
nix shell github:Sped0n/chip-host-tools.nix#chip-host-tools
nix shell github:Sped0n/chip-host-tools.nix#zap-cli-bin
```

Flake example

```nix
inputs.chip-host-tools.url = "github:Sped0n/chip-host-tools.nix";

home.packages = [
  inputs.chip-host-tools.packages.${pkgs.system}.chip-host-tools
];
```

## Binary Cache

For `x86_64-linux` and `aarch64-darwin`, you can optionally use this Cachix cache:

```sh
extra-substituters = https://sped0n.cachix.org/nix-cache
extra-trusted-public-keys = sped0n.cachix.org-1:Hc94uahq5qcwbGBZ2+VCq1mGEV/c3AbSsPU+sb2ZI+U=
```

Example with `nix` command-line options:

```sh
nix build github:Sped0n/chip-host-tools.nix#chip-host-tools \
  --option extra-substituters https://nix-cache.sped0n.com/nix-cache \
  --option extra-trusted-public-keys nix-cache.sped0n.com-1:2QjPOhbTs8xHYPpe0tuGIQQ+DFmEZMv05UAfHzU9Crg=
```

This is my personal Nix cache. It may help speed up builds, but it is provided as-is and I am not responsible for its availability, contents, or any issues caused by using it.
