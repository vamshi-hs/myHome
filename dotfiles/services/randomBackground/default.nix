{ pkgs, config, lib, inputs, ... }:{
  # home.username = "vamshi";
  # home.homeDirectory = "/home/vamshi";
  home-manager.users.vamshi.services.random-background = {
  	enable = true;
		imageDirectory = "/home/vamshi/Pictures/wallpapers";
		interval = "15m";
  };
}
