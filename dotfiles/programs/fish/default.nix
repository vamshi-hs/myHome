{ pkgs, config, lib, inputs, ... }:{
   home-manager.users.vamshi.programs.fish = {
  			enable = true;
      promptInit = "
					### AUTOCOMPLETE AND HIGHLIGHT COLORS ###
					set PATH $PATH /nix/store/nlgwv0h3pqrng56gjfzi4v5bpalwjn2y-system-path/bin
					set fish_color_normal brcyan
					set fish_color_autosuggestion '#7d7d7d'
					set fish_color_command brcyan
					set fish_color_error '#ff6c6b'
					set fish_color_param brcyan ";
			shellInit = "fish_vi_key_bindings
          zoxide init fish | source
					set fish_greeting";
			shellAliases = {
					conf = "sudo nvim /etc/nixos/configuration.nix";
					homeConf =  "nvim ~/.config/nixpkgs/home.nix";
					up = "sudo nixos-rebuild switch && notify-send -u low \"Successfully updated\" ";
					del = "sudo nix-collect-garbage -d";
					server = "php -S localhost:4000";
          bright = "systemctl --user stop redshift.service";
          dark = "systemctl --user restart redshift.service";
          wifi = "systemctl start wpa_supplicant.service";
          c = "clear";
          e = "exit";
          ls = "exa";
          ll = "exa -l -g --icons";
			};
   };
   # xdg.configFile."fish/functions/fish_prompt.fish".text = customPlugins.prompt;
}
