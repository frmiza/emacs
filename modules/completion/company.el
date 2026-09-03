;;; -*- lexical-binding: t; -*-
;; Company

(use-package company
  :ensure t
  :diminish
  :init
  (global-company-mode t)
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.02
        company-tooltip-align-annotations t

        company-frontends '(company-pseudo-tooltip-unless-just-one-frontend
                             company-echo-metadata-frontend)

        ;; Only current buffer
        company-dabbrev-other-buffers nil
        company-async-timeout 5)

  ;; Sync with evil insert
  (with-eval-after-load 'evil
    (add-hook 'evil-normal-state-entry-hook #'company-abort)))
