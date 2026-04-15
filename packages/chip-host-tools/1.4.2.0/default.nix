{
  callPackage,
  fetchFromGitHub,
  zapCliBin,
}:
(callPackage ../base.nix {
  inherit zapCliBin;

  version = "1.4.2.0";

  src = fetchFromGitHub {
    owner = "project-chip";
    repo = "connectedhomeip";
    rev = "v1.4.2.0";
    hash = "sha256-ojyZY2tPDLOqWisuTnuopDvatz9kdcA+um/mZs6lzGI=";
  };

  openthreadSrc = fetchFromGitHub {
    owner = "openthread";
    repo = "openthread";
    rev = "de0739239bb5fc21b3f4e85c6222971062ed591b";
    hash = "sha256-todOf/p7o4xjUdB6SnQuwrMkHOk+EypPdAVYPJocetI=";
  };

  fetchedSubmoduleSources = [
    {
      path = "third_party/nlassert/repo";
      url = "https://github.com/nestlabs/nlassert.git";
      rev = "c5892c5ae43830f939ed660ff8ac5f1b91d336d3";
      hash = "sha256-CT15ld/VuyBHz3du+npBnmBDHuFM11fFjusDgvTAS3k=";
    }
    {
      path = "third_party/nlio/repo";
      url = "https://github.com/nestlabs/nlio.git";
      rev = "0e725502c2b17bb0a0c22ddd4bcaee9090c8fb5c";
      hash = "sha256-LGvIhFB5iLYPDrj4J2hYBZ7Erxxq7mi7dg/8VrKDo1E=";
    }
    {
      path = "third_party/pigweed/repo";
      url = "https://github.com/google/pigweed.git";
      rev = "3fe6ddbf82e623b47f23fa5db4d0ab2d5c683cca";
      hash = "sha256-Dv54TkDs4+Oy9TB51Flidlp+6IsiUWkyz7ZfoCPnFpk=";
    }
    {
      path = "third_party/perfetto/repo";
      url = "https://github.com/google/perfetto.git";
      rev = "b9aca8fb0a7d4130e6ad0b33ca3d14abbc276185";
      hash = "sha256-RcW7m0ejdJt4D77d0bvNsbwb1kU3fvF9fx7wVKyelFA=";
    }
    {
      path = "third_party/lwip/repo";
      url = "https://github.com/lwip-tcpip/lwip.git";
      rev = "56b29f8bcfaefe2974dca67bde16cc7c391feaeb";
      hash = "sha256-t3wFSYhORlv8hiY+L9HgR5PxwXq15OvvY2WkKjDxIBg=";
    }
    {
      path = "third_party/libwebsockets/repo";
      url = "https://github.com/warmcat/libwebsockets";
      rev = "75849aa83b883eb84022919532ddb5f049b10258";
      hash = "sha256-PNfDRCLvb+xxF+Y5GMvCJKpZfdOcjDtaH1WrMs9s4cQ=";
    }
    {
      path = "third_party/editline/repo";
      url = "https://github.com/troglobit/editline.git";
      rev = "f735e4d1d566cac3caa4a5e248179d07f0babefd";
      hash = "sha256-MUXxSmhpQd8CZdGGC6Ln9eci85E+GBhlNk28VHUvjaU=";
    }
    {
      path = "third_party/nanopb/repo";
      url = "https://github.com/nanopb/nanopb.git";
      rev = "671672b4d7994a9b07a307ae654885c7202ae886";
      hash = "sha256-o0xbxAFj86EvnldHk7ao8ltBBzxm4TgkChvNVME6n78=";
    }
    {
      path = "third_party/jsoncpp/repo";
      url = "https://github.com/open-source-parsers/jsoncpp.git";
      rev = "ca98c98457b1163cca1f7d8db62827c115fec6d1";
      hash = "sha256-RX9ZV6zEn3RDN/n6FE4iJJ+MR1LB5vKbsQ/XmpqYbB0=";
    }
  ];
}).overrideAttrs
  (old: {
    postPatch = old.postPatch + ''
      export PYTHONPATH="$PWD/scripts/py_matter_idl:$PWD/scripts/py_matter_yamltests''${PYTHONPATH:+:$PYTHONPATH}"

      pigweed_repo="$PWD/third_party/pigweed/repo"
      pigweed_src="$(readlink "$pigweed_repo")"
      rm third_party/pigweed/repo
      cp -a "$pigweed_src" "$pigweed_repo"
      chmod -R u+w "$pigweed_repo"

      patch -p1 -d "$pigweed_repo" < ${./pigweed.patch}
    '';

  })
