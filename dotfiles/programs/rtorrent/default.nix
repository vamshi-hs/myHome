{ pkgs, config, lib, inputs, ... }:{
 
  home-manager.users.vamshi.programs.rtorrent = {
  							enable = true;
							settings = "
									directory.default.set = ~/movies
									session.path.set      = ~/session 
									schedule2 = watch_directory,5,5,load.start=~/movies/*.torrent
									dht.mode.set = on
									dht.port.set = 6881

							";
						};
}



