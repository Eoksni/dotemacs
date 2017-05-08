(use-package magit
  :defer 10
  :bind (:map dmaz-ctl-x-map
	      ("g" . magit-status))
  :config
  (add-to-list 'git-commit-mode-hook #'git-commit-insert-issue-mode))

(provide 'dmaz-magit)
