;; init.el

;; custom-set-*.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;; use-package.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; All Packages are listed and documentend in .org files on core and modules directory
;; core/core-loader.el to load all packages and manage memory
(load (expand-file-name "core/core-loader.el" user-emacs-directory))
