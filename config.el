(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(org-babel-load-file
 (expand-file-name "modules/evil/evil.org" user-emacs-directory))

(org-babel-load-file
 (expand-file-name "keybinds/general/general.org" user-emacs-directory))

(org-babel-load-file
 (expand-file-name "modules/org/org.org" user-emacs-directory))

(org-babel-load-file
 (expand-file-name "themes/themes.org" user-emacs-directory))

(org-babel-load-file
 (expand-file-name "modules/buffers/buffers.org" user-emacs-directory))

(org-babel-load-file
 (expand-file-name "modules/dev/completion/company.org" user-emacs-directory))

(org-babel-load-file
 (expand-file-name "modules/dev/eglot/eglot.org" user-emacs-directory))
