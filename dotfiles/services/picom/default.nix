{pkgs, config, lib, inputs, ...}:{
	home-manager.users.vamshi.services.picom = {
	enable = true;
    # activeOpacity = "1.0";
    # inactiveOpacity = "0.8";
    # backend = "glx";
    # fade = true;
    # fadeDelta = 5;
    # # opacityRule = [ "100:name *= 'i3lock'" ];
    # shadow = true;
    # shadowOpacity = "0.75";
    # shadowExclude = [
    #       # "bounding_shaped && !rounded_corners"
    #       "class_g = 'firefox' && argb"
    #     ];
    # extraOptions = ''"class_g = 'firefox' && argb"'';
    # activeOpacity = "1.0";
    # inactiveOpacity = "0.8";
    # backend = "glx";
    # blur = true;
    # fade = true;
    # fadeDelta = 5;
    # # opacityRule = [ "100:name *= 'i3lock'" ];
    # shadow = true;
    # shadowOpacity = "0.75";
    # package = pkgs.picom.overrideAttrs(o: {
    #       src = pkgs.fetchFromGitHub {
    #         repo = "picom";
    #         owner = "ibhagwan";
    #         rev = "44b4970f70d6b23759a61a2b94d9bfb4351b41b1";
    #         sha256 = "0iff4bwpc00xbjad0m000midslgx12aihs33mdvfckr75r114ylh";
    #       };
    #  });
    #  opacityRule = [
    #       "100:class_g   *?= 'Chromium-browser'"
    #       "100:class_g   *?= 'Firefox'"
    #       "100:class_g   *?= 'gitkraken'"
    #       "100:class_g   *?= 'emacs'"
    #       "100:class_g   ~=  'jetbrains'"
    #       "100:class_g   *?= 'slack'"
    #     ];
    #  vSync = true;
    # # corner-radius = 16;
    # extraOptions = ''
    #       corner-radius = 16;
    #       round-borders = 16;
    #       blur-method = "dual_kawase";
    #       blur-strength = "10";
    #       xinerama-shadow-crop = true;
    #     '';
    # experimentalBackends = true;

    # shadowExclude = [
    #       "bounding_shaped && !rounded_corners"
    #     ];
    };
}
