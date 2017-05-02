(require 'dmaz-customize)

;; load packages, dont yet activate them
(package-initialize t)

(when (not package-archive-contents)
  (package-refresh-contents))
(dolist (p dmaz-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; after installing all necessary ones, activate all
(package-initialize)

(provide 'dmaz-package)
