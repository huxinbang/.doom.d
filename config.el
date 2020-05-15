;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-buffer-file-coding-system 'utf-8-unix)
(set-clipboard-coding-system 'utf-8-unix)
(set-file-name-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8-unix)
(set-next-selection-coding-system 'utf-8-unix)
(set-selection-coding-system 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)
(setq locale-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(defun +my/better-font()
  (interactive)
  ;; english font
  (if (display-graphic-p)
      (progn
        (set-face-attribute 'default nil :font (format "%s:pixelsize=%d" "Source Code Pro" 13)) ;; 11 13 17 19 23
        ;; chinese font
        (dolist (charset '(kana han symbol cjk-misc bopomofo))
          (set-fontset-font (frame-parameter nil 'font)
                            charset
                            (font-spec :family "Sarasa Mono SC")))) ;; 14 16 20 22 28
    ))

(defun +my|init-font(frame)
  (with-selected-frame frame
    (if (display-graphic-p)
        (+my/better-font))))

(if (and (fboundp 'daemonp) (daemonp))
    (add-hook 'after-make-frame-functions #'+my|init-font)
  (+my/better-font))

(setq org-directory "~/Documents/workload/")
(setq org-default-notes-file (concat org-directory "/notes.org"))
(setq org-log-done t)


;; (setq org-latex-inputenc-alist '(("utf8" . "utf8x")))
;; (setq org-latex-default-packages-alist (cons '("mathletters" "ucs" nil) org-latex-default-packages-alist))
;; (add-to-list 'org-latex-packages-alist '("" "CJKutf8" t))

(setq fonts
      (cond ((eq system-type 'darwin)     '("Monaco"    "STHeiti"))
            ((eq system-type 'gnu/linux)  '("Menlo"     "WenQuanYi Zen Hei"))
            ((eq system-type 'windows-nt) '("Consolas"  "Microsoft Yahei"))))
(set-face-attribute 'default nil :font
                    (format "%s:pixelsize=%d" (car fonts) 14))
(dolist (charset '(kana han symbol cjk-misc bopomofo))
  (set-fontset-font (frame-parameter nil 'font) charset
                    (font-spec :family (car (cdr fonts)))))

;; Fix chinese font width and rescale
(setq face-font-rescale-alist '(("Microsoft Yahei" . 1.2) ("WenQuanYi Micro Hei Mono" . 1.2) ("STHeiti". 1.2)))

(with-eval-after-load 'ox-latex

  (setq org-export-default-language "zh-CN")
;;; ** export html
  (setq org-html-coding-system 'utf-8)
  (setq org-html-head-include-default-style t)
  (setq org-html-head-include-scripts t)

  ;; for export latex
  (add-to-list 'org-latex-classes
               '("ctexart"
                 "\\documentclass[UTF8,a4paper]{ctexart}"
                 ;;"\\documentclass[fontset=none,UTF8,a4paper,zihao=-4]{ctexart}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")
                 )
               )


  (add-to-list 'org-latex-classes
               '("ctexrep"
                 "\\documentclass[UTF8,a4paper]{ctexrep}"
                 ("\\part{%s}" . "\\part*{%s}")
                 ("\\chapter{%s}" . "\\chapter*{%s}")
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 )
               )

  (add-to-list 'org-latex-classes
               '("ctexbook"
                 "\\documentclass[UTF8,a4paper]{ctexbook}"
                 ;;("\\part{%s}" . "\\part*{%s}")
                 ("\\chapter{%s}" . "\\chapter*{%s}")
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 )
               )

  (add-to-list 'org-latex-classes
               '("beamer"
                 "\\documentclass{beamer}
               \\usepackage[fontset=none,UTF8,a4paper,zihao=-4]{ctex}"
                 org-beamer-sectioning)
               )


  (setq org-latex-default-class "ctexart")

  (setq org-latex-pdf-process
        '("xelatex -interaction nonstopmode -output-directory %o %f"
          "xelatex -interaction nonstopmode -output-directory %o %f"
          "xelatex -interaction nonstopmode -output-directory %o %f"))
  ;; ;;  org-mode 8.0
  ;; (setq org-latex-pdf-process '("xelatex -interaction nonstopmode %f"
  ;;                               "xelatex -interaction nonstopmode %f"))


  ;; (setq tex-compile-commands '(("xelatex %r")))
  ;; (setq tex-command "xelatex")
  ;; (setq-default TeX-engine 'xelatex)
  )


;; ====================
;; insert date and time

(defvar current-date-time-format "%Y-%m-%d %H:%M:%S %z"
  "Format of date to insert with `insert-current-date-time' func
See help of `format-time-string' for possible replacements")

(defvar current-time-format "%H:%M:%S"
  "Format of date to insert with `insert-current-time' func.
Note the weekly scope of the command's precision.")

(defun insert-current-date-time ()
  "insert the current date and time into current buffer.
Uses `current-date-time-format' for the formatting the date/time."
  (interactive)
                                        ;       (insert (let () (comment-start)))
  (insert (format-time-string current-date-time-format (current-time)))
  )

(defun insert-current-time ()
  "insert the current time (1-week scope) into the current buffer."
  (interactive)
  (insert (format-time-string current-time-format (current-time)))
  )
;;(global-set-key "\C-c\C-d" 'insert-current-date-time)
;;(global-set-key "\C-c\C-t" 'insert-current-time)
