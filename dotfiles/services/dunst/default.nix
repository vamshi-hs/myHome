{ pkgs, config, lib, inputs, ... }:{
  home-manager.users.vamshi.services.dunst = {
  	enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome3.adwaita-icon-theme;
      size = "16x16";
    };
		# settings = {
		# 	global = {
		# 		geometry = "600x6-90+50";
		# 		font = "Lucida MAC 20";
		# 		line_height = 12;
		# 	};
		# };
     settings = {
      global = {
        monitor = 0;
        geometry = "600x50-50+65";
        shrink = "yes";
        transparency = 10;
        padding = 16;
        horizontal_padding = 16;
        font = "SauceCodePro Nerd Font 15";
        line_height = 4;
        format = ''<b>%s</b>\n%b'';
      };
    };
  };
}
