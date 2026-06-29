;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
(setq doom-font (font-spec :family "Jetbrains Mono" :size 11.0))
(setq doom-variable-pitch-font (font-spec :family "Inter" :size 11.0))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/Org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq-default show-trailing-whitespace t)

(use-package! ghostel
  :config
  (set-popup-rule! "^\\*ghostel" :size 0.3 :vslot -4 :select t :quit nil :ttl 0)
  (defun +ghostel/toggle ()
    "Toggle a ghostel popup window."
    (interactive)
    (if-let ((buf (seq-find (lambda (b) (with-current-buffer b (derived-mode-p 'ghostel-mode)))
                            (buffer-list))))
        (if-let ((win (get-buffer-window buf)))
            (delete-window win)
          (pop-to-buffer buf))
      (ghostel)))
  (defun +ghostel/here ()
    "Open ghostel in the current window."
    (interactive)
    (switch-to-buffer
     (or (seq-find (lambda (b) (with-current-buffer b (derived-mode-p 'ghostel-mode)))
                   (buffer-list))
         (save-window-excursion
           (ghostel)
           (current-buffer)))))
  (map! :leader
        :desc "Terminal" "o t" #'+ghostel/toggle
        :desc "Terminal here" "o T" #'+ghostel/here)
  (add-hook 'ghostel-mode-hook (lambda () (setq show-trailing-whitespace nil))))

(use-package! evil-ghostel
  :after (ghostel evil)
  :hook (ghostel-mode . evil-ghostel-mode))

;; Use the ISO date format in org-journal, rename the journal directory
(use-package! org-journal
  :config (setq org-journal-date-format "%A, %Y-%m-%d"
                org-journal-dir (file-name-concat org-directory "Journal/")))

;; Disable line numbers in Org
(add-hook! org-mode #'doom-disable-line-numbers-h)

;; Define a function to insert the current date
(defun insert-current-date ()
  "Insert today's date into the current buffer."
  (interactive)
  (insert (format-time-string "%Y-%m-%d" (current-time))))
(map! :leader :desc "Current date" "i d" #'insert-current-date)

;; The (org +pretty) flag enables org-modern which I don't want.
(remove-hook! org-mode #'org-modern-mode)
;; Enable org-appear link previews.
(use-package! org-appear
  :config (setq org-appear-autolinks t))

;; Add all Org files to the Org Agenda
(setq org-agenda-files
      (delete-dups
       (mapcar #'file-name-directory
               (directory-files-recursively org-directory "\\.org$"))))
(add-to-list 'org-agenda-files org-journal-dir)
(setq org-agenda-file-regexp "\\`\\\([^.].*\\.org\\\|[0-9]\\\{8\\\}\\\(\\.gpg\\\)?\\\)\\'")

;; Add a way to toggle nyan mode
(map! :leader :desc "Nyan mode" "t n" #'nyan-mode)

;; Enable auto saving files
(auto-save-visited-mode 1)

(use-package! agent-shell
  :config
  (setq agent-shell-display-action nil)
  (set-popup-rule! "^Claude Agent @" :side 'right :size 0.4 :select t :quit nil :ttl 0)
  (defun +agent-shell/toggle-sidebar ()
    "Toggle an agent-shell popup sidebar."
    (interactive)
    (if-let ((buf (seq-find (lambda (b) (with-current-buffer b (derived-mode-p 'agent-shell-mode)))
                            (buffer-list))))
        (if-let ((win (get-buffer-window buf)))
            (delete-window win)
          (pop-to-buffer buf))
      (agent-shell)))
  (map! :leader (:prefix ("o s" . "Agent Shell")
                 :desc "Toggle sidebar" "s" #'+agent-shell/toggle-sidebar
                 :desc "Send file"      "f" #'agent-shell-send-file
                 :desc "Send region"    "r" #'agent-shell-send-region
                 :desc "New shell"      "n" #'agent-shell-new-shell
                 :desc "Switch buffer"  "b" #'agent-shell-switch-buffer))
  (setq agent-shell-preferred-agent-config (agent-shell-anthropic-make-claude-code-config))
  (setq agent-shell-anthropic-default-session-mode-id "auto")
  (setq agent-shell-session-restore-verbosity 'full)
  (defun +agent-shell/dot-subdir (subdir)
    (let* ((cwd (string-remove-suffix "/" (agent-shell-cwd)))
           (sanitized (replace-regexp-in-string "/" "-" (string-remove-prefix "/" cwd))))
      (expand-file-name subdir (locate-user-emacs-file (concat "agent-shell/" sanitized)))))
  (setopt agent-shell-dot-subdir-function #'+agent-shell/dot-subdir)
  ;; This solves an issue where agent shell output wouldn't scroll after submitting a prompt
  (after! shell-maker
    (advice-add 'shell-maker--write-partial-reply :after
                (lambda (&rest _)
                  (when-let ((proc (shell-maker--process))
                             (buf (process-buffer proc))
                             (proc-mark (process-mark proc)))
                    (dolist (win (get-buffer-window-list buf nil t))
                      (when (< (window-point win) proc-mark)
                        (set-window-point win proc-mark))
                      (when (= (window-point win) proc-mark)
                        (with-selected-window win
                          (recenter (- -1 scroll-margin)))))))))
  (add-hook 'diff-mode-hook
            (lambda ()
              (when (string-match-p "\\*agent-shell-diff\\*" (buffer-name))
                (evil-emacs-state)))))
