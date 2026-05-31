(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font")

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  ;; Sets the default theme to load!!! 
  (load-theme 'doom-moonlight t)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package nerd-icons
  :ensure t)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-icons-kind 'nerd-icons)
  (doom-modeline-height 25)
  (doom-modeline-bar-width 4)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t)
  :config
  (set-face-attribute 'mode-line nil :font "JetBrainsMono Nerd Font" :height 110)
  (set-face-attribute 'mode-line-inactive nil :font "JetBrainsMono Nerd Font" :height 110))
