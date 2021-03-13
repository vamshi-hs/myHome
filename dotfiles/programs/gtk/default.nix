{ pkgs, config, lib, inputs, ... }:{
home-manager.users.vamshi.gtk = {
  enable = true;
  iconTheme = {
    name = "Adwaita-dark";
    package = pkgs.gnome3.adwaita-icon-theme;
  };
  theme = {
    name = "Adwaita-dark";
    package = pkgs.gnome3.adwaita-icon-theme;
  };
};
}
