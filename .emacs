
(add-to-list 'load-path "~/.emacs-lib")

(setq-default indent-tabs-mode nil) ; Tabs, I hate you. Get out.
(setq inhibit-splash-screen t)      ; No Bullshit mode.
(setq-default scroll-step 1)        ; turn off jumpy scroll
(column-number-mode t)              ; display the column number on modeline
(show-paren-mode t)                         ; highlight parens
(setq pop-up-windows nil)                   ; pop-up windows GTFO
(setq ring-bell-function 'ignore)           ; beeping noise: STFU!!
(setq-default show-trailing-whitespace t)   ; I hate trailing whitespace.
(blink-cursor-mode (- (*) (*) (*)))         ; No blinking
(menu-bar-mode 0)                           ; No menu
(tool-bar-mode 0)
(transient-mark-mode 0)                     ; No highlight

;; Insert mode is garbage.
(global-set-key
  (read-kbd-macro "<insert>") 'nil)

;; Behave like a normal editor and delete region when you type
(delete-selection-mode 1)

(load-theme 'wombat)

;; xterm keys
(define-key input-decode-map "\e[1;5A" [C-up])
(define-key input-decode-map "\e[1;5B" [C-down])
(define-key input-decode-map "\e[1;5C" [C-right])
(define-key input-decode-map "\e[1;5D" [C-left])
(define-key input-decode-map "\e[1;3A" [M-up])
(define-key input-decode-map "\e[1;3B" [M-down])
(define-key input-decode-map "\e[1;3C" [M-right])
(define-key input-decode-map "\e[1;3D" [M-left])
(define-key input-decode-map "\e[1;6A" [C-S-up])
(define-key input-decode-map "\e[1;6B" [C-S-down])
(define-key input-decode-map "\e[1;6C" [C-S-right])
(define-key input-decode-map "\e[1;6D" [C-S-left])
(define-key input-decode-map "\e[1;7A" [C-M-up])
(define-key input-decode-map "\e[1;7B" [C-M-down])
(define-key input-decode-map "\e[1;7C" [C-M-right])
(define-key input-decode-map "\e[1;7D" [C-M-left])


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
            (smart-tab-mode 1)))

(add-hook 'find-file-hook
          (lambda () (interactive) (column-marker-1 80)))

(global-set-key
 (read-kbd-macro "C-x p") "import bpdb; bpdb.set_trace() # --miv DEBUG")
(global-set-key
 (read-kbd-macro "C-x P")
 "<?python\n  import pdb; pdb.set_trace() # --miv DEBUG\n ?>\n")
(global-set-key (read-kbd-macro "C-M-s") 'rgrep)
(global-set-key (read-kbd-macro "C-M-k") 'kill-this-buffer)
(global-set-key (read-kbd-macro "C-c c") 'delete-trailing-whitespace)

;; Anti-fat-finger quit mode
(global-set-key (read-kbd-macro "C-x C-c") 'nil)
(global-set-key (read-kbd-macro "C-x C-c q q") 'kill-emacs)

;; Meta-left and right to switch buffers
(global-set-key (read-kbd-macro "M-<left>") 'next-buffer)
(global-set-key (read-kbd-macro "M-<right>") 'previous-buffer)

;; Use F5 to refresh a file.
(defun really-refresh-file ()
  (interactive)
  (revert-buffer t t t)
  )
(global-set-key [f5] 'really-refresh-file)


(defvar iresize-mode-map
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "p") 'enlarge-window)
    (define-key m (kbd "<up>") 'enlarge-window)
    (define-key m (kbd "n") 'shrink-window)
    (define-key m (kbd "<down>") 'shrink-window)
    (define-key m (kbd "C-q") 'iresize-mode)
    (define-key m (kbd "<left>") 'shrink-window-horizontally)
    (define-key m (kbd "<right>") 'enlarge-window-horizontally)
    m))
(define-minor-mode iresize-mode
  :initial-value nil
  :lighter " IResize"
  :keymap iresize-mode-map
  :group 'iresize)
(global-set-key
  (read-kbd-macro "C-x t w") 'iresize-mode)

;; Make terminal colors look good against black
(setq ansi-term-color-vector
      [unspecified "#000000" "#963F3C" "#5FFB65" "#FFFD65"
                   "#0082FF" "#FF2180" "#57DCDB" "#FFFFFF"])
(setq-default comint-prompt-read-only t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-hook 'shell-mode-hook '(lambda () (toggle-truncate-lines 1)))

(require 'js2-mode)
(setq js2-consistent-level-indent-inner-bracket-p 'true)
(setq js2-mirror-mode nil)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(require 'feature-mode)
(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))

(put 'narrow-to-region 'disabled nil)

;; Automagically tab new lines
(global-set-key (kbd "RET") 'newline-and-indent)

;; autopair braces () {} "" <> etc.
(require 'autopair)
(autopair-global-mode) ;; enable autopair in all buffers

(require 'miv-mark-zoom)
(require 'miv-sexy-powerline)

(require 'abl)
(setq expected-projects-base-path "/home/%s/projects")
(setq vem-activate-command "workon %s")
(setq vems-base-dir "~/.venvs2.7")
(setq nose-command "nosetests -vs")
(add-hook 'find-file-hooks 'abl-mode-hook)

(require 'smart-tab)
(require 'coffee-mode)
(defun coffee-custom () "coffee-mode-hook"
  (set (make-local-variable 'tab-width) 2))
(add-hook 'coffee-mode-hook
          '(lambda() (coffee-custom)))

(require 'undo-tree)
(global-undo-tree-mode 1)

(load "~/.emacs-lib/haskell-mode/haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)


;; Find python imports.
(defun find-import ()
  (interactive)
  (let ((current (point)))
    (re-search-backward "[\n \.\(\)\"\',]" nil t)
    (forward-char)
    (let* ((start (point))
       (end (- (re-search-forward "[\n \.\(\)\"\',]" nil t) 1))
       (entity (buffer-substring-no-properties start end))
       (re (format "import \\(\\(\(\n?\\)[^\)]*\\)?\\(.*\\)?%s" entity)))
      (goto-char (point-min))
      (unless (re-search-forward re nil t)
    (goto-char current)
    (message "import could not be found")))))

;;(define-key 'python-mode-map (kbd "C-c f") 'find-import)

(defun sh-region-replace (command &optional b e)
  (interactive "r")
  (shell-command-on-region b e command (current-buffer) 't)
  )
(global-set-key
 (read-kbd-macro "C-c i")
 (lambda (&optional b e) (interactive "r")
   (sh-region-replace "reorder_imports2" b e)))
(global-set-key
 (read-kbd-macro "C-c ]")
 (lambda (&optional b e) (interactive "r")
   (sh-region-replace "indent" b e)))
(global-set-key
 (read-kbd-macro "C-c [")
 (lambda (&optional b e) (interactive "r")
   (sh-region-replace "dedent" b e)))


(require 'haml-mode)
(add-hook 'haml-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (define-key haml-mode-map "\C-m" 'newline-and-indent)))


;;
;; Mac only stuff
;;
(when (string= "ingot.local\n" (shell-command-to-string "hostname"))

  (set-default-font "Anonymous Pro-14")
  (when (fboundp 'tool-bar-mode)
    (tool-bar-mode 0)
    (scroll-bar-mode 0)
    )

  ;; C-Backslash is delete.
  (global-set-key (read-kbd-macro "C-\\") 'delete-char)

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
  (setenv "PATH" (concat (getenv "HOME") "/.cabal/bin:" (getenv "PATH")))
  ;; (add-to-list 'load-path "~/projects/extended_abl_mode")
  ;; (require 'extended-abl)
  (setq mouse-autoselect-window t)            ; Follow mouse
  ;;(xterm-mouse-mode t)
  )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values (quote ((encoding . utf-8)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
