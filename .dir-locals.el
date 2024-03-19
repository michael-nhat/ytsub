
;; sample , remove of quote
((nil . ((eval . (ignore-errors (progn
                    (message "Evaluated result:%s %s" 'wtf (buffer-name (current-buffer)))
                    (message "end: %s %s" projectile-project-run-cmd-1 (buffer-name (current-buffer)))
                    )))
         (projectile-project-run-cmd-1 . (lambda ()
                                           (let ((compilation-always-kill t)
                                                 (compilation-read-command nil))
                                             (compile "ls -la" t)
                                             (hack-dir-local-variables-non-file-buffer))))
         (
          projectile-project-run-cmd-3 .
          (lambda ()
            (require 'vterm)
            (let ((buffer-name "*vterm--ytsearch.github.io*")
                  (pre-current-window (selected-window))
                  (my-pre-buffer (current-buffer))
                  (shell-cmd "npm run start"))
              (if (not (get-buffer buffer-name))
                  (progn
                    (generate-new-buffer buffer-name)
                    (switch-to-buffer buffer-name)
                    (defun eval-file (file)
                      "Execute FILE and return the result of the last expression."
                      (ignore-errors
                        (read-from-whole-string
                         (with-temp-buffer
                           (insert-file-contents file)
                           (buffer-string)))))
                    (defun evaluate-dir-locals (project-root)
                      (let* ((dir-locals-file (expand-file-name ".dir-locals.el" project-root)))
                        (when (file-exists-p dir-locals-file)
                          (eval-file dir-locals-file))))
                    (let* ((project-root (projectile-project-root))
                           (r2 (evaluate-dir-locals project-root))
                           (r1 (cdr (car (cdr (car r2))))))
                      (if r1
                          (progn
                            (message "Evaluated result:%s %s" r1 (buffer-name (current-buffer)))
                            (eval r1))
                        (message "No eval expression found in .dir-locals.el")))
                    (vterm-mode)
                    (hack-dir-local-variables-non-file-buffer)
                    (sit-for 1)
                    (switch-to-buffer my-pre-buffer)))
              (pop-to-buffer buffer-name)
              (vterm-send-key (kbd "C-c"))
              ;; error send ls while send C-c
              (vterm-send-key (kbd "SPC"))
              ;; create nh-vterm-send-string
              ;; activate first
              (message shell-cmd)
              (vterm-send-string (concat shell-cmd "\n"))
              ;; (vterm-send-string "python setup.py sdist bdist_wheel")
              (select-window pre-current-window)
              ))
          )
         (
          projectile-project-run-cmd-2 .
          (lambda ()
            (save-current-buffer
              (let ((compilation-buffer-name-function
                     (lambda (_mode)
                       "*complation--ytsearch.github.io*"))
                    (compilation-always-kill t) (compilation-read-command nil))
                (set-buffer (compile "ls -la" t))
                (hack-dir-local-variables-non-file-buffer))))
          )
         (
          projectile-project-run-cmd-4
          (lambda ()
            (save-current-buffer
              (let ((nh-compi--hide-in-background t)
                    (compilation-buffer-name-function
                     (lambda (_mode)
                       "*complation--ytsearch.github.io*"))
                    (compilation-always-kill t) (compilation-read-command nil)
                    (default-directory (projectile-project-root))
                    )
                ;; (compile "mvn compiler:compile -am -o -N" t)
                (shell-command "echo k >> ./src/main/resources/.reloadtrigger"))))
          )
         )))
