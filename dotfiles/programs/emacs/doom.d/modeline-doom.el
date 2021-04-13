;;; modeline-doom.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 vamshi krishna
;;
;; Author: vamshi krishna <https://github.com/root>
;; Maintainer: vamshi krishna <vamshi5070k@gmail.com>
;; Created: April 06, 2021
;; Modified: April 06, 2021
;; Version: 0.0.1
;; Keywords: Symbol’s value as variable is void: finder-known-keywords
;; Homepage: https://github.com/root/modeline-doom
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

; Mode-line based on doom-modeline package -*- lexical-binding: t -*-
(use-package doom-modeline
  :defer t
  :hook (after-init . doom-modeline-init)
  :config
  (setq doom-modeline-bar-width 3
        ;; doom-modeline-icon t
        doom-modeline-buffer-file-name-style 'truncate-with-project
        doom-modeline-minor-modes nil))
        ;; doom-modeline-major-mode-icon t))

(provide 'modeline-doom)

;;; modeline-doom.el ends here
