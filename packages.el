;;; config.el --- keyboard-layout Layer Packages File for Spacemacs
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Fabien Dubosson <fabien.dubosson@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst keyboard-layout-packages
  '(
    ace-window
    avy
    buffer-move
    comint-mode
    company
    elfeed
    evil
    evil-escape
    evil-evilified-state
    evil-surround
    eyebrowse
    flycheck
    helm
    ivy
    magit
    neotree
    org
    org-agenda
    ranger
    ))

(defun keyboard-layout/pre-init-ace-window ()
  (kl|config ace-window
    :description
    "Remap `ace-window' bindings, and change the keys to the ones
   on the central row."
    :loader
    (spacemacs|use-package-add-hook ace-window :post-init BODY)
    :bepo
    (progn
      ;; HACK: Manual binding, otherwise conflicts with evil-window auto
      ;; remapping.
      (spacemacs/set-leader-keys
        "wC" 'evil-window-move-far-left
        "wL" 'ace-delete-window
        "wQ" 'ace-delete-window)
      (setq aw-keys '(?t ?e ?s ?i ?r ?u ?n ?a)))))

(defun keyboard-layout/pre-init-avy ()
  (kl|config avy
    :description
    "Change `avy' keys to the ones on the central row."
    :loader
    (spacemacs|use-package-add-hook avy :post-init BODY)
    :bepo
    (setq-default avy-keys '(?t ?e ?s ?i ?r ?u ?n ?a ?c ?,))))

(defun keyboard-layout/pre-init-buffer-move ()
  (kl|config buffer-move
    :description
    "Remap `buffer-move' bindings."
    :loader
    (with-eval-after-load 'buffer-move BODY)
    :common
    (kl/leader-correct-keys
      "bmh"
      "bmj"
      "bmk"
      "bml")))

(defun keyboard-layout/pre-init-comint-mode ()
  (kl|config comint-mode
    :description
    "Remap `comint-mode' bindings."
    :loader
    (with-eval-after-load 'shell BODY)
    :common
    (dolist (m '(normal insert))
      (eval `(kl/evil-correct-keys `,m comint-mode-map
               "C-j"
               "C-k")))))

(defun keyboard-layout/pre-init-company ()
  (kl|config company
    :description
    "Remap `company' bindings."
    :loader
    (spacemacs|use-package-add-hook company :post-config BODY)
    :common
    (kl/correct-keys company-active-map
      "C-h"
      "C-j"
      "C-k"
      "C-l")))

(defun keyboard-layout/pre-init-elfeed ()
  (kl|config elfeed
    :description
    "Remap `elfeed' bindings."
    :loader
    (spacemacs|use-package-add-hook elfeed :post-config BODY)
    :common
    (progn
      (kl/evil-correct-keys 'evilified elfeed-search-mode-map
        "j"
        "k")
      (kl/evil-correct-keys 'evilified elfeed-show-mode-map
        "C-j"
        "C-k")
      ;; HACK: The auto correction doesn't work... mystery.
      (evil-define-key 'evilified elfeed-search-mode-map
        "k" 'elfeed-search-live-filter))))

(defun keyboard-layout/post-init-evil ()
  (kl|config evil
    :description
    "Remap `evil' bindings, and map some unused ones as aliases."
    :common
    (dolist (map kl--all-evil-states-but-insert)
      (kl/correct-keys map
        "h"
        "j"
        "k"
        "l"
        ;;
        "H"
        "J"
        "K"
        "L"
        ;;
        "gj"
        "gk"))
    :bepo
    (progn
      (kl/set-in-all-evil-states-but-insert
        "é" 'evil-forward-word-begin
        "É" 'evil-forward-WORD-begin)
      (kl/set-in-state evil-inner-text-objects-map
        "é" 'evil-inner-word
        "É" 'evil-inner-WORD)
      (kl/set-in-state evil-outer-text-objects-map
        "é" 'evil-a-word
        "É" 'evil-a-WORD)
      (kl/set-in-all-evil-states-but-insert
        "«" 'evil-shift-left
        "»" 'evil-shift-right)))

  (kl|config evil-window
    :description
    "Remap `evil-window' bindings. Add `é' as an alias for `w' and
   `q' for closing."
    :common
    (kl/leader-correct-keys
      "wh"
      "wj"
      "wk"
      "wl"
      ;;
      "wH"
      "wJ"
      "wK"
      "wL")
    :bepo
    (progn
      (spacemacs/set-leader-keys
        "wé" 'other-window
        "wq" 'delete-window)
      (kl/leader-alias-of "é" "w"))))

(defun keyboard-layout/pre-init-evil-escape ()
  (kl|config evil-escape
    :description
    "Change `evil-escape' default escape combination for a better
   one than `fd'."
    :loader
    (spacemacs|use-package-add-hook evil-escape :post-init BODY)
    :bepo
    (setq-default evil-escape-key-sequence "gq")))

(defun keyboard-layout/pre-init-evil-evilified-state ()
  (kl|config evil-evilified-state
    :description
    "Remap `evil-evilified-state' bindings."
    :loader
    (with-eval-after-load 'evil-evilified-state BODY)
    :common
    (kl/correct-keys evil-evilified-state-map
      "h"
      "j"
      "k"
      "l")))

(defun keyboard-layout/pre-init-evil-surround ()
  (kl|config evil-surround
    :description
    "Remap `evil-surround' bindings and add the `« »' pair."
    :loader
    (spacemacs|use-package-add-hook evil-surround :post-init BODY)
    :common
    (kl/evil-correct-keys 'visual evil-surround-mode-map "s")
    :bepo
    (setq-default evil-surround-pairs-alist
                  (append '((?» "«" . "»") (?« "« " . " »")) evil-surround-pairs-alist))))

(defun keyboard-layout/pre-init-eyebrowse ()
  (kl|config eyebrowse
    :description
    "Remap `eyebrowse' keybindings conflicting with evil."
    :loader
    (spacemacs|use-package-add-hook eyebrowse :post-init BODY)
    :common
    (kl/correct-keys evil-motion-state-map
      "gj"
      "gJ")))

(defun keyboard-layout/pre-init-flycheck ()
  (kl|config flycheck-error-list
    :description
    "Remap `flycheck-error-list' bindings."
    :loader
    (spacemacs|use-package-add-hook flycheck :post-init BODY)
    :common
    (kl/evil-correct-keys 'evilified flycheck-error-list-mode-map
      "j"
      "k")))

(defun keyboard-layout/pre-init-helm ()
  (kl|config helm
    :description
    "Remap `helm' bindings."
    :loader
    (spacemacs|use-package-add-hook helm :post-config BODY)
    :common
    (kl/correct-keys helm-map
      "C-h"
      "C-j"
      "C-k"
      "C-l"))

  (kl|config helm-buffers
    :description
    "Remap `helm-buffers' bindings."
    :loader
    (with-eval-after-load 'helm-buffers BODY)
    :bepo
    ;; HACK: Forced to correct wrong behaviour
    (kl/set-in-state helm-buffer-map "C-s" 'helm-previous-line))

  (kl|config helm-files
    :description
    "Remap `helm-files' bindings."
    :loader
    (with-eval-after-load 'helm-files BODY)
    :bepo
    (progn
      ;; HACK: Forced to correct wrong behaviour
      (kl/set-in-state helm-find-files-map "C-s" 'helm-previous-line)
      (kl/set-in-state helm-find-files-map "C-k" 'helm-ff-run-grep)
      (kl/set-in-state helm-find-files-map "C-r" 'helm-maybe-exit-minibuffer)
      (kl/set-in-state helm-read-file-map "C-s" 'helm-previous-line)
      (kl/set-in-state helm-read-file-map "C-K" 'helm-previous-line)))

  (kl|config helm-locate
    :description
    "Remap `helm-locate' bindings."
    :loader
    (with-eval-after-load 'helm-locate BODY)
    :bepo
    (progn
      ;; HACK: Forced to correct wrong behaviour
      (kl/set-in-state helm-generic-files-map "C-s" 'helm-previous-line)
      (kl/set-in-state helm-generic-files-map "C-k" 'helm-ff-run-grep))))

(defun keyboard-layout/pre-init-ivy ()
  (kl|config ivy
    :description
    "Remap `ivy' bindings."
    :loader
    (spacemacs|use-package-add-hook ivy :post-config BODY)
    :common
    (progn
      (kl/correct-keys ivy-minibuffer-map
        "C-h"
        "C-j"
        "C-k"
        "C-l"))))

(defun keyboard-layout/pre-init-magit ()
  (kl|config magit
    :description
    "Remap `magit' bindings."
    :loader
    (spacemacs|use-package-add-hook magit :post-config BODY)
    :common
    (progn
      (kl/evil-correct-keys evil-magit-state magit-mode-map
        "j"
        "k"
        "C-j"
        "C-k")
      (kl/evil-correct-keys 'normal evil-magit-toggle-text-minor-mode-map
        "C-j")
      (dolist (map (list magit-branch-section-map
                         magit-commit-section-map
                         magit-file-section-map
                         magit-hunk-section-map
                         magit-remote-section-map
                         magit-staged-section-map
                         magit-unstaged-section-map
                         magit-module-commit-section-map
                         magit-stash-section-map
                         magit-stashes-section-map
                         magit-tag-section-map
                         magit-unpulled-section-map
                         magit-unpushed-section-map
                         magit-untracked-section-map))
        (kl/correct-keys map
          "j"
          "k"
          "C-j"
          "C-k")))
    :bepo
    (progn
      (magit-change-popup-key 'magit-dispatch-popup :actions ?t ?j)
      (magit-change-popup-key 'magit-dispatch-popup :actions ?s ?k)
      (magit-change-popup-key 'magit-dispatch-popup :actions ?S ?K))))

(defun keyboard-layout/pre-init-neotree ()
  (kl|config neotree
    :descripition
    "Remap `neotree' bindings."
    :loader
    (spacemacs|use-package-add-hook neotree :post-config BODY)
    :common
    (progn
      (kl/evil-correct-keys 'evilified neotree-mode-map
        "h"
        "j"
        "k"
        "l"
        ;;
        "H"
        "J"
        "K"
        "L")
      (kl/set-in-state (evil-get-auxiliary-keymap neotree-mode-map 'evilified)
        "h" 'neotree-hidden-file-toggle
        "k" 'neotree-rename-node))))

(defun keyboard-layout/pre-init-org ()
  (kl|config org
    :description
    "Remap keys in `org-mode'."
    :loader
    (with-eval-after-load 'org BODY)
    :bepo
    (progn
      (evil-define-key 'normal evil-org-mode-map
        "t" 'evil-next-line
        "j" 'org-todo)
      (dolist (m '(normal insert))
        (eval `(evil-define-key ',m evil-org-mode-map
                 ;; ctsr
                 (kbd "M-c") 'org-metaleft
                 (kbd "M-t") 'org-metadown
                 (kbd "M-s") 'org-metaup
                 (kbd "M-r") 'org-metaright
                 (kbd "M-C") 'org-shiftmetaleft
                 (kbd "M-T") 'org-shiftmetadown
                 (kbd "M-S") 'org-shiftmetaup
                 (kbd "M-R") 'org-shiftmetaright
                 ;; hjkl
                 (kbd "M-h") 'capitalize-word
                 (kbd "M-j") 'transpose-chars
                 (kbd "M-k") 'kill-sentence
                 (kbd "M-l") 'move-to-window-line-top-bottom
                 (kbd "M-H") 'capitalize-word
                 (kbd "M-J") 'transpose-chars
                 (kbd "M-K") 'kill-sentence
                 (kbd "M-L") 'move-to-window-line-top-bottom)))
      (spacemacs/set-leader-keys-for-major-mode 'org-mode
        ;; ctsr
        "C-S-c" 'org-shiftcontrolleft
        "C-S-t" 'org-shiftcontroldown
        "C-S-s" 'org-shiftcontrolup
        "C-S-r" 'org-shiftcontrolright
        ;; hjkl
        "C-S-h" nil
        "C-S-j" nil
        "C-S-k" nil
        "C-S-l" nil)
      (evil-define-key 'normal evil-org-mode-map
        ;; ctsr
        "gt" 'org-forward-heading-same-level
        "gs" 'org-backward-heading-same-level
        ;; hjkl
        "gj" nil
        "gk" nil
        ;; additional
        (kbd "«") 'org-metaleft
        (kbd "»") 'org-metaright))))

(defun keyboard-layout/pre-init-org-agenda ()
  (kl|config org-agenda
    :description
    "Remap `org-agenda' bindings."
    :loader
    (spacemacs|use-package-add-hook org-agenda :post-config BODY)
    :common
    (kl/evil-correct-keys 'evilified org-agenda-mode-map
      "j"
      "k"
      "M-h"
      "M-j"
      "M-k"
      "M-l")))

(defun keyboard-layout/pre-init-ranger ()
  (kl|config ranger
    :description
    "Remap navigation keys in `ranger'."
    :loader
    (with-eval-after-load 'ranger BODY)
    :common
    (kl/correct-keys ranger-mode-map
      "h"
      "j"
      "k"
      "l"
      ;;
      "H"
      "K"
      "J"
      "L")))
