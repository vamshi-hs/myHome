{ pkgs, config, lib, inputs, ... }:{
 
  home-manager.users.vamshi.programs.kitty = {
    						enable = true;
                        			settings = {
                                        			# font_family        = "Source Code Pro Semibold";
                                        			font_family        = "mononoki Nerd Font mono";
                                        			bold_font          = "auto";
                                        			italic_font        = "auto";
                                        			bold_italic_font   = "auto";
                                        			font_size          = "22.0";
                                        			background_opacity = "1.0";
								                              include            = "kitty-themes/themes/Dracula.conf";
								#include            = "./Borland.conf";
                        };
  };

}
