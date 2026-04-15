{
  callPackage,
  fetchFromGitHub,
  zapCliBin,
}:
let
  openthreadSrc = fetchFromGitHub {
    owner = "openthread";
    repo = "openthread";
    rev = "2aeb8b833ba760ec29d5f340dd1ce7bcb61c5d56";
    hash = "sha256-3t2P1VVvFxk2qMyjTDJlQNER9PKr+1fkdiYHAZlrucY=";
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
      rev = "d5fcc90b39ee7568855390535fa854cea8f33c95";
      hash = "sha256-LuuXJA4PiEQQTTlOvlfjl/vy38lqVtVcrBpvdq3hBnY=";
    }
    {
      path = "third_party/perfetto/repo";
      url = "https://github.com/google/perfetto.git";
      rev = "b9aca8fb0a7d4130e6ad0b33ca3d14abbc276185";
      hash = "sha256-RcW7m0ejdJt4D77d0bvNsbwb1kU3fvF9fx7wVKyelFA=";
    }
    {
      path = "third_party/libwebsockets/repo";
      url = "https://github.com/warmcat/libwebsockets";
      rev = "c57c239368deb998420e663160a1ab2ffd5d7934";
      hash = "sha256-5gS8zUhMN+udXLaicoOBAjnyur/8JYrzJuYHBGnB5JE=";
    }
    {
      path = "third_party/editline/repo";
      url = "https://github.com/troglobit/editline.git";
      rev = "425584840c09f83bb8fedbf76b599d3a917621ba";
      hash = "sha256-Njz5ej31PTYVj7WtuAhioa2WS6MxyAK8ro5dRjKYDA4=";
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
      rev = "69098a18b9af0c47549d9a271c054d13ca92b006";
      hash = "sha256-BYiy9+UHvqSNR4saQyRTcjRBquuJbG8FnIS1IQGc70o=";
    }
  ];
in
(callPackage ../base.nix {
  inherit zapCliBin;

  version = "1.4.0.0";

  src = fetchFromGitHub {
    owner = "project-chip";
    repo = "connectedhomeip";
    rev = "v1.4.0.0";
    hash = "sha256-uJyStkwynPCm1B2ZdnDC6IAGlh+BKGfJW7tU4tULHFo=";
  };

  inherit openthreadSrc fetchedSubmoduleSources;
  skippedSubmodulePaths = [ "third_party/lwip/repo" ];
}).overrideAttrs
  (old: {
    postPatch = old.postPatch + ''
      export PYTHONPATH="$PWD/scripts/py_matter_idl:$PWD/scripts/py_matter_yamltests''${PYTHONPATH:+:$PYTHONPATH}"

      patch -p0 < ${./connectedhomeip.patch}

      pigweed_repo="$PWD/third_party/pigweed/repo"
      pigweed_src="$(readlink "$pigweed_repo")"
      rm third_party/pigweed/repo
      cp -a "$pigweed_src" "$pigweed_repo"
      chmod -R u+w "$pigweed_repo"

      patch -p1 -d "$pigweed_repo" < ${./pigweed.patch}
      patch -p0 -d "$pigweed_repo" < ${./pw-rpc.patch}
    '';
  })
