;;; Startup
;;; PACKAGE LIST
(defvar darius/default-font-size 200)
(setq user-full-name "黄耀庭"
      user-mail-address "dariush4691@outlook.com")


;; basic font settings
(set-face-attribute 'default nil :font "更纱黑体 Mono SC Nerd" :height darius/default-font-size)
(set-face-attribute 'variable-pitch nil :font "思源宋体" :height darius/default-font-size :weight 'regular)
(set-face-attribute 'fixed-pitch nil :font "更纱黑体 Mono SC Nerd" :height darius/default-font-size :weight 'regular)

(require 'package) ; This should be autoloaded. I'm putting this line here just in case not.
(setq package-archives '(("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
			 ("org" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
			 ("elpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")))
(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; disable the init gui fetures like scroll-bar or tool bar
(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room, modify the spacing 

(menu-bar-mode -1)          ; Disable the menu bar
(setq visible-bell t)       ; do not sound the bell. Instead, use visual blink


;;; BOOTSTRAP USE-PACKAGE
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t)

(require 'use-package)
;;; UNDO
;; Vim style undo not needed for emacs 28
(use-package undo-fu)

;;; Vim Bindings
(use-package evil
  :demand t
  :bind (("<escape>" . keyboard-escape-quit))
  :init
  ;; allows for using cgn
  ;; (setq evil-search-module 'evil-search)
  (setq evil-want-keybinding nil)
  ;; no vim insert bindings
  (setq evil-undo-system 'undo-fu)
  :config
  (evil-mode 1)
  (evil-set-leader nil (kbd "C-;"))
  (evil-set-leader 'normal (kbd "SPC"))
  (evil-set-leader 'normal "\\" t) ;Set localleader if last arg is non-nil 
  )

;;; Vim Bindings Everywhere else
(use-package evil-collection
  :after evil
  :config
  (setq evil-want-integration t)
  (evil-collection-init))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

;;; Using A Eyecandy Theme
(use-package gruvbox-theme
  :after evil
  :config
  (load-theme 'gruvbox))

;;;Vertical is for simple completion
(use-package vertico
  :config
  (vertico-mode)
  )

;;; IMPROVE THE CODING EXPIRENCE

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package ivy
  :diminish
  :after evil
  :bind (:map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffeers t)
  (setq enable-recursive-minibuffers t))

(use-package counsel
  :after (evil ivy)
  :bind (("M-x" . counsel-M-x)
         ("C-s" . swiper)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
	 ("C-h f" . counsel-describe-function)
	 ("C-h v" . counsel-describe-variable)
	 ("C-h o" . counsel-describe-symbol)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)
	 :map evil-normal-state-map
	 ("<leader>b" . 'counsel-switch-buffer)
	 ("<leader>f" . 'counsel-find-file)
	 ("<leader>?" . 'counsel-rg)))

(use-package all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1)) 

(use-package ivy-rich
  :ensure t
  :after (ivy counsel)
  :init (ivy-rich-mode 1))
 
;;; SYNTAX UI etc.
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

;; rainbow parrent
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; HOOKS
;; add leftside line number when in coding mode
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; If a quote might be a function, better use #'; because ' loop first into a symbol and then a funcion; while #' look direcly into a symbo


;;orgmode settings
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)
(add-hook 'org-mode-hook #'org-indent-mode) ; add virtual indentation

(setq org-directory "~/org"
      org-agenda-files '("~/org/agenda.org" "~/org/notes.org")
      org-archive-location "~/org/archive.org::* From %s"
      org-default-notes-file "~/org/notes.org"
      org-qgenda-start-with-log-mode t
      org-log-done 'time
      org-log-into-drawer t
      org-edit-src-content-indentation 0
      org-confirm-babel-evaluate nil
      org-babel-lisp-eval-fn #'sly-eval
      )

(use-package mixed-pitch
  :hook (org-mode . mixed-pitch-mode))

(use-package gnuplot)

;; active Babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (C . t)
   (lua . t)
   (gnuplot . t)
   (dot . t)
   (plantuml . t)
   (latex . t)
   (shell . t)
   (scheme . t)
   (lisp . t)
   (haskell . t)
   (emacs-lisp . t)))
;; INPUT METHOD

(use-package posframe)

(use-package pyim
  :config
  (setq pyim-page-tooltip 'posframe)
  (setq pyim-punctuation-translate-p '(no auto yes)) ;全角半角问题
  (setq pyim-punctuation-dict nil) ;全角半角问题
  (setq default-input-method "pyim")
  (pyim-default-scheme 'xiaohe-shuangpin)
  (pyim-extra-dicts-add-dict
    `(:name "Greatdict"
      :file "~/.config/emacs/pyim-greatdict.pyim.gz"
      :coding utf-8-unix
      :dict-type pinyin-dict)))

;; languages
(use-package sly)
(use-package plantuml-mode)

;; latex
(use-package cdlatex
  :bind (:map latex-mode-map
	 ("C-c C-," . cdlatex-environment))
  :hook (LaTeX-mode . cdlatex-mode))
(use-package auctex-latexmk
  :config
  (auctex-latexmk-setup))
(use-package evil-tex
  :hook (LaTex-mode . evil-tex-mode))
(add-hook 'LaTeX-mode-hook 'turn-on-auto-fill) ; 在latex模式下输入文字自动换行

;; Applications
(use-package transient)
(use-package dirvish
  :bind (:map evil-normal-state-map
	 ("<leader>F" . dirvish))
  :config
  (dirvish-override-dired-mode t))


;; LAST USE CUSTOM-FILE
(setq custom-file "~/.config/emacs/custom.el")
(load custom-file)
