(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "black" :foreground "SlateGray4" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 122 :width normal :foundry "unknown" :family "Inconsolata"))))
 '(cursor ((t (:background "orange"))))
 '(mode-line ((t (:background "CornflowerBlue" :foreground "#101010" :box (:line-width -1 :color "SlateGray3")))))
 '(mode-line-inactive ((t (:inherit mode-line :background "Black" :foreground "CornflowerBlue" :box -1 :weight light)))))

(add-to-list 'load-path "~/.emacs-lib")
(add-to-list 'load-path "~/.emacs-lib/yasnippet-0.6.1c")

;; Tabs, I hate you. Get out.
(setq-default indent-tabs-mode nil)

;; No Bullshit mode.
(setq inhibit-splash-screen t)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

(setq-default scroll-step 1)   ; turn off jumpy scroll
(setq-default visible-bell t)  ; no beeps, flash on errors
(column-number-mode t)         ; display the column number on modeline
(show-paren-mode t)            ; highlight parens

;; Insert mode is garbage.
(global-set-key
  (read-kbd-macro "<insert>") 'nil)


;; GTFO trailing spaces, who asked YOU to this party?!
(defun ableton-trailing-ws-load ()
  (interactive)
  (let (
    (filename (buffer-file-name (current-buffer)))
    )
    (if (string-match ".*\\.py" filename)
      (setq show-trailing-whitespace t)
    )
  )
)
(defun ableton-trailing-ws-save ()
  (interactive)
  (if show-trailing-whitespace
    (delete-trailing-whitespace)
  )
)
(add-hook 'find-file-hook 'ableton-trailing-ws-load)
(add-hook 'before-save-hook 'ableton-trailing-ws-save)

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
  (read-kbd-macro "C-x P") "<?python\n  import pdb; pdb.set_trace() # --miv DEBUG\n ?>\n")
(global-set-key
  (read-kbd-macro "s-q") 'buffer-menu)

;; Use F5 or Super-R to refresh a file.
(defun really-refresh-file ()
  (interactive)
  (revert-buffer t t t)
  )
(global-set-key [f5] 'really-refresh-file)
(global-set-key (read-kbd-macro "s-r") 'really-refresh-file)

;; Anti-fat-finger quit mode
(global-set-key 
  (read-kbd-macro "C-x C-c") 'nil)
(global-set-key 
  (read-kbd-macro "C-x C-c q q") 'kill-emacs)

;; Meta-left and right to switch buffers
(global-set-key 
  (read-kbd-macro "M-<left>") 'next-buffer)
(global-set-key 
  (read-kbd-macro "M-<right>") 'previous-buffer)

;; Super-left and right to switch windows
(global-set-key 
  (read-kbd-macro "s-<left>") 'previous-multiframe-window)
(global-set-key 
  (read-kbd-macro "s-<right>") 'next-multiframe-window)

(global-set-key 
  (read-kbd-macro "s-k") 'kill-this-buffer)


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


(require 'color-theme)
(load-library "color-theme-monokai_dark")
(color-theme-monokai_dark)

;; Set up pymacs: emacs-python integration
;;(autoload 'pymacs-apply "pymacs")
;;(autoload 'pymacs-call "pymacs")
;;(autoload 'pymacs-eval "pymacs" nil t)
;;(autoload 'pymacs-exec "pymacs" nil t)
;;(autoload 'pymacs-load "pymacs" nil t)
;;(eval-after-load "pymacs"
;;  '(add-to-list 'pymacs-load-path ".emacs-lib/python"))

(require 'magit)

(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(put 'narrow-to-region 'disabled nil)

;; Automagically tab new lines
(global-set-key (kbd "RET") 'reindent-then-newline-and-indent)

;;
;; Mac only stuff
;;
(when (string= "Darwin\n" (shell-command-to-string "uname"))
  ;; C-Backslash is delete.
  (global-set-key (read-kbd-macro "C-\\") 'delete-char)

  ;; Apple wants a bigger font for some reason
  (set-face-attribute 'default nil
                      :height 160)
  )
