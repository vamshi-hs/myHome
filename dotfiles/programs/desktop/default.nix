{ pkgs, config, lib, inputs, ... }:{
    home-manager.users.vamshi.xsession.windowManager.xmonad = {
                                    enable = true;
				    enableContribAndExtras = true;
				    # extraPackages = haskellPackages: [
				    			# haskellPackages.regex-compat
                                          # haskellPackages.dbus-client
                                  # haskellPackages.dbus
                                  # haskellPackages.monad-logger
				    # ];
				    config = ./xmonad/xmonad.hs;
			};
}
