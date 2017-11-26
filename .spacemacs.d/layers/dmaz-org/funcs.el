(when (configuration-layer/package-usedp 'org)
  (defun dmaz-org/clock-in-hook ()
    (pcase org-clock-current-task
     ("Drill it, Drill it!" (org-drill))
     ("Зарядка утром" (dmaz/start-exercise))
     ("Зарядка днем" (dmaz/start-exercise))
     ("Зарядка вечером" (dmaz/start-exercise))
     ("Потренировать голос" (dmaz/start-exercise))
     ("решить катку перед работой" (dmaz/open-in-external-app "http://codewars.com"))
     ("datacamp daily practice" (dmaz/open-in-external-app "https://www.codewars.com/kata/search/my-languages?q=&r%5B%5D=-6&r%5B%5D=-5&xids=played&beta=false&order_by=satisfaction_percent+desc%2Ctotal_completed+desc"))
     )
    )

  (defun dmaz-org/notify-convert-scheduled (orig)
    "Convert original scheduled from `org-element-parse-buffer' to
simple timestamp string."
    (if (and orig (plist-get (plist-get orig 'timestamp)
                             :hour-start))
        (replace-regexp-in-string "^<\\|>$" ""
                                  (plist-get (plist-get orig 'timestamp)
                                             :raw-value))))

  (defun dmaz-org/setup-eoksni-dir ()
    (add-to-list 'org-agenda-files (dmaz/joindirs dmaz/eoksni-dir "notes"))
    ;; (add-to-list 'org-agenda-files dmaz-org/work-agenda-file)
    )

  (defun dmaz-org/setup-dropbox-dir ()
    ;; (setq org-directory (dmaz/joindirs (file-name-as-directory dmaz/dropbox-dir) "notes"))
    ;; (add-to-list 'org-agenda-files org-directory)
    ;; (add-to-list 'org-agenda-files (dmaz/joindirs org-directory "work"))
    ;; (add-to-list 'org-agenda-files (dmaz/joindirs org-directory "life"))
    ;; ;; (add-to-list 'org-agenda-files (dmaz/joindirs org-directory "main.org"))
    ;; (setq org-default-notes-file (dmaz/joindirs org-directory "main.org"))
    )

  (defun dmaz-org/setup-syncthing-dir ()
    (setq org-directory (dmaz/joindirs (file-name-as-directory dmaz/syncthing-dir) "notes"))
    (add-to-list 'org-agenda-files org-directory)
    (add-to-list 'org-agenda-files (dmaz/joindirs org-directory "work"))
    (add-to-list 'org-agenda-files (dmaz/joindirs org-directory "life"))
    (setq org-default-notes-file (dmaz/joindirs org-directory "main.org")))

  (defun dmaz-org/clock-in-to-started (kw)
    "Switch task from TODO or NEXT to STARTED when clocking in.
Skips capture tasks."
    (if (and (member (org-get-todo-state) (list "TODO" "NEXT"))
             (not (and (boundp 'org-capture-mode) org-capture-mode)))
        "STARTED"))

  (defun dmaz-org/agenda-sort (a b)
    "Sorting strategy for agenda items.
;; Late deadlines first, then scheduled, then non-late deadlines"
    (let (result num-a num-b)
      (cond
                                        ; time specific items are already sorted first by org-agenda-sorting-strategy

                                        ; late deadlines
       ((dmaz-org/agenda-sort-test-num 'dmaz-org/is-late-deadline '< a b))

                                        ; deadlines for today
       ((dmaz-org/agenda-sort-test 'dmaz-org/is-due-deadline a b))

                                        ; pending deadlines
       ((dmaz-org/agenda-sort-test-num 'dmaz-org/is-pending-deadline '< a b))

                                        ; late scheduled items
       ((dmaz-org/agenda-sort-test-num 'dmaz-org/is-scheduled-late '> a b))

                                        ; scheduled items for today
       ((dmaz-org/agenda-sort-test 'dmaz-org/is-scheduled-today a b))

                                        ; non-deadline and non-scheduled items
       ((dmaz-org/agenda-sort-test 'dmaz-org/is-not-scheduled-or-deadline a b))

                                        ; finally default to unsorted
       (t (setq result nil))
       )
      result))

  (defmacro dmaz-org/agenda-sort-test (fn a b)
    "Test for agenda sort"
    `(cond
                                        ; if both match leave them unsorted
      ((and (apply ,fn (list ,a))
            (apply ,fn (list ,b)))
       (setq result nil))
                                        ; if a matches put a first
      ((apply ,fn (list ,a))
                                        ; if b also matches leave unsorted
       (if (apply ,fn (list ,b))
           (setq result nil)
         (setq result -1)))
                                        ; otherwise if b matches put b first
      ((apply ,fn (list ,b))
       (setq result 1))
                                        ; if none match leave them unsorted
      (t nil)))

  (defmacro dmaz-org/agenda-sort-test-num (fn compfn a b)
    `(cond
      ((apply ,fn (list ,a))
       (setq num-a (string-to-number (match-string 1 ,a)))
       (if (apply ,fn (list ,b))
           (progn
             (setq num-b (string-to-number (match-string 1 ,b)))
             (setq result (if (apply ,compfn (list num-a num-b))
                              -1
                            1)))
         (setq result -1)))
      ((apply ,fn (list ,b))
       (setq result 1))
      (t nil)))

  (defun dmaz-org/is-not-scheduled-or-deadline (date-str)
    (and (not (dmaz-org/is-deadline date-str))
         (not (dmaz-org/is-scheduled date-str))))

  (defun dmaz-org/is-due-deadline (date-str)
    (string-match "Deadline:" date-str))

  (defun dmaz-org/is-late-deadline (date-str)
    (string-match "In *\\(-.*\\)d\.:" date-str))

  (defun dmaz-org/is-pending-deadline (date-str)
    (string-match "In \\([^-]*\\)d\.:" date-str))

  (defun dmaz-org/is-deadline (date-str)
    (or (dmaz-org/is-due-deadline date-str)
        (dmaz-org/is-late-deadline date-str)
        (dmaz-org/is-pending-deadline date-str)))

  (defun dmaz-org/is-scheduled (date-str)
    (or (dmaz-org/is-scheduled-today date-str)
        (dmaz-org/is-scheduled-late date-str)))

  (defun dmaz-org/is-scheduled-today (date-str)
    t)

  (defun dmaz-org/is-scheduled-late (date-str)
    (string-match "Sched\.\\(.*\\)x:" date-str))

  (defun dmaz-org/agenda-skip-scheduled-if-not-today ()
    "If this function returns nil, the current match should not be skipped.
Otherwise, the function must return a position from where the search
should be continued."
    (ignore-errors
      (let ((subtree-end (save-excursion (org-end-of-subtree t)))
            (scheduled-day
             (time-to-days
              (org-time-string-to-time
               (org-entry-get nil "SCHEDULED"))))
            (now (time-to-days (current-time))))
        (and scheduled-day
             (not (= scheduled-day now))
             subtree-end))))

  (defun dmaz-org/agenda-skip-scheduled-if-hour ()
    "If this function returns nil, the current match should not be skipped.
Otherwise, the function must return a position from where the search
should be continued."
    (let (beg
          end
          (regexp (concat "\\<" org-scheduled-string
                          " *<\\([^>]+[0-9]\\{1,2\\}:[0-9]\\{2\\}[0-9-+:/hdwmy \t.]*\\)>")))
      (org-back-to-heading t)
      (setq beg (point)
            end (progn (outline-next-heading) (1- (point))))
      (goto-char beg)
      (and
       (re-search-forward regexp end t)
       end)))

  (defun dmaz-org/finalize-agenda-hook ()
    ;; remove mouse highlight - performance
    (remove-text-properties
     (point-min) (point-max) '(mouse-face t))
    (dmaz-org/apply-auto-exclude))

  (defun dmaz-org/time-to-days--respect-org-extend-today-until (orig-fun time &rest args)
    (let* ((decoded (decode-time time))
           (sec (nth 0 decoded))
           (min (nth 1 decoded))
           (hour (nth 2 decoded))
           (res (apply orig-fun time args)))
      (if (or (>= hour org-extend-today-until) (and (= sec min hour 0)))
          res
        (- res 1))))

  (defun dmaz-org/habit-parse-todo--respect-org-extend-today-until (orig-fun &rest args)
    (advice-add 'time-to-days :around #'dmaz-org/time-to-days--respect-org-extend-today-until)
    (let ((res (apply orig-fun args)))
      (advice-remove 'time-to-days #'dmaz-org/time-to-days--respect-org-extend-today-until)
      res))

  (defun dmaz-org/auto-exclude-function (tag)
    ;; t if want to exclude
    (and (cond
          ((string= tag "drill") t)
          ((string= tag "loud")
           (let ((hour (nth 2 (decode-time))))
             (or (< hour 9) (>= hour 22))))
          ((string= tag "daytime")
           (let ((hour (nth 2 (decode-time))))
             (or (< hour 9) (> hour 19)))))
         (concat "-" tag)))

  (defun dmaz-org/apply-auto-exclude ()
    (interactive)
    (when (and (not dmaz-org/apply-auto-exclude--applied) org-agenda-auto-exclude-function)
      (setq dmaz-org/apply-auto-exclude--applied t)
      (org-agenda-filter-show-all-tag)
      (setq org-agenda-tag-filter nil)
      (dolist (tag (org-agenda-get-represented-tags))
        (let ((modifier (funcall org-agenda-auto-exclude-function tag)))
          (if modifier
              (push modifier org-agenda-tag-filter))))
      (if (not (null org-agenda-tag-filter))
          (org-agenda-filter-apply org-agenda-tag-filter 'tag nil))))

  (defun dmaz-org/matcher-time--respect-org-extend-today-until (time)
    (let* ((decoded (decode-time time))
           (sec (nth 0 decoded))
           (min (nth 1 decoded))
           (hour (nth 2 decoded)))
      (if (= 0 sec min hour)
          (float-time (encode-time sec min (+ org-extend-today-until hour) (nth 3 decoded) (nth 4 decoded) (nth 5 decoded)))
        time)))
  (defun dmaz-org/buy-list ()
    (interactive)
    (org-tags-view t "buy")
    )

  (defun dmaz-org/clock-get-clocktable--respect-org-extend-today-until (orig-fun &rest args)
    (advice-add 'org-matcher-time :filter-return #'dmaz-org/matcher-time--respect-org-extend-today-until)
    (let ((res (apply orig-fun args)))
      (advice-remove 'org-matcher-time #'dmaz-org/matcher-time--respect-org-extend-today-until)
      res))

  (defun dmaz-org/matcher-time--from-scram-to-scram (time)
    (let* ((decoded (decode-time time))
           (sec (nth 0 decoded))
           (min (nth 1 decoded))
           (hour (nth 2 decoded)))
      (if (= 0 sec min hour)
          (float-time (encode-time sec min (+ 17 hour) (nth 3 decoded) (nth 4 decoded) (nth 5 decoded)))
        time)))

  (defun dmaz-org/clockreport (clocktable-start clocktable-end)
    (interactive "sFrom time (default \"-1d\"): \nsTo time (default \"today\"): ")
    (when (equal clocktable-start "") (setq clocktable-start "-1d"))
    (setq clocktable-start (format "<%s>" clocktable-start))
    (when (equal clocktable-end "") (setq clocktable-end "today"))
    (setq clocktable-end (format "<%s>" clocktable-end))
    (let ((org-agenda-files (org-agenda-files nil 'ifmode))
          (p (copy-sequence org-agenda-clockreport-parameter-plist))
          tbl)
      (setq p (org-plist-delete p :block))
      (setq p (plist-put p :tstart clocktable-start))
      (setq p (plist-put p :tend clocktable-end))
      (setq p (plist-put p :scope 'agenda))

      (advice-add 'org-matcher-time :filter-return #'dmaz-org/matcher-time--from-scram-to-scram)
      (setq tbl (apply 'org-clock-get-clocktable p))
      (advice-remove 'org-matcher-time #'dmaz-org/matcher-time--from-scram-to-scram)

      (switch-to-buffer-other-window  (generate-new-buffer "*dmaz-org/clockreport*"))
      (insert tbl)))

  (defun dmaz-org/notify-action-notify (plist)
    "Pop up a notification window."
    (dmaz/show-notification (org-notify-body-text plist) (plist-get plist :heading)))

  (defun dmaz-org/notify-make-todo (heading &rest ignored)
    "Replacement for org-notify-make-todo Create one todo item."
    (macrolet ((get (k) `(plist-get list ,k))
               (pr (k v) `(setq result (plist-put result ,k ,v))))
      (let* ((list (nth 1 heading))      (notify (or (get :NOTIFY) "default"))
             (deadline (or (org-notify-convert-deadline (get :deadline)) (dmaz-org/notify-convert-scheduled (get :scheduled))))
             (heading (get :raw-value))
             result)
        (when (and (eq (get :todo-type) 'todo) heading deadline)
          (pr :heading heading)     (pr :notify (intern notify))
          (pr :begin (get :begin))
          (pr :file (nth org-notify-parse-file (org-agenda-files 'unrestricted)))
          (pr :timestamp deadline)  (pr :uid (md5 (concat heading deadline)))
          (pr :deadline (- (org-time-string-to-seconds deadline)
                           (float-time))))
        result))))
