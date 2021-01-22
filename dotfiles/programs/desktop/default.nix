{ pkgs, config, lib, inputs, ... }:{
    home-manager.users.vamshi.xsession.windowManager.xmonad = {
                                    enable = true;
				    enableContribAndExtras = true;
				    extraPackages = haskellPackages: [
				    			haskellPackages.xmonad-spotify
				    ];
				    config = ./xmonad/xmonad.hs;
			};


}
