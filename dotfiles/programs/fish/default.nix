{ pkgs, config, lib, inputs, ... }:{
   home-manager.users.vamshi.programs.fish = {
  			enable = true;
			promptInit = "cat /sys/class/power_supply/BAT0/capacity
					### AUTOCOMPLETE AND HIGHLIGHT COLORS ###
					set PATH $PATH /nix/store/nlgwv0h3pqrng56gjfzi4v5bpalwjn2y-system-path/bin
					set fish_color_normal brcyan
					set fish_color_autosuggestion '#7d7d7d'
					set fish_color_command brcyan
					set fish_color_error '#ff6c6b'
					set fish_color_param brcyan ";
			shellInit = "fish_vi_key_bindings
					set fish_greeting";
			shellAliases = {
					conf = "sudo nvim /etc/nixos/configuration.nix";
					homeConf =  "nvim ~/.config/nixpkgs/home.nix";
					up = "sudo nixos-rebuild switch";
					del = "sudo nix-collect-garbage -d";
					server = "php -S localhost:4000";
			};
   };
}
