{ config, lib, pkgs, ... }:{
 	home-manager.users.vamshi.services.status-notifier-watcher ={
      enable = true;
    };
}
