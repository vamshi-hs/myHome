# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, lib, pkgs, ... }:
with pkgs;
let
  my-python-packages = python-packages: with python-packages; [
    #pandas
    #requests

    # other python packages you want
  ]; 
  python-with-my-packages = python3.withPackages my-python-packages;

in 
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
     # <home-manager/nixos> 
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.hostName = "cosmos"; # Define your hostname.
  networking.wireless = {
               enable = true;  # Enables wireless support via wpa_supplicant.
	       networks.Varikuti.pskRaw = "2f5385967f945b489e113af64fb060b86319cf195898249a8cd0189e63078cbd";
       userControlled.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };
       # bluetooth
   hardware.bluetooth = {
       enable = true;
       powerOnBoot = true;
       extraConfig = ''
                 [General]
                Enable=Source,Sink,Media,Socket
                '';
   };
  fonts.fonts = with pkgs; [
                              pkgs.google-fonts
			      pkgs.powerline-fonts
                              (nerdfonts.override { fonts = [  "VictorMono" "SourceCodePro" "Mononoki" ]; })
			      pkgs.ubuntu_font_family
			      pkgs.emacs-all-the-icons-fonts
  ];


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
                                       Option "HorizScrollDelta" "-180"
                                       Option "FingerLow" "40"          # when finger pressure drops below this value, the driver counts it as a release.
                                       Option "FingerHigh" "70"
                                    '';
		 };
     displayManager = {
		        autoLogin.enable = true;
                        autoLogin.user = "vamshi";
			};
			
/* 
          lightdm = {
            enable = true;
            greeter.enable = false;
                     };
        };
  
     displayManager.lightdm.greeters.enso = {
                                                enable = true;
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
                }; */
     windowManager.xmonad = {
                             enable = true; /*
			     enableContribAndExtras = true;
			     extraPackages =  haskellPackages: [
			                        haskellPackages.xmonad-wallpaper
					 ]; */
			    }; 
  };

  # Enable the GNOME 3 Desktop Environment.
  # services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome3.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
 # services.emacs.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vamshi = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };
      # Security and networking
  security.sudo.wheelNeedsPassword = false;

  #home-manager.users.vamshi = { pkgs, ... }: {
  #  home.packages = [ pkgs.atool pkgs.httpie ];
  #  programs.bash.enable = true;
  #};
  #home-manager.useUserPackages = true;
  #home-manager.useGlobalPkgs = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;
  # Enable UPower, which is used by taffybar.
  #services.upower.enable = true;
  #systemd.services.upower.enable = true;
  sound.enable = true;
  hardware.pulseaudio = {
               enable = true;
               extraModules = [ pkgs.pulseaudio-modules-bt ];
               package = pkgs.pulseaudioFull;
               support32Bit = true; # Steam
               extraConfig = ''
               load-module module-bluetooth-policy auto_switch=2
	       load-module module-switch-on-connect
	       load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
                 '';
  };
# Music daemon, can be accessed through mpc or an other client
   services.mpd = {
         enable = true;
         extraConfig = ''
         audio_output {
         type "pulse" # MPD must use Pulseaudio
         name "Pulseaudio" # Whatever you want
         server "127.0.0.1" # MPD must connect to the local sound server
           }
       '';
    };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget 
    feh
    acpi
    dmenu
    unzip
    neofetch
    kdenlive
    libsForQt5.kdenlive
    libsForQt512.kdenlive
    libsForQt514.kdenlive
    sxiv
    miraclecast
    spotify
    python-with-my-packages 
    wmctrl
    moc
    hicolor-icon-theme
    libnotify
    lxappearance
    dracula-theme
    gcc
    playerctl
    konsole
    pavucontrol
    pulsemixer
    brightnessctl
    htop
    git
    okular
    ((emacsPackagesNgGen emacs).emacsWithPackages (epkgs: [
   # epkgs.vterm
		      epkgs.evil
		      epkgs.nord-theme
  ]))
    neovim
    firefox
    # lang
    #ocaml
    ocaml
    racket
    clojure
    clojure-lsp
    leiningen
    # Haskell
    cabal-install
    cabal2nix
    ghc
    haskellPackages.ghcid
    haskellPackages.ghcide
    haskellPackages.Cabal_3_2_1_0
    haskellPackages.hlint
    haskellPackages.hoogle
    haskellPackages.random_1_2_0
    # JavaScript
   # nodejs
    # Hypertext Preprocessor
    php
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
