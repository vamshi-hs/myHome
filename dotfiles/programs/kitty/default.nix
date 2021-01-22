{ pkgs, config, lib, inputs, ... }:{
 
  home-manager.users.vamshi.programs.kitty = {
    						enable = true;
                        			settings = {
                                        			font_family        = "Source Code Pro Semibold";
                                        			bold_font          = "auto";
                                        			italic_font        = "auto";
                                        			bold_italic_font   = "auto";
                                        			font_size          = "21.0";
                                        			background_opacity = "0.74";
								include            = "nord.conf";
								#include            = "./Borland.conf";
                        };
  };

}
