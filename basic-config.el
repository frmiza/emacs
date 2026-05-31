(setq inhibit-startup-message t)

(menu-bar-mode -1)                     ; no menu bar
(tool-bar-mode -1)                     ; no tools bar
(scroll-bar-mode -1)                   ; no scroll bars
(tooltip-mode -1)                      ; no tooltips
(set-fringe-mode 10)                   ; frame edges set to 10px
(column-number-mode 1)                 ; modeline shows column number
(save-place-mode 1)                    ; remember cursor position
(recentf-mode 1)                       ; remember recent files
(savehist-mode 1)                      ; enable history saving

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)             ; tabstop set to 2
(setq-default standard-indent 4)       ; softtabstop / shiftwidth = 2
(setq-default electric-indent-mode 1)  ; autoident

(global-display-line-numbers-mode 1)   ; number lines 
(setq display-line-numbers-type 'relative) 
(setq column-number-mode 1)

(dolist (mode '(org-mode-hook          ; disable line for some modes
              term-mode-hook
              shell-mode-hook
              eshell-mode-hook))
(add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq-default cursor-type 'line)       ; cursor type
(setq hl-line-mode nil)                ; cursorline

(global-hl-line-mode 1)                ; highlight current line
(global-visual-line-mode 1)            ; linebreak
(setq-default truncate-lines nil)

(fset 'yes-or-no-p 'y-or-n-p)

(electric-pair-mode 1)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(global-set-key (kbd "C-=") 'text-scale-increase) 
(global-set-key (kbd "C--") 'text-scale-decrease)
