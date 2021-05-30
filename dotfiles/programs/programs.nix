{ pkgs, config, lib, inputs, ... }: {
home-manager.users.vamshi.home.packages = with pkgs;
  [
          # media player
          vlc
          #screenshot
          scrot
          tmux
          #file manager 
          pcmanfm
          udiskie
          #image editor
          gimp
          #browser
          brave
            # taffybar
            # xfce.xfce4-vala-panel-appmenu-plugin
            # sound
            pavucontrol
          #tui utilities
            pipes
            cmatrix
          tree
            fzf
          rofi
          #rust
          exa
          bat
          peco
          ghq
          kronometer
          rsclock
          ripgrep
          tokei
            fd
            procs
            # ytop
            tealdeer
            bandwhich
            grex
            zoxide
            # nushell
            # pantheon.elementary-dock
            glib
            clipmenu
            # windows alternatives
            wine
            winetricks
            unrar
            libreoffice
            #appearence
            papirus-icon-theme
            materia-theme
            numix-solarized-gtk-theme
            mojave-gtk-theme
		        qogir-icon-theme
            #unknown
            xorg.xwininfo
            xorg.xev
            pipewire

            # wallpaper setter
            xwallpaper
            nitrogen
            #image editor
            gthumb
            # binutils-unwrapped
            # pkg-config
            # gobjectIntrospection
        # lambda-launcher
		# plank
    
    # compiler design
            # c
            bison
            flex
            killall
            # bootable disk
            unetbootin
                nwipe
            # gui utilities
            gparted
          # pressed keys on screen
          screenkey
          xclip
          #transmission
          transmission
              # kaggle  
            # ((emacsPackagesNgGen emacs).emacsWithPackages (epkgs: [
            #   # epkgs.vterm
		        #   # epkgs.evil
		        #   # epkgs.nord-theme
            #   epkgs.ccls
            #   epkgs.lsp-haskell
            # ]))
    ];
}
