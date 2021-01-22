{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "vamshi";
  home.homeDirectory = "/home/vamshi";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
#  programs.kitty = {
#enable = true;
#			settings = {
#					font_family        = "Source Code Pro Semibold";
#					bold_font          = "auto";
#					italic_font        = "auto";
#					bold_italic_font   = "auto";
#					font_size          = "20.0";
#					background_opacity = "0.6";
					#startup_session    = "launch fish";
#					cursor_shape       = "beam";
#			};
#  };
  # programs.fish = {
  # 			enable = true;
	# 		promptInit = "cat /sys/class/power_supply/BAT0/capacity
	# 				### AUTOCOMPLETE AND HIGHLIGHT COLORS ###
	# 				set fish_color_normal brcyan
	# 				set fish_color_autosuggestion '#7d7d7d'
	# 				set fish_color_command brcyan
	# 				set fish_color_error '#ff6c6b'
	# 				set fish_color_param brcyan ";
	# 		shellInit = "fish_vi_key_bindings
	# 				set fish_greeting";
	# 		shellAliases = {
	# 				conf = "sudo nvim /etc/nixos/configuration.nix";
	# 				homeConf =  "nvim ~/.config/nixpkgs/home.nix";
	# 				up = "sudo nixos-rebuild switch";
	# 				del = "sudo nix-collect-garbage -d";
	# 				server = "php -S localhost:4000";
	# 		};
  # };
  # programs.starship = {
  #                       enable = true;
	# 		enableFishIntegration = true;
	# 		settings = {
	# 				character.symbol = "➜ ";
	# 				time.disabled = false;
	# 				battery.disabled = false;
	# 				golang.format = "via [🏎💨 $version](bold cyan) ";
  # 			};
  # };
  programs.go  = { enable = true; };
  services.random-background = {
  					enable = true;
					imageDirectory = "%h/Pictures/wallpapers";
					interval = "15m";
  };
  services.dunst = {
  			enable = true;
			settings = {
					global = {
							geometry = "600x6-90+50";
							font = "Lucida MAC 20";
							line_height = 12;
					};
			};
			/*settings = {
  					global = {
    							#geometry = "600x6-90+50";
    							#transparency = 10;
 							#frame_color = "#eceff1";
    							#font = "Lucida MAC 53";
							#line_height = 10;
							#notification_height = 150;
							#frame_width = 5;
					};

				urgency_normal = {
 							   background = "#37474f";
							   foreground = "#eceff1";
 							   timeout = 10;
  					};
			}; */
  };
  services.cbatticon = {
  			
			enable = true;
			lowLevelPercent = 15; 
			iconType = "notification";
			criticalLevelPercent = 10;
			commandCriticalLevel = ''
						notify-send "battery critical!"
						'';
  };
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";
}
