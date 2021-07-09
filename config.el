;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; DO NOT EDIT THIS FILE DIRECTLY
;; This is a file generated from a literate programing source file located at
;; https://gitlab.com/zzamboni/dot-doom/-/blob/master/doom.org
;; You should make any changes there and regenerate it from Emacs org-mode
;; using org-babel-tangle (C-c C-v t)

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
;; (setq user-full-name "John Doe"
;;      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; (setq display-line-numbers-type t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq user-full-name "Diego Zamboni"
      user-mail-address "diego@zzamboni.org")

(cond (IS-MAC
       (setq mac-command-modifier       'meta
             mac-option-modifier        'alt
             mac-right-option-modifier  'alt
             mac-pass-control-to-system nil)))

(setq kill-whole-line t)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

(setq auto-save-default t
      make-backup-files t)

(setq confirm-kill-emacs nil)

(after! auth-source
  (setq auth-sources (nreverse auth-sources)))

(let ((alternatives '("doom-emacs-bw-light.svg"
                      "doom-emacs-flugo-slant_out_purple-small.png"
                      "doom-emacs-flugo-slant_out_bw-small.png")))
  (setq fancy-splash-image
        (concat doom-private-dir "splash/"
                (nth (random (length alternatives)) alternatives))))

(setq +doom-dashboard-menu-sections (cl-subseq +doom-dashboard-menu-sections 0 2))

(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 18)
      ;;doom-variable-pitch-font (font-spec :family "ETBembo" :size 18)
      doom-variable-pitch-font (font-spec :family "Alegreya" :size 18))

(add-hook! 'org-mode-hook #'mixed-pitch-mode)
(add-hook! 'org-mode-hook #'solaire-mode)
(setq mixed-pitch-variable-pitch-cursor nil)

