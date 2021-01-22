{...}:
{
	services.xserver = 
  	{
     		enable = true;    
     		# Configure keymap in X11
     		layout = "us";
     		xkbOptions = "eurosign:e";
     		libinput= {
                	 enable = true;
                 	naturalScrolling = true;      # Enable touchpad support (enabled default in most desktopManager).
	
        	          additionalOptions = ''
                	                       Option "AccelSpeed" "1.0"        # Mouse sensivity
                        	               Option "TapButton2" "0"          # Disable two finger tap
                                	       Option "VertScrollDelta" "-180"  # scroll sensitivity
itivity
 	                                      Option "HorizScrollDelta" "-180"
       		                              Option "FingerLow" "40"          # when finger pressure drops below this value, the driver counts it as a release.
                	                      Option "FingerHigh" "70"
                                    '';
                     };
    		 displayManager = {
                	        defaultSession = "none+xmonad";
                       		#lightdm.autologin = {enable = true; user = "vamshi";};
                       		lightdm.greeters.mini = {
                        	enable = true;
                        	user = "vamshi";
                        	extraConfig = ''
                                	[greeter]
                                	show-password-label = false
                                	[greeter-theme]
                                	background-image = ""
                        	        '';
                	        };
        	        };
     		windowManager.xmonad = {
                             enable = true;
                             enableContribAndExtras = true;
			     config  = ./xmonad/xmonad.hs;
                              };
 	 };

}
