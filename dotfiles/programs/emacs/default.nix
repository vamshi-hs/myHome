{ pkgs, config, lib, ... }: {
 home-manager.users.vamshi.programs.emacs = {
  enable = true;
  package = pkgs.emacs; 
      extraPackages = epkgs:
        with epkgs; [
                      evil
		      nord-theme
		       ]; 
    };
}
