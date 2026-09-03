(use-package jinx
  :ensure t
  :demand t
  :bind
  ( :map global-map
    ("M-$" . jinx-correct) ; or bind `jinx-correct-all'
    ("C-M-$" . jinx-languages))
  :config
  ;; Here you can specify a string with space-separated dictionaries.
  ;; I install the aspell dictionaries, such as the Debian package
  ;; `aspell-fr' for French and `aspell-el' for Greek (Éllinika).
  ;; With `aspell' installed on the system, do `aspell dicts' on the
  ;; command-line to get a list of available dictionaries.
  (setq jinx-languages "en pt")

  ;; I want to have Jinx in programming modes but I do not want it to
  ;; check anything that is a comment or string, because then it
  ;; underlines too many things which are not useful. We can do the
  ;; same for other modes, though I think this is fine.
  (setq jinx-exclude-faces
        '((prog-mode font-lock-comment-face font-lock-string-face)))

  (global-jinx-mode 1))
