(setq custom-file "~/.config/emacs/custom.el")
(load custom-file)

(setq user-full-name "黄耀庭"
      user-mail-address "dariush4691@outlook.com")

(defvar darius/default-font-size 200)
(defun darius/set-font ()
  (set-face-attribute 'default nil :font "更纱黑体 Mono SC Nerd" :height darius/default-font-size)
  (set-face-attribute 'variable-pitch nil :font "思源宋体" :height darius/default-font-size :weight 'regular)
  (set-face-attribute 'fixed-pitch nil :font "更纱黑体 Mono SC Nerd" :height darius/default-font-size :weight 'regular))
(if (daemonp)
    (add-hook 'server-after-make-frame-hook #'darius/set-font)
    (darius/set-font))

(require 'package) ; This should be autoloaded. I'm putting this line here just in case not.
(setq package-archives '(("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
			 ("org" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
			 ("elpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")))
(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

(setq inhibit-startup-message t)
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room, modify the spacing 
(menu-bar-mode -1)          ; Disable the menu bar
(setq visible-bell t)       ; do not sound the bell. Instead, use visual blink

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t)

(electric-pair-mode)        ; toggle auto-pair-mode
(use-package undo-fu)
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

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))
(use-package nyan-mode
  :ensure t
  :init (nyan-mode))

;; rainbow parrent
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
;; add leftside line number when in coding mode
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;;;Vertical is for simple completion
(use-package vertico
  :config
  (vertico-mode))

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
      org-highlight-latex-and-related '(native script entities))
(use-package mixed-pitch
  :hook (org-mode . mixed-pitch-mode))

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
(use-package gnuplot)
(use-package sly)
(use-package plantuml-mode)
(use-package lua-mode)

;; orgmode export latex template
(with-eval-after-load 'ox-latex
  (setq org-latex-compiler "xelatex")
  (setq org-latex-pdf-process '("latexmk -%latex -quiet -shell-escape -f %f"))
  (add-to-list 'org-latex-classes
           '("myreport"
             "\\documentclass{minereport}
              [DEFAULT-PACKAGES]
              [PACKAGES]
              [EXTRA]"
             ("\\section{%s}" . "\\section*{%s}")
             ("\\subsection{%s}" . "\\subsection*{%s}")
             ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
             ("\\paragraph{%s}" . "\\paragraph*{%s}")
             ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  (add-to-list 'org-latex-classes
             '("elegantpaper"
               "\\documentclass[lang=cn,11pt,a4paper,cite=authoryear,fontset=none]{elegantpaper}
\\setCJKmainfont[BoldFont={FZHTK--GBK1-0},ItalicFont={FZKTK--GBK1-0}]{FZSSK--GBK1-0}
\\setCJKsansfont[BoldFont={FZHTK--GBK1-0},ItalicFont={FZHTK--GBK1-0}]{FZHTK--GBK1-0}
\\setCJKmonofont[BoldFont={FZHTK--GBK1-0},ItalicFont={FZHTK--GBK1-0}]{FZFSK--GBK1-0}
\\setCJKfamilyfont{zhsong}{FZSSK--GBK1-0}
\\setCJKfamilyfont{zhhei}{FZHTK--GBK1-0}
\\setCJKfamilyfont{zhkai}{FZKTK--GBK1-0}
\\setCJKfamilyfont{zhfs}{FZFSK--GBK1-0}
\\newcommand*{\\songti}{\\CJKfamily{zhsong}}
\\newcommand*{\\heiti}{\\CJKfamily{zhhei}}
\\newcommand*{\\kaishu}{\\CJKfamily{zhkai}}
\\newcommand*{\\fangsong}{\\CJKfamily{zhfs}}
[DEFAULT-PACKAGES]
[PACKAGES]
[EXTRA]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
    (setq org-latex-default-class "elegantpaper"))
(use-package ox-pandoc
  :config
  (setq org-pandoc-options-for-latex-pdf
	'((pdf-engine . "xelatex")
	  (listings . t)
	  (template . eisvogel)
	  (variable . "CJKmainfont=SourceHanSansSC-Regular")
	  (lua-filter . "no-code-attributes.lua"))))

;; Here's a very basic sample for configuration of org-roam using use-package:
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/org-roam"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

;; latex
(use-package cdlatex
  :bind (:map cdlatex-mode-map
	 ("C-c C-{" . nil)
	 ("C-c C-," . cdlatex-environment))
  :hook (LaTeX-mode . cdlatex-mode))
(use-package auctex-latexmk
  :config
  (auctex-latexmk-setup))
(use-package evil-tex
  :hook (LaTeX-mode . evil-tex-mode))
(add-hook 'LaTeX-mode-hook 'turn-on-auto-fill) ; 在latex模式下输入文字自动换行

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

;; 文件管理器
(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

(use-package dired-single
  :commands (dired dired-jump))

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-open
  :commands (dired dired-jump)
  :config
  ;; Doesn't work as expected!
  ;;(add-to-list 'dired-open-functions #'dired-open-xdg t)
  (setq dired-open-extensions '(("png" . "feh")
                                ("mkv" . "mpv"))))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))

(use-package elfeed
  :config
  (setq elfeed-feeds
	'(("https://sspai.com/feed")
	  ("https://rsshub.app/guokr/scientific")))
  (setq browse-url-browser-function 'eww-browse-url))

(use-package ggtags)
(use-package call-graph
  :config
  (evil-define-key 'normal call-graph-mode
    "e" 'cg-widget-expand-all
    "c" 'cg-widget-collapse-all
    "p" 'widget-backward
    "n" 'widget-forward
    "q" 'cg-quit
    "+" 'cg-expand
    "_" 'cg-collapse
    "o" 'cg-goto-file-at-point
    "g" 'cg-at-point
    "d" 'cg-remove-caller
    "l" 'cg-select-caller-location
    "r" 'cg-reset-caller-cache
    "t" 'cg-toggle-show-func-args
    "f" 'cg-toggle-invalid-reference
    (kbd "<RET>") 'cg-goto-file-at-point))
(use-package pdf-tools)
