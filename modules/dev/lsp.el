;;; -*- lexical-binding: t; -*-
;; LSP Mode

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :custom
  (lsp-idle-delay 0.5)
  (lsp-log-io nil)
  (lsp-completion-provider :capf)
  (lsp-headerline-breadcrumb-enable t)
  (lsp-auto-guess-root t))

;; LSP UI

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-sideline-enable t))

;; LSP Treemacs

(use-package lsp-treemacs
  :after lsp)

;; Tree-sitter
;; Escopo deliberado: só C, Python, Rust, Lua, Bash e Dockerfile usam
;; =-ts-mode= aqui. Não existe =-ts-mode= real pra Haskell/CUDA/GLSL/
;; Makefile/LaTeX — nem no Emacs core, nem no MELPA/GNU ELPA — então esses
;; ficam nos modos clássicos (não dá pra ligar tree-sitter num modo que
;; não existe).

;; Cada =-ts-mode= é um modo *irmão* do clássico correspondente, não um
;; filho — exceto =bash-ts-mode=, que declara =sh-mode= como parent extra
;; via =derived-mode-add-parents=. Na prática isso significa que hooks
;; presos em =X-mode-hook= (o nome clássico) não disparam mais pros
;; buffers que viram =X-ts-mode=; por isso os blocos de C/Python/Rust
;; abaixo tiveram que trocar de hook.

(setq treesit-language-source-alist
      (append treesit-language-source-alist
              '((c          . ("https://github.com/tree-sitter/tree-sitter-c"))
                (python     . ("https://github.com/tree-sitter/tree-sitter-python"))
                (rust       . ("https://github.com/tree-sitter/tree-sitter-rust"))
                (lua        . ("https://github.com/tree-sitter-grammars/tree-sitter-lua"))
                (bash       . ("https://github.com/tree-sitter/tree-sitter-bash"))
                (dockerfile . ("https://github.com/camdencheek/tree-sitter-dockerfile")))))

