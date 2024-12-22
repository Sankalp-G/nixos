{
  description = "Odyssey system config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # Unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Nix index database
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # zen browser
    zen-browser.url = "github:heywoodlh/flakes/main?dir=zen-browser";

    # stylix
    stylix.url = "github:danth/stylix/release-24.05";

    # ghostty
    ghostty.url = "git+ssh://git@github.com/ghostty-org/ghostty.git";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nix-index-database,
    zen-browser,
    ghostty,
    stylix,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      odyssey = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };
        modules = [
          stylix.nixosModules.stylix
          ./nixos/configuration.nix
          {
            environment.systemPackages = [
              ghostty.packages.x86_64-linux.default
            ];
          }
        ];
      };
    };

    homeConfigurations = {
      "sankalp@odyssey" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };
        modules = [
          stylix.homeManagerModules.stylix
          ./home-manager/home.nix
          nix-index-database.hmModules.nix-index
        ];
      };
    };
  };
}
