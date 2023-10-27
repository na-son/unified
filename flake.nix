{
  outputs = inputs: {
    flakeModule = ./flake-module.nix;

    templates =
      let
        tmplPath = path: builtins.path { inherit path; filter = path: _: baseNameOf path != "test.sh"; };
      in
      rec {
        default = both;
        both = {
          description = "nixos-flake template for both Linux and macOS in same flake";
          path = tmplPath ./systems/both;
        };
        linux = {
          description = "nixos-flake template for NixOS configuration.nix";
          path = tmplPath ./systems/linux;
        };
        macos = {
          description = "nixos-flake template for nix-darwin configuration";
          path = tmplPath ./systems/macos;
        };
        home = {
          description = "nixos-flake template for home-manager configuration";
          path = tmplPath ./systems/home;
        };
      };

    nixci = let overrideInputs = { nixos-flake = ./.; }; in {
      macos = {
        inherit overrideInputs;
        dir = "systems/macos";
      };
      home = {
        inherit overrideInputs;
        dir = "systems/home";
      };
      linux = {
        inherit overrideInputs;
        dir = "systems/linux";
      };
      both = {
        inherit overrideInputs;
        dir = "systems/both";
      };
    };
  };
}
