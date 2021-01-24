{
  description = "NixOS configuration";

  inputs = {
    	 nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
         nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
         home-manager.url = "github:nix-community/home-manager";
  };
  outputs = {home-manager,nix-doom-emacs,self, nixpkgs}: {
     # replace 'joes-desktop' with your hostname here.
     nixosConfigurations.cosmos = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       modules = [ 
 		   ./dotfiles/services/picom
			   ./dotfiles/services/redshift
			   ./dotfiles/services/cbatticon
			   ./dotfiles/services/dunst
			./dotfiles/services/randomBackground
			# ./dotfiles/services/emacs 
			./dotfiles/programs/programs.nix
			./dotfiles/programs/desktop
			 #./dotfiles/programs/emacs
			./dotfiles/programs/fish
			./dotfiles/programs/starship
			./dotfiles/programs/rtorrent
			./dotfiles/programs/kitty
			./configuration.nix
       home-manager.nixosModules.home-manager
         {
       	    home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.vamshi = { pkgs, ... }: {
              imports = [ nix-doom-emacs.hmModule ];
              programs.doom-emacs = {
                enable = true;
                doomPrivateDir = ./dotfiles/programs/emacs/doom.d;
                emacsPackagesOverlay = self: super: {
                  magit-delta = super.magit-delta.overrideAttrs (esuper: {
                    buildInputs = esuper.buildInputs ++ [ pkgs.git ];
                  });
                };
              };
            };
         } 
		 # 	 home-manager.nixosModules.home-manager
           		 # {
             	 # 		home-manager.useGlobalPkgs = true;
            #   			home-manager.useUserPackages = true;
	 # 		}
      #       			home-manager.users.vamshi = import ./home.nix;
      #     		}
		];
	     };
  	};
}
