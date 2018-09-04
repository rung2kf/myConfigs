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


;;------------------------------------
;; manually installed packages
;; clone from https://github.com/emacs-evil/evil-collection.git; i changed some keymappings.
(add-to-list 'load-path (expand-file-name "~/.emacs.d/evil-collection" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/evil-leader" user-emacs-directory))


;;------------------------------------
;; auto-install if pkg doesn't exist
(setq my:el-get-packages
      '(evil
        helm
        projectile
        evil-numbers
        evil-surround
        evil-commentary
        evil-matchit
;;        emacs-w3  ;requires cvs to be installed via homebrew
        magit))
(el-get 'sync my:el-get-packages)
(el-get 'sync)


;;------------------------------------
(setq evil-want-integration nil)  ; required for evil-collection
(require 'evil)
(require 'evil-commentary)
(require 'evil-surround)
(require 'evil-numbers)
(require 'evil-matchit)
(require 'evil-collection)
(require 'evil-leader)
;;(require 'eww-lnum)
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


;;------------------------------------
;;Enable keybindings
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


;;------------------------------------
;;evil-leader dynamic key binding customizations
(global-evil-leader-mode)
(evil-leader/set-leader "|")    ; change leader key
(evil-leader/set-key
  "f" 'eww-lnum-follow)
;;  "<up>" 'eww-lnum-follow)


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
