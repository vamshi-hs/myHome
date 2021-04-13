;;; modeline-cubed.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 vamshi krishna
;;
;; Author: vamshi krishna <https://github.com/root>
;; Maintainer: vamshi krishna <vamshi5070k@gmail.com>
;; Created: April 06, 2021
;; Modified: April 06, 2021
;; Version: 0.0.1
;; Keywords: Symbol’s value as variable is void: finder-known-keywords
;; Homepage: https://github.com/root/modeline-cubed
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

;; Set separator style
(setq telephone-line-primary-left-separator 'telephone-line-halfsin-left)
(setq telephone-line-primary-right-separator 'telephone-line-halfsin-right)

;; Set mode-line height
(setq telephone-line-height 24)

;; Left edge
;; TODO: gray background for buffer and mode segment in inactive line
(setq telephone-line-lhs
      '((evil   . ((my-evil-segment :active)))
        ;; (accent . (telephone-line-filesize-segment))
        (nil    . (telephone-line-projectile-buffer-segment))
        (nil    . (my-modified-status-segment))
        (nil    . (my-read-only-status-segment))
        (nil    . (selection-info))))
        ;; (nil    . (my-flycheck-segment))))

;; Right edge
(setq telephone-line-rhs
      '((nil    . (my-vc-segment))
        (accent . ((my-position-segment :active)))
        (nil    . ((my-major-mode-segment-icon :active)))
        ;; (nil    . (my-major-mode-segment-icon))
        (accent . ((my-coding-segment :active)))))

(provide 'modeline-cubed)


;;; modeline-cubed.el ends here
