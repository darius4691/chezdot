;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Darius Huang"
      user-mail-address "dariushhh@hotmail.com")

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

(setq doom-font (font-spec :family "FiraCode Nerd Font Mono" :size 16))

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
(require 'pyim-greatdict) ; 拼音词库设置，五笔用户 *不需要* 此行设置
;(pyim-basedict-enable)   ; 拼音词库，五笔用户 *不需要* 此行设置
(pyim-basedict-enable)
(pyim-greatdict-enable)   ; 拼音词库，五笔用户 *不需要* 此行设置
(setq pyim-punctuation-translate-p '(no auto yes)) ;全角半角问题
(setq pyim-punctuation-dict nil) ;全角半角问题
(setq default-input-method "pyim")
(pyim-default-scheme 'xiaohe-shuangpin)
(setq dash-docs-enable-debugging nil)
(setq dash-docs-browser-func 'eww)
(if (file-exists-p "/bin/fish") (setq vterm-shell "/bin/fish") (setq vterm-shell "/bin/fish"))


(add-hook 'LaTeX-mode-hook 'turn-on-auto-fill) ; 在latex模式下输入文字自动换行
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
