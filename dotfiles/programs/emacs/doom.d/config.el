;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "vamshi krishna"
      user-mail-address "benb6768@gmail.com")

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

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-wilmersdorf)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

(setq doom-font (font-spec :family "SauceCodePro Nerd Font Mono" :size 30)
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 30)
      doom-big-font (font-spec :family "SauceCodePro Nerd Font Mono" :size 34))

(setq treemacs-width 20)

(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

(display-time-mode 1)
(display-battery-mode 1)

;(use-package nix-haskell-mode
;  :hook (haskell-mode . nix-haskell-mode))
;; KEYBINDINGS
(map! :leader
      :desc "aSave"
      "a" #'save-buffer)

(map! :leader
      :desc "run-Haskell"
      "r" #'run-haskell)

(map! :leader
      :desc "zComment"
      "z" #'evilnc-comment-or-uncomment-lines)

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
