;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Darius Huang"
      user-mail-address "dariush4691@outlook.com")

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
;;(setq doom-font (font-spec :family "FiraCode Nerd Font Mono" :size 13)
;;     doom-variable-pitch-font (font-spec :family "sans" :size 14))

(setq doom-font (font-spec :family "FiraCode Nerd Font Mono" :size 16)
      doom-unicode-font (font-spec :family "Hei")
      )
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

(require 'pyim)
(require 'pyim-basedict)
(pyim-basedict-enable)
(setq pyim-page-tooltip 'posframe)
(setq pyim-punctuation-translate-p '(no auto yes)) ;全角半角问题
(setq pyim-punctuation-dict nil) ;全角半角问题
(setq default-input-method "pyim")
(pyim-default-scheme 'xiaohe-shuangpin)
(pyim-extra-dicts-add-dict
           `(:name "Greatdict"
                   :file "/Users/darius/.doom.d/pyim-greatdict.pyim.gz"
                   :coding utf-8-unix
                   :dict-type pinyin-dict))

(setq dash-docs-enable-debugging nil)
(setq dash-docs-browser-func 'eww)

(if (file-exists-p "/bin/fish") (setq vterm-shell "/bin/fish") (setq vterm-shell "/bin/fish"))


(add-hook 'LaTeX-mode-hook 'turn-on-auto-fill) ; 在latex模式下输入文字自动换行
(map! :leader :desc "SwitchBuffer" :n "b" #'ivy-switch-buffer)
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

(after! ox-latex
    (setq org-latex-pdf-process '("latexmk -xelatex -quiet -shell-escape -f %f"))
    (add-to-list 'org-latex-classes
             '("chinesepaper"
               "\\documentclass[lang=cn]{article}
\\usepackage{xeCJK}
\\setCJKmainfont[BoldFont=STZhongsong, ItalicFont=STKaiti]{STSong}
\\setCJKsansfont[BoldFont=STHeiti]{STXihei}
\\setCJKmonofont{STFangsong}
[DEFAULT-PACKAGES]
[PACKAGES]
[EXTRA]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
    (setq org-latex-listings 'minted)
    (add-to-list 'org-latex-packages-alist '("" "minted")))

(defun set-buffer-variable-pitch ()
  (interactive)
  ;(variable-pitch-mode t)
  ;(setq line-spacing 3)
  (set-face-attribute 'org-table nil :family "更纱黑体 Mono SC Nerd")
  ;(set-face-attribute 'org-link nil :inherit 'fixed-pitch)
  ;(set-face-attribute 'org-code nil :inherit 'fixed-pitch)
  ;(set-face-attribute 'org-block nil :inherit 'fixed-pitch)
  ;(set-face-attribute 'org-date nil :inherit 'fixed-pitch)
  ;(set-face-attribute 'org-special-keyword nil :inherit 'fixed-pitch)
  )
(add-hook 'org-mode-hook 'set-buffer-variable-pitch)
(add-hook 'markdown-mode-hook 'set-buffer-variable-pitch)
(add-hook 'Info-mode-hook 'set-buffer-variable-pitch)
(setq org-log-done 'time)
(setq pangu-spacing-real-insert-separtor t)
(use-package! pangu-spacing
  :hook (text-mode . pangu-spacing-mode)
  :config
  ;; Always insert `real' space in org-mode.
  (setq-hook! 'org-mode-hook pangu-spacing-real-insert-separtor t))

(def-package! org-ref
    :after org
    :init
    ; code to run before loading org-ref
    :config
    ; code to run after loading org-ref
    )