(dolist (lang '(c python rust lua bash dockerfile))
  (unless (treesit-language-available-p lang)
    (treesit-install-language-grammar lang)))

;; Redireciona os modos clássicos pros -ts-mode automaticamente —
;; cobre :mode/:hook de outros pacotes que ainda referenciam o nome
;; clássico por padrão (ex.: lsp-pyright usa `python-mode').
(dolist (mapping '((c-mode  . c-ts-mode)
                    (python-mode . python-ts-mode)
                    (sh-mode . bash-ts-mode)))
  (add-to-list 'major-mode-remap-alist mapping))

;; Dockerfile não tem entrada padrão no auto-mode-alist.
(add-to-list 'auto-mode-alist '("/Dockerfile\\(?:\\.[^/]*\\)?\\'" . dockerfile-ts-mode))
(add-to-list 'auto-mode-alist '("\\.dockerfile\\'" . dockerfile-ts-mode))

;; Lua
;; Usa o =lua-ts-mode= nativo do Emacs — não precisa mais do pacote
;; =lua-mode= do MELPA.

(setq lua-ts-indent-offset 2)
(add-to-list 'auto-mode-alist '("\\.lua\\'" . lua-ts-mode))
(add-hook 'lua-ts-mode-hook #'lsp-deferred)

;; C/C++
;; =.cpp=/=.hpp= continuam no =cc-mode= clássico (fora do escopo pedido);
;; =.c= vai pro =c-ts-mode= via =major-mode-remap-alist= (seção
;; Tree-sitter acima) — só falta trocar o hook.

(setq lsp-clients-clangd-args
      '("-j=4"
        "--background-index"
        "--clang-tidy"
        "--completion-style=detailed"
        "--header-insertion=iwyu"
        "--header-insertion-decorators"))
(add-hook 'c-ts-mode-hook #'lsp-deferred)
(add-hook 'c++-mode-hook #'lsp-deferred)

;; Python
;; =pet= (Python Executable Tracker) detecta o ambiente do projeto aberto
;; automaticamente — Hatch, Poetry, pyenv (=.python-version=),
;; venv/virtualenv simples — sem seleção manual. =pet-mode= entra em
;; =python-base-mode-hook= (compartilhado por =python-mode= e
;; =python-ts-mode=, ver seção Tree-sitter) com prioridade =-10= pra
;; rodar antes de qualquer hook que dependa do cache dele.

;; =lsp-pyright= é o servidor principal (tipos, completion, hover).
;; =lsp-ruff= (já embutido no lsp-mode, registrado como =:add-on?= — não
;; compete com o pyright, os dois ficam ativos ao mesmo tempo no mesmo
;; buffer) cuida de lint/fix/organize-imports via =ruff server=. O pacote
;; lsp-pyright carrega no startup (use-package não autoload um lambda
;; anônimo em =:hook=), o servidor só sobe de fato via =lsp-deferred= ao
;; entrar num buffer Python — hook em =python-ts-mode=, não =python-mode=
;; (=major-mode-remap-alist= redireciona =.py=, mas o hook em si precisa
;; apontar pro nome novo).

;; =M-x run-python= usa =ipython= do próprio venv do projeto
;; (=--simple-prompt=, senão a saída quebra dentro do =comint=) — não o
;; mesmo Python que o pyright usa pra introspecção (esse continua sendo o
;; =python= puro do venv, não o ipython).

(use-package pet
  :ensure t
  :config
  (add-hook 'python-base-mode-hook 'pet-mode -10))

(use-package lsp-pyright
  :ensure t
  :hook (python-ts-mode . (lambda ()
                             (require 'lsp-pyright)
                             (let ((python (pet-executable-find "python")))
                               (setq-local lsp-pyright-python-executable-cmd python
                                           lsp-pyright-venv-path (pet-virtualenv-root)
                                           python-shell-interpreter (or (pet-executable-find "ipython") python)
                                           python-shell-interpreter-args "--simple-prompt"
                                           python-shell-virtualenv-root (pet-virtualenv-root)
                                           lsp-ruff-server-command (list (or (pet-executable-find "ruff") "ruff") "server")))
                             (lsp-deferred))))

;; Rust
;; Usa o =rust-ts-mode= nativo do Emacs — não precisa mais do pacote
;; =rust-mode= do MELPA pro major-mode (só sobrou =toml-mode=, pra editar
;; =Cargo.toml=). Format-on-save trocou de invocar =rustfmt= direto (era o
;; que =rust-format-on-save= fazia) pra =lsp-format-buffer=, que usa o
;; rust-analyzer — também roda rustfmt por baixo, mas via LSP.

(use-package toml-mode)

(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
(add-hook 'rust-ts-mode-hook #'lsp-deferred)
(add-hook 'rust-ts-mode-hook
          (lambda () (add-hook 'before-save-hook #'lsp-format-buffer nil t)))

;; Bash
;; Servidor já instalado no sistema (=bash-language-server=, cliente
;; embutido em =lsp-bash.el=). =.sh= já é redirecionado pro =bash-ts-mode=
;; via =major-mode-remap-alist= (seção Tree-sitter acima).

(add-hook 'bash-ts-mode-hook #'lsp-deferred)

;; Dockerfile
;; Servidor não está instalado no sistema — o lsp-mode instala sozinho via
;; npm (=dockerfile-language-server-nodejs=, cliente embutido em
;; =lsp-dockerfile.el=) na primeira vez que =lsp-deferred= rodar num
;; buffer =Dockerfile=; precisa de =node=/=npm= no PATH (ambos presentes
;; no sistema).

(add-hook 'dockerfile-ts-mode-hook #'lsp-deferred)

;; Haskell
;; =~/.ghcup/bin= (onde o HLS é instalado) entra no ~PATH~ via
;; =~/.config/environment.d/ghcup.conf= (systemd user session), não por
;; rc file de shell — assim fica disponível pra qualquer processo da
;; sessão gráfica, igual =clangd=/=rust-analyzer= que vêm de pacotes do
;; sistema. Nenhum ajuste de =exec-path= é necessário aqui.

;; ---------------------------------------------------------------------
;; 1. Haskell Syntax & Interactive REPL (GHCi)
;; ---------------------------------------------------------------------
(use-package haskell-mode
  :ensure t
  :mode "\\.hs\\'"
  :hook ((haskell-mode . interactive-haskell-mode)   ; Enable interactive REPL commands
         (haskell-mode . turn-on-haskell-indentation)) ; Better indentation rules
  :custom
  ;; Choose your default REPL target ("cabal-repl" or "stack-repl")
  (haskell-process-type 'cabal-repl)
  (haskell-process-log t))

;; ---------------------------------------------------------------------
;; 2. Haskell LSP Backend (HLS)
;; ---------------------------------------------------------------------
(use-package lsp-haskell
  :ensure t
  :hook (haskell-mode . lsp-deferred)
  :custom
  ;; Optional: Enable format on save via HLS (Ormolu/Fourmolu)
  (lsp-haskell-formatting-provider "ormolu"))
