{ pkgs, config, lib, inputs, ... }: {
home-manager.users.vamshi.home.packages = with pkgs;
    [ 	    vlc
  	      obs-studio
          scrot
          tree
            pcmanfm
            udiskie
          tmux
          brave
          exa
          bat
          libreoffice
          wpa_supplicant_gui
    ];
}
