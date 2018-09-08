;;------------------------------------
;; el-get pkg manager

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'package)
;; install from packages from MELPA repo
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")

(package-initialize)


(setq evil-want-integration nil)  ; required for evil-collection
;; If you want to use Evil in the minibuffer, you'll have to enable like so..
(setq evil-collection-setup-minibuffer t)

;;------------------------------------
;; manually installed packages
;; cloned from https://github.com/emacs-evil/evil-collection.git; i changed some keymappings.
(add-to-list 'load-path (expand-file-name "~/.emacs.d/evil-collection" user-emacs-directory))
;; cloned from https://github.com/cofi/evil-leader.git
(add-to-list 'load-path (expand-file-name "~/.emacs.d/evil-leader" user-emacs-directory))
;; https://github.com/juanjux/evil-search-highlight-persist.git
(add-to-list 'load-path (expand-file-name "~/.emacs.d/evil-search-highlight-persist" user-emacs-directory))


;;------------------------------------
;; auto-install if pkg doesn't exist
(setq my:el-get-packages
      '(evil
        helm
        powerline
        projectile
        evil-numbers
        evil-surround
        evil-commentary
        evil-matchit
        eww-lnum
        twittering-mode
        elscreen
        highlight
        flycheck
        magit))
(el-get 'sync my:el-get-packages)
(el-get 'sync)


;;------------------------------------
(require 'evil)
(require 'evil-commentary)
(require 'evil-surround)
(require 'evil-numbers)
(require 'evil-matchit)
(require 'evil-collection)
(require 'evil-leader)
(require 'powerline)
;;(require 'eww-lnum)
(require 'elscreen)
(require 'highlight)
(require 'evil-search-highlight-persist)
(require 'helm)
(require 'helm-config)

;;Customize GUI
;;(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

;;Enable vim mode all the time
(evil-mode t)
(evil-commentary-mode)
(evil-surround-mode)
(global-set-key (kbd "C-c a") 'evil-numbers/inc-at-pt)
(global-set-key (kbd "C-c x") 'evil-numbers/dec-at-pt)
(global-evil-matchit-mode 1)
;;(global-linum-mode t)
;;turn on line number display
(when (version<= "26.0.50" emacs-version )
    (global-display-line-numbers-mode))
;;turn on better modeline display
(powerline-center-evil-theme)
(elscreen-start)
;; clear the highlights with the 'evil-search-highlight-persist-remove-all' command
(global-evil-search-highlight-persist t)
;; Helm mode
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)


;;------------------------------------
;;Enable additional keybindings for evil mode
(when (require 'evil-collection nil t)
    (evil-collection-init))
;;(evil-collection-init 'eww) 


;;------------------------------------
;; Formatting
;;------------------------------------
;; from https://lists.gnu.org/archive/html/help-gnu-emacs/2013-12/msg00451.html
(setq-default indent-tabs-mode nil) ; no tab characters in files
(setq-default tab-width 4)
;;(setq css-electric-keys nil)        ; turn off auto-indent -- DOESN'T WORK
;; from https://emacs.stackexchange.com/questions/9583/how-to-treat-underscore-as-part-of-the-word
(with-eval-after-load 'evil
    (defalias #'forward-evil-word #'forward-evil-symbol))


;;------------------------------------
;;EWW customizations
;;EWW extension from: https://emacs.stackexchange.com/questions/24472/simple-method-for-creating-multiple-eww-buffers
;;open page in new EWW buffer
(defun eww-new ()
  (interactive)
  (let ((url (read-from-minibuffer "Enter URL or keywords: ")))
    (switch-to-buffer (generate-new-buffer "eww"))
    (eww-mode)
        (eww url)))
;; Unbind keys from evil-collection-eww -- don't work
;;(eval-after-load 'evil-collection
;;   '(define-key eww-mode-map "H" nil))
;;(define-key eww-mode-map "H" nil)
;;(define-key eww-mode-map "L" nil)
;;(evil-collection-define-key 'normal 'eww-mode-map
;;    "H" nil
;;    "L" nil)

;; From http://ergoemacs.org/emacs/emacs_eww_web_browser.html
;; make emacs always use its own browser for opening URL links
(setq browse-url-browser-function 'eww-browse-url)

;; Hotkey for eww-lnum (follow links by numbers)
;; eval-after-load replaces 'require'
;; (eval-after-load 'eww-lnum
;;   '(define-key 'normal eww-mode-map (kbd "S-<up>") 'eww-lnum-universal))
;; (eval-after-load 'eww-lnum
;;   '(define-key 'normal eww-mode-map (kbd "S-<down>") 'eww-lnum-follow))
;;(define-key eww-mode-map (kbd "S-<up>") 'eww-lnum-follow)
;;(define-key eww-mode-map (kbd "S-<up>") 'eww-lnum-universal)


;;------------------------------------
;;old Vim shortcuts
;; pys w !python -m pyflakes   ;; python syntax check


;;------------------------------------
;;evil-leader dynamic key binding customizations
(global-evil-leader-mode)
(evil-leader/set-leader "|")    ; change leader key
(evil-leader/set-key
  "c" 'elscreen-create          ;; create new tab
  "g" 'elscreen-goto            ;; go to a tab
  "ln" 'global-display-line-numbers-mode    ;; toggle line number
  "t" 'elscreen-next            ;; go to next tab
  "T" 'elscreen-previous        ;; go to previous tab
)
(evil-leader/set-key-for-mode 'eww-mode
  "f" 'eww-lnum-follow
  "<left>" 'eww-back-url
  "<right>" 'eww-forward-url
  "N" 'eww-new                  ;; open url in new buffer
  "n" 'eww-open-in-new-buffer   ;; follow link in new buffer
)
;;(evil-leader/set-key-for-mode 'evil-normal-state-map
;;  "pys" 'eww-lnum-follow
;;)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#eee8d5" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#839496"])
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#657b83")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-enabled-themes (quote (wheatgrass)))
 '(custom-safe-themes
   (quote
    ("a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(fci-rule-color "#eee8d5")
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#fdf6e3" 0.25)
    (quote
     ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#586e75")
 '(highlight-tail-colors
   (quote
    (("#eee8d5" . 0)
     ("#B4C342" . 20)
     ("#69CABF" . 30)
     ("#69B7F0" . 50)
     ("#DEB542" . 60)
     ("#F2804F" . 70)
     ("#F771AC" . 85)
     ("#eee8d5" . 100))))
 '(hl-bg-colors
   (quote
    ("#DEB542" "#F2804F" "#FF6E64" "#F771AC" "#9EA0E5" "#69B7F0" "#69CABF" "#B4C342")))
 '(hl-fg-colors
   (quote
    ("#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3")))
 '(hl-paren-colors (quote ("#2aa198" "#b58900" "#268bd2" "#6c71c4" "#859900")))
 '(magit-diff-use-overlays nil)
 '(nrepl-message-colors
   (quote
    ("#dc322f" "#cb4b16" "#b58900" "#546E00" "#B4C342" "#00629D" "#2aa198" "#d33682" "#6c71c4")))
 '(pos-tip-background-color "#eee8d5")
 '(pos-tip-foreground-color "#586e75")
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#eee8d5" 0.2))
 '(term-default-bg-color "#fdf6e3")
 '(term-default-fg-color "#657b83")
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#dc322f")
     (40 . "#c9485ddd1797")
     (60 . "#bf7e73b30bcb")
     (80 . "#b58900")
     (100 . "#a5a58ee30000")
     (120 . "#9d9d91910000")
     (140 . "#9595943e0000")
     (160 . "#8d8d96eb0000")
     (180 . "#859900")
     (200 . "#67119c4632dd")
     (220 . "#57d79d9d4c4c")
     (240 . "#489d9ef365ba")
     (260 . "#3963a04a7f29")
     (280 . "#2aa198")
     (300 . "#288e98cbafe2")
     (320 . "#27c19460bb87")
     (340 . "#26f38ff5c72c")
     (360 . "#268bd2"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (quote
    (unspecified "#fdf6e3" "#eee8d5" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#657b83" "#839496")))
 '(xterm-color-names
   ["#eee8d5" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#073642"])
 '(xterm-color-names-bright
   ["#fdf6e3" "#cb4b16" "#93a1a1" "#839496" "#657b83" "#6c71c4" "#586e75" "#002b36"]))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
