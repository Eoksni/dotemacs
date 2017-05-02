(add-to-list 'load-path (concat user-emacs-directory "ctable-git/"))
(add-to-list 'load-path (concat user-emacs-directory "benchmark-init-git/"))
(with-libraries 'ctable
                'benchmark-init
                (progn 
                  (benchmark-init/install)
                  (message "init.el: benchmark started")
                  ))

(provide 'dmaz-benchmark-init)
