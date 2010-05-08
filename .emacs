(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "black" :foreground "MediumPurple2" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 160 :width normal :foundry "apple" :family "Inconsolata"))))
 '(cursor ((t (:background "orange"))))
 '(mode-line ((t (:background "DarkOrchid3" :foreground "#101010" :box (:line-width -1 :color "grey")))))
 '(mode-line-inactive ((t (:inherit mode-line :background "MediumPurple4" :foreground "grey80" :box -1 :weight light)))))

(add-to-list 'load-path "~/.emacs-lib")

;; No Bullshit mode.
(setq inhibit-splash-screen t)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

(setq-default scroll-step 1)               ; turn off jumpy scroll
(setq-default visible-bell t)              ; no beeps, flash on errors
(column-number-mode t)                     ; display the column number on modeline

(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "|")
(setq uniquify-after-kill-buffer-p t)
(setq uniquify-ignore-buffers-re "^\\*")

(require 'ido)
(ido-mode t)

(require 'column-marker)
(add-hook 'python-mode-hook (lambda () (interactive) (column-marker-1 80)))

(global-set-key 
  (read-kbd-macro "C-x p") "import pdb; pdb.set_trace() # --miv DEBUG")
(global-set-key
  (read-kbd-macro "s-`") 'next-buffer)
(global-set-key
  (read-kbd-macro "s-q") 'buffer-menu)

;; Backslash is delete.
(global-set-key 
  (read-kbd-macro "\\") 'delete-char)

;; Use F5 to refresh a file.
(defun refresh-file ()
  (interactive)
  (revert-buffer t t t)
  )
(global-set-key [f5] 'refresh-file)

;; Use M-x kill-emacs if you really want to quit.
(global-set-key 
  (read-kbd-macro "C-x C-c") 'nil)


(defvar iresize-mode-map 
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "p") 'enlarge-window)
    (define-key m (kbd "<up>") 'enlarge-window)
    (define-key m (kbd "n") 'shrink-window)
    (define-key m (kbd "<down>") 'shrink-window)
    (define-key m (kbd "C-c C-c") 'iresize-mode)
    (define-key m (kbd "<left>") 'shrink-window-horizontally)
    (define-key m (kbd "<right>") 'enlarge-window-horizontally)    
    m))
(define-minor-mode iresize-mode
  :initial-value nil
  :lighter " IResize"
  :keymap iresize-mode-map
  :group 'iresize)
(provide 'iresize)
(global-set-key 
  (read-kbd-macro "C-x t w") 'iresize-mode)


;; Set up pymacs: emacs-python integration
;;(autoload 'pymacs-apply "pymacs")
;;(autoload 'pymacs-call "pymacs")
;;(autoload 'pymacs-eval "pymacs" nil t)
;;(autoload 'pymacs-exec "pymacs" nil t)
;;(autoload 'pymacs-load "pymacs" nil t)
;;(eval-after-load "pymacs"
;;  '(add-to-list 'pymacs-load-path ".emacs-lib/python"))


;; Set up pycomplete
;;(require 'pycomplete)
;;(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
;;(autoload 'python-mode "python-mode" "Python editing mode." t)
;;(setq interpreter-mode-alist(cons '("python" . python-mode)
;;                            interpreter-mode-alist))
