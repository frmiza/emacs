(load-theme 'modus-vivendi)

(org-babel-load-file
 (expand-file-name "basic-config.org" user-emacs-directory))

(org-babel-load-file
 (expand-file-name "config.org" user-emacs-directory))

;(use-package tidal
;  :ensure t
;  :mode ("\\.tidal\\'" . tidal-mode)
;  :config
;  (setq tidal-interpreter "ghci")
;  ;; O segredo está nesta linha abaixo:
;  (setq tidal-boot-script-path "/home/shoyo/.local/share/nvim/lazy/tidal.nvim/bootfiles/BootTidal.hs")
;  (defalias 'tidal-start-interpreter 'tidal-start-haskell))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
