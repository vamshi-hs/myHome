{ pkgs, config, lib, inputs, ... }:{
  home-manager.users.vamshi.services.cbatticon = {
		enable = true;
		lowLevelPercent = 15; 
		iconType = "notification";
		criticalLevelPercent = 10;
		commandCriticalLevel = ''
					               	notify-send "battery critical!"
						'';           
  };
}
