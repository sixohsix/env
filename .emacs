(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "black" :foreground "SlateGray4" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "unknown" :family "Inconsolata"))))
 '(cursor ((t (:background "orange"))))
 '(mode-line ((t (:background "CornflowerBlue" :foreground "#101010" :box (:line-width -1 :color "SlateGray3")))))
 '(mode-line-inactive ((t (:inherit mode-line :background "NavyBlue" :foreground "CornflowerBlue" :box -1 :weight light))))
 )

(add-to-list 'load-path "~/.emacs-lib")
(add-to-list 'load-path "~/.emacs-lib/abl-mode")

;; Tabs, I hate you. Get out.
(setq-default indent-tabs-mode nil)

;; No Bullshit mode.
(setq inhibit-splash-screen t)
(menu-bar-mode 0)
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode 0)
  (scroll-bar-mode 0)
  )

(setq-default scroll-step 1)      ; turn off jumpy scroll
(column-number-mode t)            ; display the column number on modeline
(show-paren-mode t)               ; highlight parens
(setq pop-up-windows nil)         ; pop-up windows GTFO
(setq ring-bell-function 'ignore) ; beeping noise: STFU!!

;; Insert mode is garbage.
(global-set-key
  (read-kbd-macro "<insert>") 'nil)

;; Behave like a normal editor and delete region when you type
(delete-selection-mode 1)

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
(add-hook 'python-mode-hook
          (lambda () (interactive)
            (column-marker-1 80)
            (smart-tab-mode 1)))

(global-set-key 
  (read-kbd-macro "C-x p") "import pdb; pdb.set_trace() # --miv DEBUG")
(global-set-key 
  (read-kbd-macro "C-x P") "<?python\n  import pdb; pdb.set_trace() # --miv DEBUG\n ?>\n")

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
  (read-kbd-macro "s-<left>") 'next-buffer)
(global-set-key 
  (read-kbd-macro "s-<right>") 'previous-buffer)

;; Move around split buffers using meta key and arrows
(windmove-default-keybindings 'meta)

(global-set-key 
  (read-kbd-macro "s-k") 'kill-this-buffer)
(global-set-key 
  (read-kbd-macro "s-R") 'rename-buffer)

(defun run-bash ()
  (interactive)
  (shell "/bin/bash")
  (rename-uniquely)
  )
(global-set-key 
  (read-kbd-macro "s-t") 'run-bash)

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
;;(load-library "color-theme-monokai_dark")
;;(color-theme-monokai_dark)
;;(load-library "color-theme-wombat")
;;(color-theme-wombat)
(load-library "color-theme-solarize-1")
(color-theme-solarize-1)

;; Make terminal colors look good against black
(setq ansi-term-color-vector
      [unspecified "#000000" "#963F3C" "#5FFB65" "#FFFD65"
                   "#0082FF" "#FF2180" "#57DCDB" "#FFFFFF"])
(setq-default comint-prompt-read-only t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-hook 'shell-mode-hook '(lambda () (toggle-truncate-lines 1)))

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
(setq js2-mirror-mode nil)

(put 'narrow-to-region 'disabled nil)

;; Automagically tab new lines
(global-set-key (kbd "RET") 'newline-and-indent)


;; autopair braces () {} "" <> etc.
(require 'autopair)
(autopair-global-mode) ;; enable autopair in all buffers

(require 'miv-mark-zoom)

(require 'abl)
(setq expected-projects-base-path "/home/%s/projects")
(setq vem-command "vem_activate")

(require 'smart-tab)


;;
;; Mac only stuff
;;
(when (string= "ingot.local\n" (shell-command-to-string "hostname"))
  ;; C-Backslash is delete.
  (global-set-key (read-kbd-macro "C-\\") 'delete-char)

  ;; Apple wants a bigger font for some reason
  (set-face-attribute 'default nil
                      :height 160)

  (if (eq 'ns window-system)
      (setq default-frame-alist
            '((top . 0) (left . 40)
              (width . 90) (height . 62))
            )
    )
  )


;;
;; Work-only stuff
;;
(when (string= "client8136\n" (shell-command-to-string "hostname"))
  (if (eq 'x window-system)
      (setq default-frame-alist
            '((top . 0) (left . 400)
              (width . 145) (height . 64))
            )
    )

  (server-start)
  )
