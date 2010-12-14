; http://coderchrome.org/15

(eval-when-compile (require 'color-theme))

(defun color-theme-monokai_dark ()
	(interactive)
	(color-theme-install '(color-theme-monokai_dark 
	(
		(foreground-color . "#F8F8F2")
		(background-color . "#0D0D0D")
	)
	(font-lock-string-face ((t (:foreground "#FFEE99"))))
	(font-lock-type-face ((t (:foreground "#66D9EF"))))
	(font-lock-comment-face ((t (:foreground "#8C8C8C"))))
	(font-lock-variable-name-face ((t (:foreground "#F8F8F2"))))
	(font-lock-comment-delimiter-face ((t (:foreground "#8C8C8C"))))
	(font-lock-doc-face ((t (:foreground "#8C8C8C"))))
	(font-lock-keyword-face ((t (:foreground "#66D9EF"))))
	(font-lock-constant-face ((t (:foreground "#FF80F4"))))
	(font-lock-preprocessor-face ((t (:foreground "#66D9EF"))))
	(font-lock-doc-string-face ((t (:foreground "#8C8C8C"))))
	(font-lock-builtin-face ((t (:foreground "#A6E22E"))))
	(font-lock-function-name-face ((t (:foreground "#A6E22E"))))
)))
