{ pkgs, config, lib, ... }: {
  home-manager.users.vamshi = {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs; 
      extraPackages = epkgs:
        with epkgs; [
	         vterm
	/*        hydra
	        ace-window
	        general
	        which-key
	        evil
          
	        # ivy
	        ivy
	        ivy-rich
	        all-the-icons-ivy-rich
	        all-the-icons-ivy
	        # counsel
	        counsel
	        counsel-projectile
	        swiper
	        # projectile
	        projectile
	        # dashboard
	        dashboard
	        multiple-cursors
	        evil-collection
          use-package
	        minions
	        moody
	        magit
	        dash
          #misc
	        no-littering
	        # treemacs
	        #  treemacs
	        # treemacs-all-the-icons
	        # treemacs-icons-dired
	        # ui
	        highlight-numbers
	        pos-tip
	        all-the-icons-dired
	        all-the-icons
	        solaire-mode
	        doom-modeline
          rainbow-delimiters
	        paredit
	        #spaceline
	        #pspaceline-all-the-icons
	        telephone-line
	        #powerline
	        #pewal-doom-themes
	        #pewal
	        #pspaceline
	        #pewal-spacemacs-themes
	        doom-themes
	        darktooth-theme
	        nord-theme
	        kaolin-themes
	        solarized-theme
          
          vscode-dark-plus-theme
          color-theme-sanityinc-tomorrow
          color-theme-sanityinc-solarized
          spacemacs-theme
          # spacegray-theme
	        smart-mode-line-atom-one-dark-theme
	        smart-mode-line
	        #edwina
	        
	        # eshell
	        eshell-up
	        eshell-z
	        esh-help
	        shrink-path
	        eshell-did-you-mean
	        fish-completion
	        
	        #vterm
	        vterm
	        vterm-toggle
	        
	        #bufler
	        bufler

	        #treemacs
	        # treemacs
	        # treemacs-all-the-icons
          
	        # lang
	        # web-development
	        php-mode
	        web-mode
	        # racket
	        racket-mode
          # clojure
          cider
          clojure-mode
          flycheck-clojure
	        # haskell
	        haskell-mode
	        nix-haskell-mode
          ac-haskell-process
          company-ghc
          # auto-complete
          auto-complete
          # eglot
          eglot
          # yasnippet
          yasnippet
	        ## flycheck
	        flycheck
	        ## lsp	
	        lsp-mode
	        lsp-ui
	        lsp-haskell
	        lsp-treemacs
	        lsp-ivy
          
	        ## company
	        company
	        # company-ghci
          
	        #comments
	        evil-nerd-commenter

	        #misc
	        smart-cursor-color
	        nix-mode
          haskell-mode
          wakib-keys
          exec-path-from-shell
          counsel
          projectile
          which-key
          markdown-mode
          frames-only-mode
          company
          rainbow-delimiters
          diff-hl
          mode-line-bell
          hasklig-mode
          flycheck
          flycheck-pkg-config
          auto-indent-mode
          clipmon
          org-gcal
          company-ghci
          xresources-theme
          company-tabnine
          expand-region
          ivy
          smex
          quickrun
          counsel-tramp
          ix
          magit
          xah-fly-keys
          arduino-mode
          elixir-mode
          company-box
          ws-butler
          yaml-mode
          gitlab-ci-mode
          gitlab-ci-mode-flycheck
          gitlab
          undo-tree
          rust-mode
          go-mode
          edit-indirect */
        ];
    };

    home.packages = [
      (pkgs.makeDesktopItem {
        terminal = "false";
        type = "Application";
        name = "emacsclient";
        genericName = "Text editor";
        desktopName = "Emacs client";
        mimeType = "text/plain";
        exec = "emacsclient -s /tmp/emacs1000/server -c %F";
        categories = "Development;TextEditor;Utility;";
        icon = "emacs";
      })
      pkgs.clang
    ];

    services.emacs.enable = true;

    systemd.user.services.emacs.Service.Environment =
      "PATH=/run/current-system/sw/bin:/etc/profiles/per-user/vamshi/bin";

    home.file.".emacs.d/init.el".source = ./init.el;
    home.activation.emacs = {
      before = [ ];
      after = [ ];
      data = "$DRY_RUN_CMD mkdir -p ~/.emacs.d/autosave";
    };
  };
}

