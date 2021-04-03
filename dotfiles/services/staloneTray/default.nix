{ config, inputs, lib, pkgs, ... }:
{
home-manager.users.vamshi.services.stalonetray = {
     enable = true;
     extraConfig = ''
geometry 2x1-600+0
decorations none
icon_size 20
sticky true
background "#cccccc"
'';
  };
}
