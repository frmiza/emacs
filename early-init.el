;; early-init.el

;; GC handler 
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)
                  gc-cons-percentage 0.1)))

;; big buffers to load more date
(setq read-process-output-max (* 1024 1024))

;; disable some UI stuffs 
(setq default-frame-alist
      (append '((menu-bar-lines . 0)
                (tool-bar-lines . 0)
                (vertical-scroll-bars . nil))
               default-frame-alist)
      
      inhibit-startup-message t
      inhibit-startup-screen t
      frame-inhibit-implied-resize t)

(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(when (fboundp 'tooltip-mode) (tooltip-mode -1))

;; package manager melpa + elpa
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                          ("elpa"  . "https://elpa.gnu.org/packages/")))

;; --- disable asyncronous warning popups at startup
(when (boundp 'native-comp-async-report-warnings-errors)
  (setq native-comp-async-report-warnings-errors 'silent))
