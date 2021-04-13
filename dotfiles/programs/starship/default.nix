{ pkgs, config, lib, inputs, ... }:{
home-manager.users.vamshi.programs.starship = {
  enable = true;
	enableFishIntegration = true;
	# settings = {
  # add_newline = false;
		# character.symbol = ".";
	# time.disabled = false;
		# battery.disabled = false;
		# golang.format = "via [🏎💨 $version](bold cyan) ";
  # };
};
 }
