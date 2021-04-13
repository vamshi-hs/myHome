;;; modeline-flat.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 vamshi krishna
;;
;; Author: vamshi krishna <https://github.com/root>
;; Maintainer: vamshi krishna <vamshi5070k@gmail.com>
;; Created: April 06, 2021
;; Modified: April 06, 2021
;; Version: 0.0.1
;; Keywords: Symbol’s value as variable is void: finder-known-keywords
;; Homepage: https://github.com/root/modeline-flat
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:



(setq telephone-line-primary-left-separator 'telephone-line-identity-left)
(setq telephone-line-primary-right-separator 'telephone-line-identity-right)
;; (setq telephone-line-primary-left-separator 'telephone-line-halfsin-left)
;; (setq telephone-line-primary-right-separator 'telephone-line-halfsin-right)

;; Set mode-line height
(setq telephone-line-height 28)


;; (set-face-bold 'mode-line nil)
;; (set-face-attribute 'mode-line-inactive nil (:box (:line-width 1)))

;; Left edge
;; TODO: gray background for buffer and mode segment in inactive line
(setq telephone-line-lhs
      '(
        (evil   . (my-evil-segment))
        (nil    . (my-modified-status-segment))
        (nil    . (my-read-only-status-segment))))

(setq telephone-line-center-lhs
      '(
        (nil)
        ;; (accent . ((my-flycheck-segment ))))
        (accent . ((my-major-mode-segment :active)))))

(setq telephone-line-center-rhs
      '(
        (accent . (my-buffer-segment))
        (nil)))

;; Right edge
(setq telephone-line-rhs
      '(
        (nil)
        (nil    . ((my-vc-segment :active)))
        ;; (nil    . (my-position-segment))
        (accent . ((my-coding-segment :active)))))
        ;; (nil . (my-position-segment))
        ;; (nil . (my-major-mode-segment))
        ;; (accent . ((my-coding-segment :active)))))

(provide 'modeline-flat)

;;; modeline-flat.el ends here
