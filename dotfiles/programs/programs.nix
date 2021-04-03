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
            # taffybar
            # xfce.xfce4-vala-panel-appmenu-plugin
            pavucontrol
            rofi
            tint2
            # pantheon.elementary-dock
            glib
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
            # binutils-unwrapped
            # pkg-config
            # gobjectIntrospection
        # lambda-launcher
		plank
    redshift-plasma-applet
    # latte-dock
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
    # ]
    # ++ lib.optionals config.deviceSpecific.goodMachine [
    ];
}
