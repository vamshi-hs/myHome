;;; $$$$$DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "vamshi krishna"
      user-mail-address "vamshi5070k@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 20 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 21))

;; (setq sml/no-confirm-load-theme t)
;; ;; (setq sml/theme 'atom-one-dark)
;; ;; (setq sml/theme 'respectful)
;; (sml/setup)

(display-time-mode 1)
(display-battery-mode 1)
;; (setq cycle-themes-theme-list
      ;; '(leuven monokai solarized-dark))

;; (require 'cycle-themes)
;; (cycle-themes-mode)
;; (setq cycle-themes-theme-list
      ;; '(leuven monokai solarized-dark) )
;; (cycle-themes-mode)

;; (use-package cycle-themes
  ;; :ensure t
;;   :init (setq cycle-themes-theme-list
;;               '(doom-one doom-solarized-dark doom-horizon doom-wilmersdorf))
  ;; :config (cycle-themes-mode))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (require 'spaceline-config)
;; (spaceline-emacs-theme)
(setq doom-theme 'doom-dracula)
;; (telephone-line-mode 1)
;; (require 'modeline-common)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (spaceline-compile
;;   ; left side
;;   '(((persp-name
;;       workspace-number
;;       window-number)
;;      :fallback evil-state
;;      :face highlight-face
;;      :priority 100)
;;     (anzu :priority 95)
;;     auto-compile
;;     ((buffer-modified buffer-size buffer-id remote-host)
;;      :priority 98)
;;     (major-mode :priority 79)
;;     (process :when active)
;;     ((flycheck-error flycheck-warning flycheck-info)
;;      :when active
;;      :priority 89)
;;     (minor-modes :when active
;;                  :priority 9)
;;     (mu4e-alert-segment :when active)
;;     (erc-track :when active)
;;     (version-control :when active
;;                      :priority 78)
;;     (org-pomodoro :when active)
;;     (org-clock :when active)
;;     nyan-cat)
;;   ; right side
;;   '(which-function
;;     (python-pyvenv :fallback python-pyenv)
;;     (purpose :priority 94)
;;     (battery :when active)
;;     (selection-info :priority 95)
;;     input-method
;;     ((buffer-encoding-abbrev
;;       point-position
;;       line-column)
;;      :separator " | "
;;      :priority 96)
;;     (global :when active)
;;     (buffer-position :priority 99)
;;     (hud :priority 99)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq-default mode-line-format nil)
;; (use-package kaolin-themes
;; :config
;; (load-theme 'kaolin-ocean t)
;; (kaolin-treemacs-theme))
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
;; (set-face-attribute 'mode-line nil
;;                    :background "black" ; "#353644"
;;                    :foreground "black"
;;                    :box '(:line-width 4 :color "black")
;;                    :overline nil
;;                    :underline nil)
		   ;; :family "Source Code Pro " :height 180)
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'nil)
;; (setq doom-dark+-padded)
;; (setq doom-dark+-blue-modeline t)
;; (setq doom-font (font-spec :family "Courier Prime" :size 22)
      ;; doom-variable-pitch-font (font-spec :family "Source Code Pro Semibold" :size 22))
;; doom-big-font (font-spec :family "inputmono" :size 35  :weight 'regular))
;;
;; (set-face-attribute 'default nil :font "Source Code Pro Semibold" :height 280)

;; (use-package ewal
;;   :init (setq ewal-use-built-in-always-p nil
;;               ewal-use-built-in-on-failure-p t
;;               ewal-built-in-palette "sexy-material"))
;; (use-package ewal-spacemacs-themes
;;   :init (progn
;;           (setq spacemacs-theme-underline-parens t
;;                 my:rice:font (font-spec
;;                               :family "Source Code Pro"
;;                               :weight 'semi-bold
;;                               :size 11.0))
;;           (show-paren-mode +1)
;;           (global-hl-line-mode)
;;           (set-frame-font my:rice:font nil t)
;;           (add-to-list  'default-frame-alist
;;                         `(font . ,(font-xlfd-name my:rice:font))))
;;   :config (progn
;;             (load-theme 'ewal-spacemacs-modern t)
;;             (enable-theme 'ewal-spacemacs-modern)))
;; (use-package ewal-evil-cursors
;;   :after (ewal-spacemacs-themes)
;;   :config (ewal-evil-cursors-get-colors
;;            :apply t :spaceline t))
;; (use-package spaceline
;;   :after (ewal-evil-cursors winum)
;;   :init (setq powerline-default-separator nil)
;;   :config (spaceline-spacemacs-theme))
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; skp;
;; (setq doom-font (font-spec :family "Hack" :size 32 )
;;       doom-variable-pitch-font (font-spec :family "Ubuntu" :size 30))
;; (setq doom-modeline-minor-modes t)
;; (minions-mode 1)
;; (setq doom-modeline-height 1)
;; (set-face-attribute 'mode-line nil :height 100)
;; (set-face-attribute 'mode-line-inactive nil :height 100)
;; (setq doom-modeline-icon nil)
(setq doom-modeline-height 1)
(set-face-attribute 'mode-line nil :height 10)
(set-face-attribute 'mode-line-inactive nil :height 10)
;; (setq  doom-modeline-buffer-file-name-style 'truncate-except-project)
;; (setq doom-font (font-spec :family "SauceCodePro Nerd Font Mono" :size 20)
;; doom-variable-pitch-font (font-spec :family "Ubuntu" :size 20)
;; doom-big-font (font-spec :family "SauceCodePro Nerd Font Mono" :size 24))
;; (setq doom-font (font-spec :family "Source Code Pro Semibold" :size 24)
;;       doom-variable-pitch-font (font-spec :family "Ubuntu" :size 22)
;;       doom-big-font (font-spec :family "Source Code Pro Semibold" :size 30))

(setq doom-font (font-spec :family "mononoki Nerd Font Mono" :size 24)
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 22)
      doom-big-font (font-spec :family "mononoki Nerd Font Mono" :size 30))

(setq treemacs-width 25)

(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

;; (setq doom-modeline-height 1)
(set-face-attribute 'mode-line nil :family "Source Code Pro Semibold" :height 230)
(set-face-attribute 'mode-line-inactive nil :family "Source Code Pro Semibold" :height 230)
;; eshell-aliases
(set-eshell-alias! "up" "sudo nixos-rebuild switch")
(set-eshell-alias! "del"  "sudo nix-collect-garbage -d")
;(use-package nix-haskell-mode
;  :hook (haskell-mode . nix-haskell-mode))
;; KEYBINDINGS
(map! :leader
      :desc "aSave"
      "a" #'save-buffer)

(map! :leader
      :desc "zComment"
      "z" #'evilnc-comment-or-uncomment-lines)

(map! :leader
      (:prefix ("d" . "custom")
       :desc "run-Haskell" "r" #'run-haskell
       :desc "run-Python" "p" #'run-python
       :desc "themes" "t" #'cycle-themes
       :desc "fold"  "f" #'+fold/toggle))

(map! "M-w"
      #'other-window)

(map! :map evil-window-map
      "SPC" #'rotate-layout
      ;; Navigation
      "<left>"     #'evil-window-left
      "<down>"     #'evil-window-down
      "<up>"       #'evil-window-up
      "<right>"    #'evil-window-right
      ;; Swapping windows
      "C-<left>"       #'+evil/window-move-left
      "C-<down>"       #'+evil/window-move-down
      "C-<up>"         #'+evil/window-move-up
      "C-<right>"      #'+evil/window-move-right)

(use-package pdf-tools
  :defer t
  :commands (pdf-view-mode pdf-tools-install)
  :mode ("\\.[pP][dD][fF]\\'" . pdf-view-mode)
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install)
  (define-pdf-cache-function pagelabels)
  :hook ((pdf-view-mode-hook . (lambda () (display-line-numbers-mode -1)))
         (pdf-view-mode-hook . pdf-tools-enable-minor-modes)))

(use-package org-pdftools
  :defer t
  :hook (org-load-hook . org-pdftools-setup-link))

(setq pdf-view-midnight-minor-mode t)

(use-package nov
  :defer t
  :commands nov-mode
  :config
  (evil-set-initial-state 'nov-mode 'emacs)
  :mode ("\\.epub\\'" . nov-mode))


(setq  haskell-interactive-popup-errors nil)
;; (setq dante-repl-command-line  '("cabal" "v2-repl"))
;; (require 'nix-haskell-mode)
;; (add-hook 'haskell-mode-hook 'nix-haskell-mode)
;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


(defvar fancy-splash-image-template
  (expand-file-name "misc/splash-images/blackhole-lines-template.svg" doom-private-dir)
  "Default template svg used for the splash image, with substitutions from ")
(defvar fancy-splash-image-nil
  (expand-file-name "misc/splash-images/transparent-pixel.png" doom-private-dir)
  "An image to use at minimum size, usually a transparent pixel")

(setq fancy-splash-sizes
      `((:height 500 :min-height 50 :padding (0 . 4) :template ,(expand-file-name "misc/splash-images/blackhole-lines-0.svg" doom-private-dir))
        (:height 440 :min-height 42 :padding (1 . 4) :template ,(expand-file-name "misc/splash-images/blackhole-lines-0.svg" doom-private-dir))
        (:height 400 :min-height 38 :padding (1 . 4) :template ,(expand-file-name "misc/splash-images/blackhole-lines-1.svg" doom-private-dir))
        (:height 350 :min-height 36 :padding (1 . 3) :template ,(expand-file-name "misc/splash-images/blackhole-lines-2.svg" doom-private-dir))
        (:height 300 :min-height 34 :padding (1 . 3) :template ,(expand-file-name "misc/splash-images/blackhole-lines-3.svg" doom-private-dir))
        (:height 250 :min-height 32 :padding (1 . 2) :template ,(expand-file-name "misc/splash-images/blackhole-lines-4.svg" doom-private-dir))
        (:height 200 :min-height 30 :padding (1 . 2) :template ,(expand-file-name "misc/splash-images/blackhole-lines-5.svg" doom-private-dir))
        (:height 100 :min-height 24 :padding (1 . 2) :template ,(expand-file-name "misc/splash-images/emacs-e-template.svg" doom-private-dir))
        (:height 0   :min-height 0  :padding (0 . 0) :file ,fancy-splash-image-nil)))

(defvar fancy-splash-sizes
  `((:height 500 :min-height 50 :padding (0 . 2))
    (:height 440 :min-height 42 :padding (1 . 4))
    (:height 330 :min-height 35 :padding (1 . 3))
    (:height 200 :min-height 30 :padding (1 . 2))
    (:height 0   :min-height 0  :padding (0 . 0) :file ,fancy-splash-image-nil))
  "list of plists with the following properties
  :height the height of the image
  :min-height minimum `frame-height' for image
  :padding `+doom-dashboard-banner-padding' to apply
  :template non-default template file
  :file file to use instead of template")

(defvar fancy-splash-template-colours
  '(("$colour1" . keywords) ("$colour2" . type) ("$colour3" . base5) ("$colour4" . base8))
  "list of colour-replacement alists of the form (\"$placeholder\" . 'theme-colour) which applied the template")

(unless (file-exists-p (expand-file-name "theme-splashes" doom-cache-dir))
  (make-directory (expand-file-name "theme-splashes" doom-cache-dir) t))

(defun fancy-splash-filename (theme-name height)
  (expand-file-name (concat (file-name-as-directory "theme-splashes")
                            theme-name
                            "-" (number-to-string height) ".svg")
                    doom-cache-dir))

(defun fancy-splash-clear-cache ()
  "Delete all cached fancy splash images"
  (interactive)
  (delete-directory (expand-file-name "theme-splashes" doom-cache-dir) t)
  (message "Cache cleared!"))

(defun fancy-splash-generate-image (template height)
  "Read TEMPLATE and create an image if HEIGHT with colour substitutions as
   described by `fancy-splash-template-colours' for the current theme"
  (with-temp-buffer
    (insert-file-contents template)
    (re-search-forward "$height" nil t)
    (replace-match (number-to-string height) nil nil)
    (dolist (substitution fancy-splash-template-colours)
      (goto-char (point-min))
      (while (re-search-forward (car substitution) nil t)
        (replace-match (doom-color (cdr substitution)) nil nil)))
    (write-region nil nil
                  (fancy-splash-filename (symbol-name doom-theme) height) nil nil)))

(defun fancy-splash-generate-images ()
  "Perform `fancy-splash-generate-image' in bulk"
  (dolist (size fancy-splash-sizes)
    (unless (plist-get size :file)
      (fancy-splash-generate-image (or (plist-get size :file)
                                       (plist-get size :template)
                                       fancy-splash-image-template)
                                   (plist-get size :height)))))

(defun ensure-theme-splash-images-exist (&optional height)
  (unless (file-exists-p (fancy-splash-filename
                          (symbol-name doom-theme)
                          (or height
                              (plist-get (car fancy-splash-sizes) :height))))
    (fancy-splash-generate-images)))

(defun get-appropriate-splash ()
  (let ((height (frame-height)))
    (cl-some (lambda (size) (when (>= height (plist-get size :min-height)) size))
             fancy-splash-sizes)))

(setq fancy-splash-last-size nil)
(setq fancy-splash-last-theme nil)
(defun set-appropriate-splash (&rest _)
  (let ((appropriate-image (get-appropriate-splash)))
    (unless (and (equal appropriate-image fancy-splash-last-size)
                 (equal doom-theme fancy-splash-last-theme)))
    (unless (plist-get appropriate-image :file)
      (ensure-theme-splash-images-exist (plist-get appropriate-image :height)))
    (setq fancy-splash-image
          (or (plist-get appropriate-image :file)
              (fancy-splash-filename (symbol-name doom-theme) (plist-get appropriate-image :height))))
    (setq +doom-dashboard-banner-padding (plist-get appropriate-image :padding))
    (setq fancy-splash-last-size appropriate-image)
    (setq fancy-splash-last-theme doom-theme)
    (+doom-dashboard-reload)))

(add-hook 'window-size-change-functions #'set-appropriate-splash)
(add-hook 'doom-load-theme-hook #'set-appropriate-splash)

(set-frame-parameter (selected-frame) 'alpha '(92 . 90))

(add-to-list 'default-frame-alist '(alpha . (92 . 90)))


;;;;haditim
;; ** Don't ask to quit
(setq confirm-kill-emacs nil)
;; ** lsp always show breadcrumb
(setq lsp-headerline-breadcrumb-enable t)
;; ** Start maximised (cross-platf)
(add-hook 'window-setup-hook 'toggle-frame-maximized t)
