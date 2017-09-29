;;; keybindings.el --- keyboard-layout Layer key bindings File for Spacemacs
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Fabien Dubosson <fabien.dubosson@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(kl|config spacemacs
  :description
  "Customize some `spacemacs' bindings."
  :common
  (kl/leader-correct-keys
    "jh"
    "jj"
    "jk"
    "jl"
    ;;
    "jJ"))
