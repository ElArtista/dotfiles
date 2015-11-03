;;; package --- Summary
;;;
;;; Commentary:
;;;
;;; This is my personal emacs file. In each comment section I initialize
;;; something different.
;;; In package section I only do the minimum initialize required for each
;;; of the packages I used, exactly as they describe on their documentation,
;;;
;;;
;;; Code:

; start package.el with emacs
(require 'package)
; add MELPA to repository list
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
; initialize package.el
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/elisp/")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                    UI Settings                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;-----
;; General
;;-----

; fullscreen
(custom-set-variables '(initial-frame-alist (quote ((fullscreen . maximized)))))

; No cursor blinking, it's distracting
(blink-cursor-mode 0)

(global-font-lock-mode 1)

; Hide deafault load screen
(setq inhibit-startup-message t)

; split screen
(split-window-right)

; No cursor blinking, it's distracting
(blink-cursor-mode 0)

; full path in title bar
(setq-default frame-title-format "%b (%f)")

; You can uncomment this to remove the graphical toolbar at the top. After
; awhile, you won't need the toolbar.
(when (fboundp 'tool-bar-mode)
   (tool-bar-mode -1))

; Don't show native OS scroll bars for buffers because they're redundant
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

; Turn off the menu bar at the top of each frame because it's distracting
(menu-bar-mode -1)

; line numbers
(global-linum-mode t)

; font size 9pt
(set-face-attribute 'default nil :height 85)

;;-----
;; Tabs
;;-----
(setq-default indent-tabs-mode nil)
(setq default-tab-width 4)
(setq c-basic-indent 4)
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)

;; C/C++
; set tabs
(setq tab-width 4) ; or any other preferred value
(defvaralias 'c-basic-offset 'tab-width)
(setq c-default-style "linux"
          c-basic-offset 4)

; Make <TAB> in C mode just insert a tab if point is in the middle of a line.
(setq c-tab-always-indent nil)

;; Elm
;(setq elm-indent-offset 4)

;;-----
;; Themes
;;-----
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'monokai t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                   Packages Init                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;-----
;; Haskell
;;-----
(require 'haskell-mode)
(setq haskell-hoogle-command "hoogle")
; haskell-mode
(add-hook 'haskell-mode-hook 'haskell-indentation-mode)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
(custom-set-variables '(haskell-process-type 'cabal repl))

; ghc-mod for haskell
(add-to-list `load-path "~/.cabal/share/x86_64-linux-ghc-7.10.2/ghc-mod-5.4.0.0/elisp")

(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)))

; init company-ghc
(require 'company)
(add-hook 'haskell-mode-hook 'company-mode)

; instruct company-mode to get completions from ghc-mod
(add-to-list 'company-backends 'company-ghc)
(custom-set-variables '(company-ghc-show-info t))

;;-----
;; Elm
;;-----
;(add-hook 'elm-mode-hook 'elm-oracle-setup-completion)
;(add-hook 'elm-mode-hook #'elm-oracle-setup-ac)

;;-----
;; Markdown
;;-----
;(autoload 'markdown-mode "markdown-mode"
;   "Major mode for editing Markdown files" t)
;(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
;(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
;(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                     Functions                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Behave like vi's o command
(defun open-next-line (arg)
  "Move to the next line and then opens a line.
  See also `newline-and-indent'."
  (interactive "p")
  (end-of-line)
  (open-line arg)
  (next-line 1)
  (when newline-and-indent
  (indent-according-to-mode))
  )

; Behave like vi's O command
(defun open-previous-line (arg)
  "Open a new line before the current one. 
  See also `newline-and-indent'."
  (interactive "p")
  (beginning-of-line)
  (open-line arg)
  (when newline-and-indent
  (indent-according-to-mode))
  )

; Rename file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file name new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                    Key Settings                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key [f1] 'help-command)
(global-set-key [f2] 'undo)
(global-set-key [f3] "\M-w") ; Copy
(global-set-key [f4] "\C-y") ; Paste

; Make F8 be "start macro", F9 be "end macro", F10 be "execute macro"
(global-set-key [f8] 'start-kbd-macro)
(global-set-key [f9] 'end-kbd-macro)
(global-set-key [f10] 'call-last-kbd-macro)

(global-set-key (kbd "C-o") 'open-next-line)
(global-set-key (kbd "M-o") 'open-previous-line)

;;-----
;; Haskell
;;-----
; define keys for haskell
(defun haskell-mode-keys ()
  "Modify keymaps used by `haskell-mode'."
  (local-set-key (kbd "M-c") 'ghc-complete)
  (local-set-key (kbd "<f10>") 'ghc-goto-next-error)
  (local-set-key (kbd "<f11>") 'ghc-goto-prev-error)
  ;(local-set-key (kbd "M-n") 'ghc-goto-next-error)
  ;(local-set-key (kbd "M-p") 'ghc-goto-prev-error)
  (local-set-key (kbd "<f12>") 'ghc-show-type)
  (local-set-key (kbd "C-c C-o") 'haskell-compile)
  )

; add to hook
(add-hook 'haskell-mode-hook 'haskell-mode-keys)

;;-----
;; Elm
;;-----
; define keys for elm
;(defun elm-mode-keys ()
;  (local-set-key (kbd "<f12>") 'elm-oracle-type-at-point)
;  )

; add to hook
;(add-hook 'elm-mode-hook 'elm-mode-keys)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                       Other                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Change backup file settings
(setq backup-directory-alist `(("." . "~/.emacs.d/saved_files")))
(setq backup-by-copying t)
;(setq make-backup-files nil)

; Change directory
;(cd "~/Code/Haskell/Projects/Dev")

(provide '.emacs)
;;; .emacs ends here
