;;; -*- lexical-binding: t; -*-
;; Configuration:

(use-package vertico
  :ensure t
  :custom
  (vertico-resize t)
  (vertico-cycle t)
  :init
  (vertico-mode))

;; Configuration:

(use-package marginalia
  :after vertico
  :ensure t
  :init
  (marginalia-mode))

;; Configuration:

(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic)))

;; Configuration:

(use-package consult
  :ensure t)
