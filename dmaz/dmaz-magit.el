(use-package magit
  :defer 10
  :bind (:map dmaz-ctl-x-map
	      ("g" . magit-status)))

(provide 'dmaz-magit)
