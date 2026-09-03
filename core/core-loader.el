;; core-loader.el -- load all .org files  

(defun my/load-org-module (relative-org-path)
  ;; Load module passed by arg relative-org-path
  ;;tangling and compiling if its have new features.

  ;; parser file name
  (let* ((org-file (expand-file-name relative-org-path user-emacs-directory))
         (el-file (concat (file-name-sans-extension org-file) ".el"))
         (elc-file (concat el-file "c")))

    ;;tangling
    (when (or (not (file-exists-p el-file))
              (file-newer-than-file-p org-file el-file))
      (require 'ob-tangle)
      (org-babel-tangle-file org-file el-file "emacs-lisp"))

    ;; compiling
    (when (or (not (file-exists-p elc-file))
              (file-newer-than-file-p el-file elc-file))
      (let ((byte-compile-warnings nil))
        (byte-compile-file el-file)))
    
    ;; load file
    (load (file-name-sans-extension el-file))))

(defvar my/modules
  '("core/editor.org"
    "modules/evil/evil.org"
    "modules/keybinds/general.org"
    "modules/completion/minibuffer.org"
    "modules/completion/company.org"
    "modules/org/org.org"
    "modules/write/latex.org"
    "modules/write/spell.org"
    "modules/ui/theme.org"
    "modules/ui/treemacs.org"
    "modules/ui/terminal.org"
    "modules/dev/lsp.org"))

(dolist (m my/modules)
  (my/load-org-module m))
