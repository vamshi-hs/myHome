{ pkgs, config, lib, inputs, ... }:{
  home-manager.users.vamshi.services.dunst = {
  	enable = true;
		settings = {
			global = {
				geometry = "600x6-90+50";
				font = "Lucida MAC 20";
				line_height = 12;
			};
		};
  };
}
