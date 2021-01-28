;; Initialize package system
(when (version< emacs-version "27.0")
  (package-initialize))
(setq package-enable-at-startup nil)

(require 'package)

(setq package-archives
      '(("org"     .       "https://orgmode.org/elpa/")
        ("gnu"     .       "https://elpa.gnu.org/packages/")
	("melpa-stb" . "https://stable.melpa.org/packages/")
        ("melpa"   .       "https://melpa.org/packages/")))

;; use-package for civilized configuration
(unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package)
    (eval-when-compile (require 'use-package)))

(setq use-package-always-ensure t)


;; *************************
;; ** Basic Customisation **
;; ************************

;; -- UI --

;; Electic pair mode for matching parenthesis, brackets etc
(electric-pair-mode t)

;; Highlights matching parenthesis
(show-paren-mode 1)

;; Clean up the view a bit
(setq inhibit-startup-message t)
(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

(set-face-attribute 'default nil :height 120)
(setq-default line-spacing 0.2)

;; Enter fullscreen on open
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(blink-cursor-mode 1)
;;(setq-default cursor-type 'bar)
(set-cursor-color "#cccccc")
(setq ring-bell-function 'ignore)

;; -- Editing --

;; Used for expand abbreviations. If for example, you wanted an abbreviation for
;; <Your Name> to be ‘yn’, just type ‘yn’ and with your point after the ‘n’ do "C-x a i g"
;; and enter the expansion. Then whenever you type ‘yn’, your name will be inserted.
;; Useful for fixing typos - if you type 'teh' instead of 'the', or 'lte' instead of 'let',
;; never correct it but instead do C-x a i g and enter the correct spelling. Then emacs
;; will automatically clean up behind you
(setq-default abbrev-mode 1)
(dolist (table abbrev-table-name-list)
    (abbrev-table-put (symbol-value table) :case-fixed t))

;; For moving between errors
(global-set-key (kbd "C-c e n") 'next-error)
(global-set-key (kbd "C-c e p") 'previous-error)

;; Spell checking
(setq ispell-dictionary "english")

;; Put customization data in a different file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Change all yes/no questions to y/n type
(fset 'yes-or-no-p 'y-or-n-p)

;; No need for ~ files when editing
(setq create-lockfiles nil)

;; Interactive search key bindings. By default, C-s runs
;; isearch-forward, so this swaps the bindings.
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

(define-key global-map (kbd "RET") 'newline-and-indent)

;; When you visit a file, point goes to the last place where it
;; was when you previously visited the same file.
;; http://www.emacswiki.org/emacs/SavePlace

(setq-default save-place t)
;; keep track of saved places in ~/.emacs.d/places
(setq save-place-file (concat user-emacs-directory "places"))

;; Emacs can automatically create backup files. This tells Emacs to
;; put all backups in ~/.emacs.d/backups. More info:
;; http://www.gnu.org/software/emacs/manual/html_node/elisp/Backup-Files.html
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory
                                               "backups"))))
(setq auto-save-default nil)

;; Helper to comment/uncomment blocks of text
(defun toggle-comment-on-line ()
  "Comment or uncomment current line."
  (interactive)
  (comment-or-uncomment-region (line-beginning-position) (line-end-position)))
(global-set-key (kbd "C-;") 'toggle-comment-on-line)

;; -- Navigating --

;; Shows a list of buffers
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Enable moving from window to window using Shift and the arrow keys
(windmove-default-keybindings)

;; Easily open and edit init.el
(defun open-config ()
    "Open init.el"
    (interactive)
    (find-file "~/.emacs.d/init.el"))

;; Open current buffer in separate 'window'
(defun pop-buffer ()
  "Open the current buffer in a different frame. Equivalent to make-frame-command"
  (make-frame-command))

;; ************
;; ** Themes **
;; ************

;; Let emacs know where to find themes
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

;; (use-package gruvbox-theme
;;   :config
;;   (custom-theme-set-faces 'gruvbox-dark0-hard))

;; (use-package flatland-theme
;;   :config
;;   (custom-theme-set-faces 'flatland))

(use-package atom-one-dark-theme
  :config
  (custom-theme-set-faces 'atom-one-dark)
  :init
  (add-hook 'after-init-hook (lambda () (load-theme 'atom-one-dark))))


;; **********
;; ** IELM **
;; **********

;; By default, IELM evaluates complete expressions automatically as
;; soon you as you press RET, which is annoying when parentheses are
;; automatically paired. With this set to nil we must use C-j to
;; evaluate the expression.
(setq ielm-dynamic-return nil) 

;; **************
;; ** Org mode **
;; **************
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

(setq org-directory (expand-file-name "~/org"))
(setq org-agenda-files '("~/org/todo.org.gpg"))
(setq org-archive-location "~/org/archives/%s_archive::")

(setq org-todo-keywords
      '((sequence "TODO(t)" "IN-PROGRESS(p)" "WAITING(w)" "DONE(d)" "CANCELLED(x)" "DEFERRED(f)")))

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/todo.org.gpg" "Tasks") "* TODO %^{Description} %^g\n  %?" :empty-lines-before 1)
	("s" "Shopping item" entry (file+headline "~/org/todo.org.gpg" "Shopping") "* TODO %^{Item}" :empty-lines-after 1)
	("j" "Journal" entry (file+datetree "~/org/journal.org.gpg") "* %^{Heading}  %^g\n  %?\n\n  /Added/: %U" :empty-lines-after 1)
	("n" "Note" entry (file+datetree "~/org/notes.org.gpg" "Dump") "* %^{Heading} %^g\n  %?\n\n  /Added/: %U" :empty-lines-after 1)))

(setq org-cycle-separator-lines 1)
(setq org-hide-emphasis-markers t)
(setq org-agenda-ndays 7)
(setq org-deadline-warning-days 14)
(setq org-agenda-show-all-dates t)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-start-on-weekday nil)
(setq org-reverse-note-order t)
(setq org-fast-tag-selection-single-key (quote expert))
(setq org-agenda-custom-commands
      (quote (("p" todo "IN-PROGRESS" nil)
	      ("w" todo "WAITING" nil)
	      ("c" todo "DONE|CANCELLED" nil)
	      ("d" todo "DEFERRED" nil)
	      ("W" agenda "" ((org-agenda-ndays 28)))
	      ("A" agenda ""
	       ((org-agenda-skip-function
		 (lambda nil
		   (org-agenda-skip-entry-if (quote notregexp) "\\=.*\\[#A\\]")))
		(org-agenda-ndays 1)
		(org-agenda-overriding-header "Today's Priority #A tasks: ")))
	      ("u" alltodo ""
	       ((org-agenda-skip-function
		 (lambda nil
		   (org-agenda-skip-entry-if (quote scheduled) (quote deadline)
					     (quote regexp) "\n]+>")))
		(org-agenda-overriding-header "Unscheduled TODO entries: "))))))

(defun open-todo ()
    "Open org-mode todo"
    (interactive)
    (find-file "~/org/todo.org.gpg"))

(defun open-journal ()
    "Open org-mode journal"
    (interactive)
    (find-file "~/org/journal.org.gpg"))

(defun open-notes ()
   "Open org-mode notes"
    (interactive)
    (find-file "~/org/notes.org.gpg"))

(defun open-address-book ()
   "Open org-mode address book"
    (interactive)
    (find-file "~/org/address_book.org.gpg"))


;; **************
;; ** Packages **
;; **************

;; -- UI / cosmetics packages --

;; Resize windows based on which one is active
(use-package golden-ratio
  :config (golden-ratio-mode 1))

;; Do not show some common modes in the modeline, to save space
(use-package diminish
  :defer 5
  :config
  (diminish 'org-indent-mode))

;; Nyan cat instead of scrollbar
(use-package nyan-mode
  :config
  (nyan-mode 1))

;; Smartparens
;(use-package smartparens)


;; -- Navigation --

;; Move buffers between windows
(use-package buffer-move
  :config
  (global-set-key (kbd "<C-S-up>")     'buf-move-up)
  (global-set-key (kbd "<C-S-down>")   'buf-move-down)
  (global-set-key (kbd "<C-S-left>")   'buf-move-left)
  (global-set-key (kbd "<C-S-right>")  'buf-move-right))

;; Make it easier to discover key shortcuts
(use-package which-key
  :diminish
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom)
  (setq which-key-idle-delay 0.1))

;; Helm
(use-package helm
 :diminish
 :init (helm-mode t)
 :bind (("M-x"     . helm-M-x)
        ("C-x C-f" . helm-find-files)
        ("C-x b"   . helm-mini)     ;; See buffers & recent files; more useful.
        ("C-x r b" . helm-filtered-bookmarks)
        ("C-x C-r" . helm-recentf)  ;; Search for recently edited files
        ("C-c i"   . helm-imenu)
        ("C-h a"   . helm-apropos)
        ;; Look at what was cut recently & paste it in.
        ("M-y" . helm-show-kill-ring)

        :map helm-map
        ;; We can list ‘actions’ on the currently selected item by C-z.
        ("C-z" . helm-select-action)
        ;; Let's keep tab-completetion anyhow.
        ("TAB"   . helm-execute-persistent-action)
        ("<tab>" . helm-execute-persistent-action)))


;; Note that ‘uniquify’ is built in
(require 'uniquify)
(setq uniquify-separator "/"               ;; The separator in buffer names.
      uniquify-buffer-name-style 'forward) ;; names/in/this/style

;; -- Other

;; Magit
(use-package magit
  :config
  (global-set-key (kbd "C-x g") 'magit-status))


;; Use a terminal
(use-package shell-pop
  :init
  (setq shell-pop-full-span t)
  :bind (("C-c s" . shell-pop)))

;; Ripgrep
(use-package rg
  :config
  (global-set-key (kbd "M-s g") 'rg)
  (global-set-key (kbd "M-s d") 'rg-dwim))

(use-package helm-rg)

;; Projectile
(use-package projectile
  :hook (after-init . projectile-mode))

;; Treemacs
(use-package treemacs
  :bind
  (("<f8>" . treemacs)
  ("<f9>" . treemacs-select-window))
  :init
  (setq treemacs-width 25
	treemacs-is-never-other-window t
	treemacs-follow-mode t
	treemacs-filewatch-mode t)
  :config
  (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))

(use-package treemacs-projectile
  :after treemacs projectile)

;; Yasnippet
(use-package yasnippet
  :hook (after-init . yas-global-mode)
  :bind
  (:map yas-minor-mode-map
        ("C-c C-i" . yas-insert-snippet))
  )

(use-package yasnippet-snippets)

;; Company
(use-package company
  :init
  (setq company-idle-delay nil  ; avoid auto completion popup, use TAB to show it
        company-tooltip-align-annotations t)
  :hook (after-init . global-company-mode)
  :bind
  (:map prog-mode-map
        ("C-i" . company-indent-or-complete-common)
  	("TAB" . company-indent-or-complete-common)
        ("C-M-i" . completion-at-point))
  :config
  (define-key company-active-map [tab] 'company-complete-common-or-cycle)
  (define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
  )

(use-package company-lsp)

;; LSP
(use-package lsp-mode
  :init (setq lsp-ui-doc-enable nil)
  :commands lsp
  ;; reformat code and add missing (or remove old) imports
  :hook ((before-save . lsp-format-buffer)
         (before-save . lsp-organize-imports))
  :bind (("C-c d" . lsp-describe-thing-at-point)
         ;("C-c e n" . flymake-goto-next-error)
         ;("C-c e p" . flymake-goto-prev-error)
         ("C-c e r" . lsp-find-references)
         ("C-c C-r" . lsp-rename)
         ("C-c C-l" . lsp-find-definition)
         ("C-c C-t" . lsp-find-type-definition)))

(use-package lsp-ui)

(use-package helm-lsp
  :config
  (define-key lsp-mode-map [remap xref-find-apropos] #'helm-lsp-workspace-symbol))

;; Rust
(defun my-rustic-mode-hook-fn ()
  "needed for lsp-format-buffer to indent with 4 spaces"
  (setq tab-width 4
	indent-tabs-mode nil))

(use-package rustic
  :init
  ;; to use rustic-mode even if rust-mode also installed
  (setq auto-mode-alist (delete '("\\.rs\\'" . rust-mode) auto-mode-alist))
  (setq rustic-lsp-server 'rust-analyzer)
  :hook (rustic-mode . my-rustic-mode-hook-fn)
  :bind (("C-x `" . flymake-goto-next-error)
	 ("C-c e n" . flymake-goto-next-error)
	 ("C-c e p" . flymake-goto-prev-error))
  :load-path "~/projects/oss/rustic")

;; JSON / TOML
(use-package json-mode)
(use-package toml-mode)

;; Dockerfiles
(use-package dockerfile-mode)

;; OCaml
;; ## added by OPAM user-setup for emacs / base ## 56ab50dc8996d2bb95e7856a6eddb17b ## you can edit, but keep this line
(require 'opam-user-setup "~/.emacs.d/opam-user-setup.el")
;; ## end of OPAM user-setup addition for emacs / base ## keep this line

;; Lisp / Sexps
(use-package rainbow-blocks
  :init (add-to-list 'auto-mode-alist '("\\.sexp\\'" . rainbow-blocks-mode)))
