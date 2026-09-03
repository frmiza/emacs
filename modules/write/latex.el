;;; -*- lexical-binding: t; -*-
;; AUCTeX

(use-package auctex
  :ensure t
  :defer t
  :mode ("\\.tex\\'" . LaTeX-mode)
  :hook ((LaTeX-mode . lsp-deferred)
         (LaTeX-mode . TeX-PDF-mode)              ; compila direto pra PDF, não DVI
         (LaTeX-mode . TeX-source-correlate-mode)) ; sincroniza PDF <-> fonte
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-master nil)                     ; pergunta/detecta master em projetos multi-arquivo
  (TeX-source-correlate-start-server t))

;; latexmk como build padrão
;; =latexmk= já está no sistema (texlive-binextra) e resolve sozinho
;; quantas passadas de pdflatex/bibtex são necessárias.

(use-package auctex-latexmk
  :ensure t
  :after auctex
  :custom
  (auctex-latexmk-inherit-TeX-PDF-mode t)
  :config
  (auctex-latexmk-setup))

;; pdf-tools
;; Usa =pdf-loader-install= (não =pdf-tools-install= direto): só registra
;; os autoloads no boot, a compilação do =epdfinfo= roda de fato na
;; primeira vez que um PDF é aberto.

(use-package pdf-tools
  :ensure t
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :config
  (pdf-loader-install)
  (setq-default pdf-view-display-size 'fit-page))

;; Viewer do AUCTeX apontando pro pdf-tools
;; Sem isso, =C-c C-v= abriria um visualizador externo em vez do buffer
;; pdf-view dentro do próprio Emacs.

(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view)))
(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)
