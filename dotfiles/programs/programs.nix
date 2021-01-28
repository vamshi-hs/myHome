{ pkgs, config, lib, inputs, ... }: {
home-manager.users.vamshi.home.packages = with pkgs;
    [ 	    vlc
    	    obs-studio
	        scrot
            tree
	        pcmanfm
	        tmux
            brave
            exa
            bat
    ];
}
