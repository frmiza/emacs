(use-package vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")   ;; Set this to match your custom shell prompt
  (setq vterm-shell "zsh")                                                    ;; Set this to customize the shell to launch
  (setq vterm-max-scrollback 10000))
