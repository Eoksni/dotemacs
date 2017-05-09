;;; package --- Summary
;;; Commentary:
;;; Code:

(require 'custom)
(require 'cus-edit)

(defadvice custom-handle-keyword (around dmaz-custom-handle-keyword activate)
  "Used to set custom keywords in Easy Customize system."
  (if (eq type 'custom-variable)
      (cond ((eq keyword :dmaz-custom-actual-set)
             (put symbol 'dmaz-custom-actual-set value))
            ((eq keyword :dmaz-custom-check)
             (put symbol 'dmaz-custom-check value))
            (t
             ad-do-it))
    ad-do-it))

(defgroup dmaz nil
  "Dmaz custom variables.")
(defgroup dmaz-paths nil
  "Dmaz custom variables for paths. Usually only this is needed
  to be customized for the new computer."
  :group 'dmaz)

(defun dmaz-display-debug (message &rest args)
  "Display a debug message made from (format MESSAGE ARGS...).
Aside from generating the message with `format',
this is equivalent to `display-warning', using
`emacs' as the type and `:debug' as the level."
  (display-warning 'emacs (apply 'format message args) :debug))

(defun dmaz-add-vars-from-group-to-list (group-name list-name)
  (dolist (element (custom-group-members group-name nil))
    (if (eq (nth 1 element) 'custom-group)
        (dmaz-add-vars-from-group-to-list (nth 0 element) list-name)
      (if (eq (nth 1 element) 'custom-variable)
          (add-to-list list-name (nth 0 element))))))

(defun dmaz-custom-set-all-variables ()
  (let (dmaz--members)
    (dmaz-add-vars-from-group-to-list 'dmaz 'dmaz--members)
    (dolist (element dmaz--members)
      (let ((setfun (get element 'custom-set)))
        (if setfun
            (funcall setfun element (symbol-value element)))))))

(defun dmaz-custom-check-dir (option-name new-value)
  (if (stringp new-value)
      (if (file-directory-p new-value)
          (if (file-accessible-directory-p new-value)
              t
            (warn "Files in directory %s corresponding to %s are not accessible" new-value option-name)
            nil)
        (warn "Value %s of variable %s does not correspond to existing directory" new-value option-name)
        nil)
    (warn "Value %s of variable %s is not a path to directory (not a string)" new-value option-name)
    nil))

(defun dmaz-custom-check-file-with-creation (option-name new-value)
  (if (stringp new-value)
      (progn
        (unless (file-exists-p new-value)
          (with-temp-buffer
            (write-file new-value)))
        (if (file-exists-p new-value)
            (if (file-readable-p new-value)
                (if (file-writable-p new-value)
                    t
                  (warn "File %s corresponding to %s is not writable file" new-value option-name)
                  nil)
              (warn "Value %s of variable %s is not a readable file" new-value option-name)
              nil)
          (warn "File %s corresponding to %s does not exist and couldn't be created.")
          nil))
    (warn "Value %s of variable %s is not a path to directory (not a string)" new-value option-name)
    nil))

(defun dmaz-custom-check-list-of-dirpairs (option-name new-value)
  (let ((res t))
    (if (listp new-value)
        (dolist (element new-value)
          (unless (dmaz-custom-check-dir option-name (car element))
            (setq res nil))
          (unless (dmaz-custom-check-dir option-name (cdr element))
            (setq res nil)))
      (warn "Value %s of variable %s is not a list" new-value option-name)
      (setq res nil))
    res))

(defun dmaz-custom-set-eoksni-dir (option-name new-value)
  (when (eq option-name 'dmaz-path-to-eoksni-dir)
    (eval-after-load 'dmaz-orgmode-init
      `(dmaz-org-setup-eoksni-dir))))

(defun dmaz-custom-set-onedrive-dir (option-name new-value)
  (when (eq option-name 'dmaz-path-to-onedrive-dir)
    (eval-after-load 'dmaz-orgmode-init
      `(dmaz-org-setup-onedrive-dir))))

(defun dmaz-custom-set-dropbox-dir (option-name new-value)
  (when (eq option-name 'dmaz-path-to-dropbox-dir)
    (eval-after-load 'dmaz-orgmode-init
      `(dmaz-org-setup-dropbox-dir))))

(defun dmaz-custom-set-dictionary-dir (option-name new-value)
  (when (eq option-name 'dmaz-path-to-dictionary-dir)
    (setenv "DICPATH" new-value)))

(defun dmaz-custom-actual-set-font (option-name new-value)
  (when (eq option-name 'dmaz-font-string)
    (set-frame-font new-value)
    (add-to-list 'default-frame-alist
                 `(font . ,new-value))))

(defun dmaz-custom-check-font (option-name new-value)
  (if (stringp new-value)
      (if (ignore-errors (font-info new-value))
          t
        (warn "Value %s of variable %s does not correspond to existing font" new-value option-name)
        t)
    (warn "Value %s of variable %s is not a font (not a string)" new-value option-name)
    t))

(defun dmaz-custom-set (option-name new-value)
  (unless (and (boundp 'dmaz--initing) dmaz--initing)
    (let ((checkfun (get option-name 'dmaz-custom-check))
          (setfun (get option-name 'dmaz-custom-actual-set)))
      (when (not checkfun)
        (dmaz-display-debug "No property `dmaz-custom-check' for variable %s" option-name)
        (set 'checkfun '(lambda (&rest args) t)))
      (if (funcall checkfun option-name new-value)
          (if setfun
              (funcall setfun option-name new-value)))))
  (set-default option-name new-value))

(defcustom dmaz-path-to-eoksni-dir
  (getenv "DMAZCFG_EOKSNI_DIR")
  "Path to Eoksni root directory. Note that this is set up
using environment variable `DMAZCFG_EOKSNI_DIR'"
  :type 'directory
  :set 'dmaz-custom-set
  :dmaz-custom-check 'dmaz-custom-check-dir
  :dmaz-custom-actual-set 'dmaz-custom-set-eoksni-dir
  :group 'dmaz-paths)

(defcustom dmaz-path-to-onedrive-dir
  (getenv "DMAZCFG_ONEDRIVE_DIR")
  "Path to Onedrive root directory. Note that this is set up
using environment variable `DMAZCFG_ONEDRIVE_DIR'"
  :type 'directory
  :set 'dmaz-custom-set
  :dmaz-custom-check 'dmaz-custom-check-dir
  :dmaz-custom-actual-set 'dmaz-custom-set-onedrive-dir
  :group 'dmaz-paths)

(defcustom dmaz-path-to-dropbox-dir
  (getenv "DMAZCFG_DROPBOX_DIR")
  "Path to Dropbox root directory. Note that this is set up
using environment variable `DMAZCFG_DROPBOX_DIR'"
  :type 'directory
  :set 'dmaz-custom-set
  :dmaz-custom-check 'dmaz-custom-check-dir
  :dmaz-custom-actual-set 'dmaz-custom-set-dropbox-dir
  :group 'dmaz-paths)

(defcustom dmaz-path-to-dictionary-dir
  (getenv "DICPATH")
  "Path to Hunspell dictonary directory. Note that this is set up
using environment variable `DICPATH'"
  :type 'directory
  :set 'dmaz-custom-set
  :dmaz-custom-check 'dmaz-custom-check-dir
  :dmaz-custom-actual-set 'dmaz-custom-set-dictionary-dir
  :group 'dmaz-paths)

(defcustom dmaz-packages (list)
  "A list of packages to ensure are installed at launch."
  :type '(repeat symbol)
  :group 'dmaz)

(defcustom dmaz-mouse-button-prev-buffer
  "<mouse-4>"
  "String for `kbd' to bind `previous-buffer' to"
  :type 'string
  :group 'dmaz-paths)

(defcustom dmaz-mouse-button-next-buffer
  "<mouse-5>"
  "String for `kbd' to bind `next-buffer' to"
  :type 'string
  :group 'dmaz-paths)

(defcustom dmaz-mouse-button-wheel-forward
  "<wheel-up>"
  "String for `kbd' to identify button for mouse wheel up"
  :type 'string
  :group 'dmaz-paths)

(defcustom dmaz-mouse-button-wheel-backward
  "<wheel-down>"
  "String for `kbd' to identify button for mouse wheel down"
  :type 'string
  :group 'dmaz-paths)

(defcustom dmaz-open-output
  (cond
   ((eq system-type 'windows-nt) "start")
   ((eq system-type 'darwin) "open")
   ((eq system-type 'gnu/linux) "xdg-open"))
  "String command to open file in external app"
  :type 'string
  :group 'dmaz-paths)

(defcustom dmaz-browser-command nil "String with execution
command to launch web-browser. It is safe to be `nil'."
  :group 'dmaz-paths)

(defcustom dmaz-keys-exclude-modes (list) "List of SYMBOLS of major modes where there is no need for `dmaz-keys-minor-mode`"
  :group 'dmaz
  :type '(repeat symbol))

(defcustom dmaz-lines-to-jump 6 "Number of lines to jump over with little scroll."
  :type 'integer
  :group 'dmaz)

(defcustom dmaz-font-string
  (if (ignore-errors (font-info "Ubuntu Mono-14"))
      "Ubuntu Mono-14"
    (if (ignore-errors (font-info "Consolas-13"))
        "Consolas-13"
      "Consolas-13"))
  "Font string for setting default font"
  :group 'dmaz
  :type 'string
  :set 'dmaz-custom-set
  :dmaz-custom-actual-set 'dmaz-custom-actual-set-font
  :dmaz-custom-check 'dmaz-custom-check-font)

(defvar dmaz-user-dir nil)

(provide 'dmaz-variables)
;;; dmaz-variables.el ends here
