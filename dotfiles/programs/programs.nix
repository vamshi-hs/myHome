{ pkgs, config, lib, inputs, ... }: {
home-manager.users.vamshi.home.packages = with pkgs;
    [ 	    vlc
  	      obs-studio
          scrot
          tree
          pcmanfm
          udiskie
          gimp
          vscode
          tmux
          brave
          exa
          bat
            # tint2
            unrar
            libreoffice
            papirus-icon-theme
            materia-theme
            numix-solarized-gtk-theme
            mojave-gtk-theme
            wpa_supplicant_gui
            xmenu
            xorg.xwininfo
            xorg.xev
		qogir-icon-theme
		# plank
            tcsh
            pipes
            cmatrix
            # ((emacsPackagesNgGen emacs).emacsWithPackages (epkgs: [
            #   # epkgs.vterm
		        #   # epkgs.evil
		        #   # epkgs.nord-theme
            #   epkgs.ccls
            #   epkgs.lsp-haskell
            # ]))
    ];
}
