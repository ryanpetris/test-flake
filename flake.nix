{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.11;
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations."petris-dev" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ ./configuration.nix ];
    };
  };
}
