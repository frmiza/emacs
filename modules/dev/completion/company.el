(setq gc-cons-threshold 100000000)

;; Aumenta a quantidade de dados que o Emacs lê do processo LSP de uma vez.
;; O padrão é 4KB. Mudamos para 1MB. Isso remove o delay de renderização.
(setq read-process-output-max (* 1024 1024))

;; ====================================================================
;; 2. CONFIGURAÇÃO ULTRA-RÁPIDA DO COMPANY (Sem Company-Box)
;; ====================================================================
(use-package company
  :ensure t
  :diminish
  :init
  (global-company-mode t)
  :config
  (setq company-minimum-prefix-length 1
        ;; O PULO DO GATO: Não use 0.0. O valor 0.02 (20ms) é invisível ao olho humano,
        ;; mas dá o fôlego necessário para a thread do Emacs receber o LSP de forma fluida.
        company-idle-delay 0.02
        company-tooltip-align-annotations t
        
        ;; IMPORTANTE: Usamos o menu nativo do Emacs, que é infinitamente mais veloz
        ;; que o company-box e não causa quedas de FPS.
        company-frontends '(company-pseudo-tooltip-unless-just-one-frontend
                            company-echo-metadata-frontend)
        
        ;; Impede o Company de tentar adivinhar palavras de outros buffers (gera lag)
        company-dabbrev-other-buffers nil
        company-async-timeout 5)

  ;; Sincronização limpa com o Modo Insert do Evil
  (with-eval-after-load 'evil
    (add-hook 'evil-normal-state-entry-hook #'company-abort)))
