(put 'emerge-buffers                     'disabled "It's better to use `ediff-*` alternatives instead, because ediff is a successor of emerge.")
(put 'emerge-buffers-with-ancestor       'disabled "It's better to use `ediff-*` alternatives instead, because ediff is a successor of emerge.")
(put 'emerge-files                       'disabled "It's better to use `ediff-*` alternatives instead, because ediff is a successor of emerge.")
(put 'emerge-files-command               'disabled "It's better to use `ediff-*` alternatives instead, because ediff is a successor of emerge.")
(put 'emerge-files-remote                'disabled "It's better to use `ediff-*` alternatives instead, because ediff is a successor of emerge.")
(put 'emerge-files-with-ancestor         'disabled "It's better to use `ediff-*` alternatives instead, because ediff is a successor of emerge.")
(put 'emerge-files-with-ancestor-command 'disabled "It's better to use `ediff-*` alternatives instead, because ediff is a successor of emerge.")
(put 'emerge-files-with-ancestor-remote  'disabled "It's better to use `ediff-*` alternatives instead, because ediff is a successor of emerge.")
(put 'emerge-merge-directories           'disabled "It's better to use `ediff-*` alternatives instead, because ediff is a successor of emerge.")
(put 'emerge-revisions                   'disabled "It's better to use `ediff-*` alternatives instead, because ediff is a successor of emerge.")
(put 'emerge-revisions-with-ancestor     'disabled "It's better to use `ediff-*` alternatives instead, because ediff is a successor of emerge.")

(put 'downcase-region 'disabled nil)

(put 'term 'disabled "Does not work on MS Windows")
(put 'ansi-term 'disabled "Does not work on MS Windows")

(defadvice kill-new (before kill-new-push-xselection-on-kill-ring activate)
  "Before putting new kill onto the kill-ring, add the clipboard/external selection to the kill ring"
  (let ((have-paste (and interprogram-paste-function
                         (funcall interprogram-paste-function))))
    (when have-paste (push have-paste kill-ring))))

(provide 'dmaz-general-config)