(setq doom-theme 'spacemacs-light)
;;(setq doom-theme 'doom-nord-light) ;;OK
;;NO (setq doom-theme 'doom-solarized-light)
;;(setq doom-theme 'doom-one-light) ;;MAYBE
;;NO (setq doom-theme 'doom-opera-light)
;;NO (setq doom-theme 'doom-tomorrow-day)
;;NO (setq doom-theme 'doom-acario-light)

(custom-set-faces!
  '(doom-dashboard-banner :inherit default)
  '(doom-dashboard-loaded :inherit default))
;;(setq spacemacs-theme-comment-bg nil)

;;(add-hook 'window-setup-hook #'doom/quickload-session)

(setq initial-frame-alist '((top . 1) (left . 1) (width . 129) (height . 37)))
;;(add-to-list 'initial-frame-alist '(maximized))

(plist-put! +ligatures-extra-symbols
  :and           nil
  :or            nil
  :for           nil
  :not           nil
  :true          nil
  :false         nil
  :int           nil
  :float         nil
  :str           nil
  :bool          nil
  :list          nil
)

(setq doom-modeline-enable-word-count t)

(map! "C-x b"   #'counsel-buffer-or-recentf
      "C-x C-b" #'counsel-switch-buffer)

(defun zz/counsel-buffer-or-recentf-candidates ()
  "Return candidates for `counsel-buffer-or-recentf'."
  (require 'recentf)
  (recentf-mode)
  (let ((buffers
         (delq nil
               (mapcar (lambda (b)
                         (when (buffer-file-name b)
                           (abbreviate-file-name (buffer-file-name b))))
                       (delq (current-buffer) (buffer-list))))))
    (append
     buffers
     (cl-remove-if (lambda (f) (member f buffers))
                   (counsel-recentf-candidates)))))

(advice-add #'counsel-buffer-or-recentf-candidates
            :override #'zz/counsel-buffer-or-recentf-candidates)

(use-package! switch-buffer-functions
  :after recentf
  :preface
  (defun my-recentf-track-visited-file (_prev _curr)
    (and buffer-file-name
         (recentf-add-file buffer-file-name)))
  :init
  (add-hook 'switch-buffer-functions #'my-recentf-track-visited-file))

;;(map! "C-s" #'counsel-grep-or-swiper)
(map! "C-s" #'+default/search-buffer)

(map! :after magit "C-c C-g" #'magit-status)

(use-package! visual-regexp-steroids
  :defer 3
  :config
  (require 'pcre2el)
  (setq vr/engine 'pcre2el)
  (map! "C-c s r" #'vr/replace)
  (map! "C-c s q" #'vr/query-replace))

(after! undo-fu
  (map! :map undo-fu-mode-map "C-?" #'undo-fu-only-redo))

(map! "M-g g" #'avy-goto-line)
(map! "M-g M-g" #'avy-goto-line)

(map! "M-g o" #'counsel-outline)

(after! smartparens
  (defun zz/goto-match-paren (arg)
    "Go to the matching paren/bracket, otherwise (or if ARG is not
    nil) insert %.  vi style of % jumping to matching brace."
    (interactive "p")
    (if (not (memq last-command '(set-mark
                                  cua-set-mark
                                  zz/goto-match-paren
                                  down-list
                                  up-list
                                  end-of-defun
                                  beginning-of-defun
                                  backward-sexp
                                  forward-sexp
                                  backward-up-list
                                  forward-paragraph
                                  backward-paragraph
                                  end-of-buffer
                                  beginning-of-buffer
                                  backward-word
                                  forward-word
                                  mwheel-scroll
                                  backward-word
                                  forward-word
                                  mouse-start-secondary
                                  mouse-yank-secondary
                                  mouse-secondary-save-then-kill
                                  move-end-of-line
                                  move-beginning-of-line
                                  backward-char
                                  forward-char
                                  scroll-up
                                  scroll-down
                                  scroll-left
                                  scroll-right
                                  mouse-set-point
                                  next-buffer
                                  previous-buffer
                                  previous-line
                                  next-line
                                  back-to-indentation
                                  doom/backward-to-bol-or-indent
                                  doom/forward-to-last-non-comment-or-eol
                                  )))
        (self-insert-command (or arg 1))
      (cond ((looking-at "\\s\(") (sp-forward-sexp) (backward-char 1))
            ((looking-at "\\s\)") (forward-char 1) (sp-backward-sexp))
            (t (self-insert-command (or arg 1))))))
  (map! "%" 'zz/goto-match-paren))

(setq org-directory "~/org/")

(after! org (setq org-hide-emphasis-markers t))

(after! org (setq org-insert-heading-respect-content nil))

(after! org
  (setq org-log-done t)
  (setq org-log-into-drawer t))

(after! org
  (setq org-special-ctrl-a/e t)
  (setq org-special-ctrl-k t))

(after! org
  (setq org-use-speed-commands
        (lambda ()
          (and (looking-at org-outline-regexp)
               (looking-back "^\**")))))

(add-hook! org-mode (electric-indent-local-mode -1))

(defun zz/adjust-org-company-backends ()
  (remove-hook 'after-change-major-mode-hook '+company-init-backends-h)
  (setq-local company-backends nil))
(add-hook! org-mode (zz/adjust-org-company-backends))

(add-hook! org-mode :append
           #'visual-line-mode
           #'variable-pitch-mode)

(add-hook! org-mode :append #'org-appear-mode)

(after! org
  (setq org-agenda-files
        '("~/gtd" "~/Work/work.org.gpg" "~/org/")))

(defun zz/add-file-keybinding (key file &optional desc)
  (let ((key key)
        (file file)
        (desc desc))
    (map! :desc (or desc file)
          key
          (lambda () (interactive) (find-file file)))))

(zz/add-file-keybinding "C-c z w" "~/Work/work.org.gpg" "work.org")
(zz/add-file-keybinding "C-c z i" "~/org/ideas.org" "ideas.org")
(zz/add-file-keybinding "C-c z p" "~/org/projects.org" "projects.org")
(zz/add-file-keybinding "C-c z d" "~/org/diary.org" "diary.org")

(setq org-roam-directory "/Users/taazadi1/Dropbox/Personal/org-roam/")
(setq +org-roam-open-buffer-on-find-file t)

(setq org-attach-id-dir "attachments/")

(defun zz/org-download-paste-clipboard (&optional use-default-filename)
  (interactive "P")
  (require 'org-download)
  (let ((file
         (if (not use-default-filename)
             (read-string (format "Filename [%s]: "
                                  org-download-screenshot-basename)
                          nil nil org-download-screenshot-basename)
           nil)))
    (org-download-clipboard file)))

(after! org
  (setq org-download-method 'directory)
  (setq org-download-image-dir "images")
  (setq org-download-heading-lvl nil)
  (setq org-download-timestamp "%Y%m%d-%H%M%S_")
  (setq org-image-actual-width 300)
  (map! :map org-mode-map
        "C-c l a y" #'zz/org-download-paste-clipboard
        "C-M-y" #'zz/org-download-paste-clipboard))

(map! :after counsel :map org-mode-map
      "C-c l l h" #'counsel-org-link)

(after! counsel
  (setq counsel-outline-display-style 'title))

(after! org-id
  ;; Do not create ID if a CUSTOM_ID exists
  (setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id))

(defun zz/make-id-for-title (title)
  "Return an ID based on TITLE."
  (let* ((new-id (replace-regexp-in-string "[^[:alnum:]]" "-" (downcase title))))
    new-id))

(defun zz/org-custom-id-create ()
  "Create and store CUSTOM_ID for current heading."
  (let* ((title (or (nth 4 (org-heading-components)) ""))
         (new-id (zz/make-id-for-title title)))
    (org-entry-put nil "CUSTOM_ID" new-id)
    (org-id-add-location new-id (buffer-file-name (buffer-base-buffer)))
    new-id))

(defun zz/org-custom-id-get-create (&optional where force)
  "Get or create CUSTOM_ID for heading at WHERE.

If FORCE is t, always recreate the property."
  (org-with-point-at where
    (let ((old-id (org-entry-get nil "CUSTOM_ID")))
      ;; If CUSTOM_ID exists and FORCE is false, return it
      (if (and (not force) old-id (stringp old-id))
          old-id
        ;; otherwise, create it
        (zz/org-custom-id-create)))))

;; Now override counsel-org-link-action
(after! counsel
  (defun counsel-org-link-action (x)
    "Insert a link to X.

X is expected to be a cons of the form (title . point), as passed
by `counsel-org-link'.

If X does not have a CUSTOM_ID, create it based on the headline
title."
    (let* ((id (zz/org-custom-id-get-create (cdr x))))
      (org-insert-link nil (concat "#" id) (car x)))))

(when IS-MAC
  (use-package! org-mac-link
    :after org
    :config
    (setq org-mac-grab-Acrobat-app-p nil) ; Disable grabbing from Adobe Acrobat
    (setq org-mac-grab-devonthink-app-p nil) ; Disable grabbinb from DevonThink
    (map! :map org-mode-map
          "C-c g"  #'org-mac-grab-link)))

(after! org-agenda
  ;; (setq org-agenda-prefix-format
  ;;       '((agenda . " %i %-12:c%?-12t% s")
  ;;         ;; Indent todo items by level to show nesting
  ;;         (todo . " %i %-12:c%l")
  ;;         (tags . " %i %-12:c")
  ;;        (search . " %i %-12:c")))
  (setq org-agenda-include-diary t))

(use-package! holidays
  :after org-agenda
  :config
  (require 'mexican-holidays)
  (require 'swiss-holidays)
  (setq swiss-holidays-zh-city-holidays
        '((holiday-float 4 1 3 "Sechseläuten")
          (holiday-float 9 1 3 "Knabenschiessen")))
  (setq calendar-holidays
        (append '((holiday-fixed 1 1 "New Year's Day")
                  (holiday-fixed 2 14 "Valentine's Day")
                  (holiday-fixed 4 1 "April Fools' Day")
                  (holiday-fixed 10 31 "Halloween")
                  (holiday-easter-etc)
                  (holiday-fixed 12 25 "Christmas")
                  (solar-equinoxes-solstices))
                swiss-holidays
                swiss-holidays-labour-day
                swiss-holidays-catholic
                swiss-holidays-zh-city-holidays
                holiday-mexican-holidays)))

(use-package! org-super-agenda
  :after org-agenda
  :config
  (setq org-super-agenda-groups '((:auto-dir-name t)))
  (org-super-agenda-mode))

(use-package! org-archive
  :after org
  :config
  (setq org-archive-location "archive.org::datetree/"))

(after! org-clock
  (setq org-clock-persist t)
  (org-clock-persistence-insinuate))

(use-package! org-gtd
  :after org
  :config
  ;; where org-gtd will put its files. This value is also the default one.
  (setq org-gtd-directory "~/gtd/")
  ;; package: https://github.com/Malabarba/org-agenda-property
  ;; this is so you can see who an item was delegated to in the agenda
  (setq org-agenda-property-list '("DELEGATED_TO"))
  ;; I think this makes the agenda easier to read
  (setq org-agenda-property-position 'next-line)
  ;; package: https://www.nongnu.org/org-edna-el/
  ;; org-edna is used to make sure that when a project task gets DONE,
  ;; the next TODO is automatically changed to NEXT.
  (setq org-edna-use-inheritance t)
  (org-edna-load)
  :bind
  (("C-c d c" . org-gtd-capture) ;; add item to inbox
   ("C-c d a" . org-agenda-list) ;; see what's on your plate today
   ("C-c d p" . org-gtd-process-inbox) ;; process entire inbox
   ("C-c d n" . org-gtd-show-all-next) ;; see all NEXT items
   ;; see projects that don't have a NEXT item
   ("C-c d s" . org-gtd-show-stuck-projects)
   ;; the keybinding to hit when you're done editing an item in the
   ;; processing phase
   ("C-c d f" . org-gtd-clarify-finalize)))

(after! (org-gtd org-capture)
  (add-to-list 'org-capture-templates
               '("i" "GTD item"
                 entry
                 (file (lambda () (org-gtd--path org-gtd-inbox-file-basename)))
                 "* %?\n%U\n\n  %i"
                 :kill-buffer t))
  (add-to-list 'org-capture-templates
               '("l" "GTD item with link to where you are in emacs now"
                 entry
                 (file (lambda () (org-gtd--path org-gtd-inbox-file-basename)))
                 "* %?\n%U\n\n  %i\n  %a"
                 :kill-buffer t))
  (add-to-list 'org-capture-templates
               '("m" "GTD item with link to current Outlook mail message"
                 entry
                 (file (lambda () (org-gtd--path org-gtd-inbox-file-basename)))
                 "* %?\n%U\n\n  %i\n  %(org-mac-outlook-message-get-links)"
                 :kill-buffer t)))

(defadvice! +zz/load-org-gtd-before-capture (&optional goto keys)
    :before #'org-capture
    (require 'org-capture)
    (require 'org-gtd))

(use-package! ox-awesomecv
  :after org)
(use-package! ox-moderncv
  :after org)

(use-package! ox-leanpub
  :after org
  :config
  (require 'ox-leanpub-markdown)
  (org-leanpub-book-setup-menu-markdown))

(after! ox-hugo
  (setq org-hugo-use-code-for-kbd t))

(defun zz/org-if-str (str &optional desc)
  (when (org-string-nw-p str)
    (or (org-string-nw-p desc) str)))

(defun zz/org-macro-hsapi-code (module &optional func desc)
  (org-link-make-string
   (concat "https://www.hammerspoon.org/docs/"
           (concat module (zz/org-if-str func (concat "#" func))))
   (or (org-string-nw-p desc)
       (format "=%s="
               (concat module
                       (zz/org-if-str func (concat "." func)))))))

(defun zz/org-macro-keys-code-outer (str)
  (mapconcat (lambda (s)
               (concat "~" s "~"))
             (split-string str)
             (concat (string ?\u200B) "+" (string ?\u200B))))
(defun zz/org-macro-keys-code-inner (str)
  (concat "~" (mapconcat (lambda (s)
                           (concat s))
                         (split-string str)
                         (concat (string ?\u200B) "-" (string ?\u200B)))
          "~"))
(defun zz/org-macro-keys-code (str)
  (zz/org-macro-keys-code-inner str))

(defun zz/org-macro-luadoc-code (func &optional section desc)
  (org-link-make-string
   (concat "https://www.lua.org/manual/5.3/manual.html#"
           (zz/org-if-str func section))
   (zz/org-if-str func desc)))

(defun zz/org-macro-luafun-code (func &optional desc)
  (org-link-make-string
   (concat "https://www.lua.org/manual/5.3/manual.html#"
           (concat "pdf-" func))
   (zz/org-if-str (concat "=" func "()=") desc)))

(defun zz/org-reformat-buffer ()
  (interactive)
  (when (y-or-n-p "Really format current buffer? ")
    (let ((document (org-element-interpret-data (org-element-parse-buffer))))
      (erase-buffer)
      (insert document)
      (goto-char (point-min)))))

(use-package org-pandoc-import)

(defun zz/org-current-headline-number ()
  "Get the numbering of the innermost headline which contains the
cursor. Returns nil if the cursor is above the first level-1
headline, or at the very end of the file. Does not count
headlines tagged with :noexport:"
  (require 'org-num)
  (let ((org-num--numbering nil)
        (original-point (point)))
    (save-mark-and-excursion
      (let ((new nil))
        (org-map-entries
         (lambda ()
           (when (org-at-heading-p)
             (let* ((level (nth 1 (org-heading-components)))
                    (numbering (org-num--current-numbering level nil)))
               (let* ((current-subtree (save-excursion (org-element-at-point)))
                      (point-in-subtree
                       (<= (org-element-property :begin current-subtree)
                           original-point
                           (1- (org-element-property :end current-subtree)))))
                 ;; Get numbering to current headline if the cursor is in it.
                 (when point-in-subtree (push numbering
                                              new))))))
         "-noexport")
        ;; New contains all the trees that contain the cursor (i.e. the
        ;; innermost and all its parents), so we only return the innermost one.
        ;; We reverse its order to make it more readable.
        (reverse (car new))))))

(defun zz/refresh-reveal-prez ()
  ;; Export the file
  (org-re-reveal-export-to-html)
  (let* ((slide-list (zz/org-current-headline-number))
         (slide-str (string-join (mapcar #'number-to-string slide-list) "-"))
         ;; Determine the filename to use
         (file (concat (file-name-directory (buffer-file-name))
                       (org-export-output-file-name ".html" nil)))
         ;; Final URL including the slide number
         (uri (concat "file://" file "#/slide-" slide-str))
         ;; Get the document title
         (title (cadar (org-collect-keywords '("TITLE"))))
         ;; Command to reload the browser and move to the correct slide
         (cmd (concat
"osascript -e \"tell application \\\"Brave\\\" to repeat with W in windows
set i to 0
repeat with T in (tabs in W)
set i to i + 1
if title of T is \\\"" title "\\\" then
  reload T
  delay 0.1
  set URL of T to \\\"" uri "\\\"
  set (active tab index of W) to i
end if
end repeat
end repeat\"")))
    ;; Short sleep seems necessary for the file changes to be noticed
    (sleep-for 0.2)
    (call-process-shell-command cmd)))

(use-package! ox-jira
  :after org)

(make-directory "~/.org-jira" 'ignore-if-exists)
(setq jiralib-url "https://jira.swisscom.com/")

(use-package! org-ol-tree
  :after org)

(use-package! org-ml
  :after org)

(use-package! org-ql
  :after org)

(defun zz/headings-with-tags (file tags)
  (string-join
   (org-ql-select file
     `(tags-local ,@tags)
     :action '(let ((title (org-get-heading 'no-tags 'no-todo)))
                (concat "- "
                        (org-link-make-string
                         (format "file:%s::*%s" file title)
                         title))))
   "\n"))

(defun zz/headings-with-current-tags (file)
  (let ((tags (s-split ":" (cl-sixth (org-heading-components)) t)))
    (zz/headings-with-tags file tags)))

(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

(defun zz/sp-enclose-next-sexp (num)
  (interactive "p")
  (insert-parentheses (or num 1)))

(after! smartparens
  (add-hook! (clojure-mode
              emacs-lisp-mode
              lisp-mode
              cider-repl-mode
              racket-mode
              racket-repl-mode) :append #'smartparens-strict-mode)
  (add-hook! smartparens-mode :append #'sp-use-paredit-bindings)
  (map! :map (smartparens-mode-map smartparens-strict-mode-map)
        "M-(" #'zz/sp-enclose-next-sexp))

(after! prog-mode
  (map! :map prog-mode-map "C-h C-f" #'find-function-at-point)
  (map! :map prog-mode-map
        :localleader
        :desc "Find function at point"
        "g p" #'find-function-at-point))

(use-package! cfengine
  :defer t
  :commands cfengine3-mode
  :mode ("\\.cf\\'" . cfengine3-mode))

(use-package! graphviz-dot-mode)

(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))
(put 'dockerfile-image-name 'safe-local-variable #'stringp)

(defun plain-pipe-for-process () (setq-local process-connection-type nil))
(add-hook 'compilation-mode-hook 'plain-pipe-for-process)

(use-package! emacs-everywhere
  :config
  (setq emacs-everywhere-major-mode-function #'org-mode))

(after! magit
  (setq zz/repolist
        "~/.elvish/package-data/elvish-themes/chain-summary-repos.json")
  (defadvice! +zz/load-magit-repositories ()
    :before #'magit-list-repositories
    (setq magit-repository-directories
          (seq-map (lambda (e) (cons e 0)) (json-read-file zz/repolist))))
  (setq magit-repolist-columns
        '(("Name" 25 magit-repolist-column-ident nil)
          ("Status" 7 magit-repolist-column-flag nil)
          ("B<U" 3 magit-repolist-column-unpulled-from-upstream
           ((:right-align t)
            (:help-echo "Upstream changes not in branch")))
          ("B>U" 3 magit-repolist-column-unpushed-to-upstream
           ((:right-align t)
            (:help-echo "Local changes not in upstream")))
          ("Path" 99 magit-repolist-column-path nil))))

(after! epa
  (set (if EMACS27+
           'epg-pinentry-mode
         'epa-pinentry-mode) ; DEPRECATED `epa-pinentry-mode'
       nil)
  (setq epa-file-encrypt-to '("diego@zzamboni.org")))

(use-package! iedit
  :defer
  :config
  (set-face-background 'iedit-occurrence "Magenta")
  :bind
  ("C-;" . iedit-mode))

(defmacro zz/measure-time (&rest body)
  "Measure the time it takes to evaluate BODY."
  `(let ((time (current-time)))
     ,@body
     (float-time (time-since time))))

(setq vterm-shell "/usr/local/bin/elvish")

(use-package! unfill
  :defer t
  :bind
  ("M-q" . unfill-toggle)
  ("A-q" . unfill-paragraph))

(use-package! 750words)
(use-package! ox-750words)
