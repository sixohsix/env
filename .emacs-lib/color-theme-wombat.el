; http://coderchrome.org/10

(eval-when-compile (require 'color-theme))

(defun color-theme-wombat ()
	(interactive)
	(color-theme-install '(color-theme-wombat 
	(
		(foreground-color . "#f6f3e8")
		(background-color . "#242424")
	)
	(font-lock-string-face ((t (:foreground "#95e454"))))
	(font-lock-type-face ((t (:foreground "#cae682"))))
	(font-lock-comment-face ((t (:foreground "#99968b"))))
	(font-lock-variable-name-face ((t (:foreground "#f6f3e8"))))
	(font-lock-comment-delimiter-face ((t (:foreground "#99968b"))))
	(font-lock-doc-face ((t (:foreground "#99968b"))))
	(font-lock-keyword-face ((t (:foreground "#8ac6f2"))))
	(font-lock-constant-face ((t (:foreground "#e5786d"))))
	(font-lock-preprocessor-face ((t (:foreground "#e5786d"))))
	(font-lock-doc-string-face ((t (:foreground "#99968b"))))
	(font-lock-builtin-face ((t (:foreground "#cae682"))))
	(font-lock-function-name-face ((t (:foreground "#cae682"))))
)))
