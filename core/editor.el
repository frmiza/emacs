;;; -*- lexical-binding: t; -*-
;; Disable automatic backup/autosave

(setq make-backup-files nil)

;; Memory session

(save-place-mode 1)
(recentf-mode 1)
(savehist-mode 1)

;; Indent

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)             ; tabstop
(setq-default standard-indent 4)       ; softtabstop / shiftwidth
(setq-default electric-indent-mode 1)  ; autoindent

;; Line numbers

;; Disable line numbers on .org files, terminal/shell mode


(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
(setq column-number-mode 1)

(dolist (mode '(org-mode-hook
                 term-mode-hook
                 shell-mode-hook
                 eshell-mode-hook
                 pdf-view-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Cursor

;; Highlight current line and visual broken line


(setq-default cursor-type 'line)
(global-hl-line-mode 1) 
(global-visual-line-mode 1)
(setq-default truncate-lines nil)

;; Prompt

(fset 'yes-or-no-p 'y-or-n-p)
(electric-pair-mode 1)

;; Font Size

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
