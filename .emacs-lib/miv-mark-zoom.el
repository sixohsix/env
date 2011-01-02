
;; Use s-[ and s-] like forwards and back between previous marks

(defun push-mark-and-jump-to-beginning-of-buffer ()
  "Pushes `point' to `mark-ring' and does not activate the region
Equivalent to \\[set-mark-command] when \\[transient-mark-mode] is disabled"
  (interactive)
  (push-mark (point) t nil)
  (beginning-of-buffer)
  (message "Pushed mark to ring")
  )
(global-set-key (kbd "s-]") 'push-mark-and-jump-to-beginning-of-buffer)

(defun jump-to-mark ()
  "Jumps to the local mark, respecting the `mark-ring' order.
This is the same as using \\[set-mark-command] with the prefix argument."
  (interactive)
  (set-mark-command 1)
  )
(global-set-key (kbd "s-[") 'jump-to-mark)

(provide 'miv-mark-zoom)
