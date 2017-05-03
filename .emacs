;; Show messages when loading emacs
;;(setq message-log-max t)

;;
;; General settings
;;
(setq my-indent-size 4)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-basic-offset my-indent-size)
 '(column-number-mode t)
 '(ecb-layout-name "left5")
 '(ecb-options-version "2.40")
 '(ecb-primary-secondary-mouse-buttons (quote mouse-1--C-mouse-1))
 '(ecb-tip-of-the-day nil)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(menu-bar-mode nil)
 '(package-selected-packages (quote (haskell-mode)))
 '(scroll-bar-mode (quote right))
 '(scroll-step 1)
 '(sgml-basic-offset my-indent-size)
 '(sh-basic-offset my-indent-size)
 '(show-paren-mode t)
 '(tab-width my-indent-size)
 '(vc-follow-symlinks nil)
 '(vc-handled-backends nil))

(when window-system
  (set-default-font "11")
  (set-background-color "gray10")
  (set-foreground-color "gray90")
  (setq mouse-wheel-scroll-amount '(2 ((shift) . 1) ((control) . nil)))
  (setq mouse-wheel-progressive-speed nil))

(defalias 'yes-or-no-p 'y-or-n-p)

;;
;; My function definitions
;;

;; customize beginning of line
(defun my-beginning-of-line ()
  "Customized beginning-of-line for scala-mode.
Move point to the beginning of text. If invoked again, move point
to beginning of line."
  (interactive)
  (setq my-old-column (current-column))
  (beginning-of-line-text)
  (if (eq (current-column) my-old-column)
      (beginning-of-line)
    (beginning-of-line-text)))

;; customize delete trailing whitespace
(defun my-delete-trailing-whitespace ()
  "Customized delete-trailing-whitespace."
  (interactive)
  (let ((column (current-column)))
    (delete-trailing-whitespace)
    (move-to-column column t)))

;; remove trailing whitespaces before saving
(add-hook 'before-save-hook '(lambda ()
                               (my-delete-trailing-whitespace)))

;; format
(defun fmt (&optional start end)
  (interactive (progn
                 (barf-if-buffer-read-only)
                 (if (use-region-p)
                     (list (region-beginning) (region-end))
                   (list nil nil))))
  (save-excursion
    (let ((start (or start (point-min)))
          (end (or end (point-max))))
      (format-between-points start end))))

(defun format-between-points (start end)
  (untabify start end)
  (indent-region start end)
  (delete-trailing-whitespace start end))     ; uses literal space and tab char

;;
;; Toggle window split
;;
(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))


;;
;; Define functions and customize key map
;;
(global-set-key (kbd "C-x l") 'goto-line)
(global-set-key (kbd "C-x C-l") 'count-lines-page)
(global-set-key (kbd "C-a") 'my-beginning-of-line)
(global-set-key (kbd "C-x p") 'previous-multiframe-window)
(global-set-key (kbd "C-x f") 'find-file-at-point)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(define-key ctl-x-4-map "t" 'toggle-window-split)

;;
;; Setup MELPA
;;
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;;
;; Load custom config
;;
(setq local-custom-file "~/.emacs-custom.el")
(if (file-exists-p local-custom-file)
    (load local-custom-file))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
