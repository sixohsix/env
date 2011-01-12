;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;COMMON STUFF;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar abl-mode nil
  "Mode variable for abl-mode")
(make-variable-buffer-local 'abl-mode)

(defun abl-mode (&optional arg)
  "abl minor mode"
  (interactive "P")
  (setq abl-mode (if (null arg) (not abl-mode)
		   (> (prefix-numeric-value arg) 0)))
  (condition-case err
      (if abl-mode
	  (message (concat "Current branch: "
			   (setq current-abl-branch (find-current-branch-name)))))
    (error (progn
	     (message (error-message-string err))
	     (setq abl-mode nil)))))

(defun ends-with (str1 str2)
  (let ((str1-length (length str1)))
    (string= (substring str1 (- str1-length (length str2)) str1-length) str2)))

(defun abl-mode-hook ()
  (if (ends-with (buffer-file-name) ".py")
      (condition-case err
	  (progn
	    (find-current-branch-name)
	    (abl-mode))
	(error nil))
    nil))

(if (not (assq 'abl-mode minor-mode-alist))
    (setq minor-mode-alist
	  (cons '(abl-mode " abl-mode")
		minor-mode-alist)))

(add-hook 'find-file-hooks 'abl-mode-hook)

(defvar abl-mode-keymap
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c r") 'run-current-branch)
    (define-key map (kbd "C-c t") 'run-test-at-point)
    (define-key map (kbd "C-c u") 'rerun-last-test)
    map)
  "The keymap")

(or (assoc 'abl-mode minor-mode-map-alist)
    (setq minor-mode-map-alist
          (cons (cons 'abl-mode abl-mode-keymap)
                minor-mode-map-alist)))

(defvar expected-projects-base-path "/home/%s/projects/ableton"
  "The directory in which the branches reside")

(defvar vem-command "vem_activate"
  "The command for activating a virtual environment")

(defvar nose-command "nosetests -s"
  "The command for running tests")

(defvar current-abl-branch "trunk"
  "The branch you are working on")
(make-variable-buffer-local 'current-abl-branch)

(defvar branch-shell-prefix "ABL-SHELL:"
  "Prefix for the shell buffers opened")

(defvar last-test-run nil
  "Last test run and which branch it was")

(defvar existing-shells '())

(defun get-current-branch-base ()
  (concat (format expected-projects-base-path (getenv "USER")) "/" current-abl-branch))

(defun starts-with (str1 str2)
  (string= str2
      (substring str1 0 (length str2))))

(defun index-of (substr str1)
  (cond ((< (length str1) (length substr)) nil)
	((string= substr (substring str1 0 (length substr))) 0)
	(t (let ((rest-return (index-of substr (substring str1 1 (length str1)))))
	     (if (null rest-return) nil
	       (+ rest-return 1))))))


(defun find-current-branch-name ()
  "Find the valid branch using the path of the current file."
  (let ((projects-base (format expected-projects-base-path (getenv "USER")))
	(buffer-path (buffer-file-name)))
    (if (not buffer-path) (error (buffer-name)))
    (if (not (starts-with buffer-path projects-base))
	(error "You are not in a buffer in a branch directory; cannot determine branch")
      (let ((rest-string (substring buffer-path (+ (length projects-base) 1) (length buffer-path))))
	(substring rest-string 0 (index-of "/" rest-string ))))))


(defun create-or-switch-to-branch-shell ()
  (let ((shell-name (concat branch-shell-prefix (find-current-branch-name)))
	(cd-command (concat "cd " (get-current-branch-base)))
	(activate-command (concat vem-command " " current-abl-branch)))
    (shell shell-name)
    (if (member shell-name existing-shells)
	nil
      (progn
	(run-shell-command cd-command shell-name)
	(run-shell-command activate-command shell-name)
	(setf existing-shells (append existing-shells '(shell-name)))))
    shell-name))


(defun run-shell-command (command buffer-name)
  (process-send-string buffer-name
		       (concat command "\n")))

(defun run-shell-command-for-branch (command branch-name)
  (save-excursion
    (let ((shell-name (concat branch-shell-prefix branch-name)))
      (if (not (member shell-name existing-shells))
	  (create-or-switch-to-branch-shell))
      (run-shell-command command shell-name))))

(defun run-command-for-current-abl-branch (command)
  (run-shell-command-for-branch command (find-current-branch-name)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;RUNNING SERVER AND TESTS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun run-current-branch ()
  (interactive)
  (run-command-for-current-abl-branch (concat "cd " (get-current-branch-base)))
  (run-command-for-current-abl-branch "scripts/run.sh"))


(defun determine-test-function-name ()
  (save-excursion
    (end-of-line)
    (if (not (re-search-backward "^ *def *" nil t))
	(error "Looks like you are not even in a function definiton! Bad girl!"))
    (let* ((start (re-search-forward "^ *def *"))
	   (end (re-search-forward "test_[^\(]*" (line-end-position) t)))
      (if (not end)
	  (error "Looks like you are not inside a test function. Go to a test function! Now!")
	(buffer-substring-no-properties start (point))))))


(defun determine-test-class-name ()
  (save-excursion
    (if (not (re-search-backward "^class *" nil t))
	(error "Looks like there is a problem with your python code (functions is indented
but not in a class). Sorry, can't do anything")
    (let* ((start (re-search-forward "^class *"))
	   (end (re-search-forward "[^\(:]*" (line-end-position) t)))
      (if (not end)
	  (error "Looks like there is a problem with you python code (keyword class not
followed by a proper class name).")
	(buffer-substring-no-properties start (point)))))))


;;this function assumes that you are already in a test function (see
;;the function above)
(defun test-in-class ()
  (save-excursion
    (end-of-line)
    (let* ((start (re-search-backward "^ *def *"))
	   (end (re-search-forward "[^ ]")))
      (> (- end start 1) 0))))


(defun get-test-file-path ()
  (let ((buffer-name (buffer-file-name)))
    (if (not (ends-with buffer-name ".py"))
	(error "You do not appear to be in a python file. Now open a python file!"))
    (let ((relative-path (substring
			  buffer-name
			  (+ (index-of current-abl-branch buffer-name)
			     (length current-abl-branch) 1)
			  (- (length buffer-name) 3))))
      (replace-regexp-in-string "/" "." relative-path))))


(defun get-test-function-path (file-path)
  (let ((function-name (determine-test-function-name)))
    (if (not (test-in-class))
	(concat file-path ":" function-name)
      (let ((class-name (determine-test-class-name)))
	(concat file-path ":" class-name "." function-name)))))


(defun run-test (test-path &optional branch-name)
  (let ((shell-command (concat nose-command " " test-path))
	(real-branch-name (or branch-name (find-current-branch-name))))
    (message (concat "Running test: " test-path))
    (run-shell-command-for-branch shell-command real-branch-name)
    (setq last-test-run (cons test-path (find-current-branch-name)))))


;This returns the python destination on point, depending on
;whether it is a test function, class, or whole file
(defun get-test-entity ()
  (let ((file-path (get-test-file-path)))
    (if (= (line-number-at-pos) 1)
	file-path
      (let* ((test-func-pos
	      (save-excursion
		(re-search-backward "^ *def test*" nil t)))
	     (test-class-pos
	      (save-excursion
		(re-search-backward "^class *" nil t))))
	(cond
	 ((not (or test-func-pos test-class-pos))
	  (error "You are neither in a test class nor a test function."))
	 (test-func-pos (if (or (not test-class-pos)
				(< test-class-pos test-func-pos))
			    (get-test-function-path file-path)))
	 (test-class-pos (concat file-path ":" (determine-test-class-name))))))))

(defun run-test-at-point ()
  (interactive)
  (let* ((test-path (get-test-entity)))
    (message (concat "Running test: " test-path))
    (run-test test-path)))

(defun rerun-last-test ()
  (interactive)
  (if (not last-test-run)
      (message "You haven't run any tests yet.")
    (run-test (car last-test-run) (cdr last-test-run))))

(provide 'abl)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;IMPORTANT TODOS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; - If the cursor is at a class line when run-test is called, run the
;;   class. If it is at the beginning, run the whole file
;;
;; - Shell processes should be able to handle errors, and know when a
;;   shell buffer is occupied.
;;
;; - Check if a virtual env with the name of the branch exists; if not, ask the user for the name
;;   of the virtual env
;;
;; - When the cursor is in an inner function inside a test, it should still run?
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;OTHER TODOS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; - Fetch and parse the results of a test run
;;
;; - Opening all the buffers in a different branch
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;