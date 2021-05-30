{ pkgs, config, lib, inputs, ... }:{
   home-manager.users.vamshi.programs.obs-studio = {
  			enable = true;
   };
   # xdg.configFile."fish/functions/fish_prompt.fish".text = customPlugins.prompt;
}
