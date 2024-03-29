{ pkgs, config, lib, inputs, ... }:{
  #redshift
  /*location = {
                       latitude = 17.492829;
                       longitude = 78.281284;
  };*/
  home-manager.users.vamshi.services.redshift = {

    enable = true;
		latitude = "17.492829";
		longitude = "78.281284";
		extraOptions = ["-g" "0.8:0.8:0.8" ];
    tray = true;
		temperature = {
		  day = 3400;
			night = 3400;
		};
		brightness  = {
      day = "0.52";
			# night = "0.74";
			night = "0.34";
    };
  };
}
