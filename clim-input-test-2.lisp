
(cl:in-package :clim-input-test)

(defun values-display-2 (frame pane)
  (draw-text* pane (format nil "X: ~A" (x-value frame))
              50 50)
  (draw-text* pane (format nil "Y: ~A" (y-value frame))
              50 100))

(defun properties-display-2 (frame pane)
  (let (x-pos y-pos)
    (declare (ignore y-pos))
    (stream-set-cursor-position pane 10 30)
    (stream-write-string pane "X pos:  ")
    (surrounding-output-with-border (pane)
      (setf x-pos
            (with-output-as-gadget (pane)
              (make-pane 'text-field :width 60 :value (princ-to-string (x-value frame))))))
    #+nil
    (progn
      (stream-set-cursor-position pane 10 60)
      (stream-write-string pane "Y pos:  ")
      (surrounding-output-with-border (pane)
        (setf y-pos
              (with-output-as-gadget (pane)
                (make-pane 'text-editor :width 60 :value (princ-to-string (y-value frame)))))))
    (stream-set-cursor-position pane 50 90)
    (with-output-as-gadget (pane)
      (make-pane 'push-button
                 :label "Update"
                 :activate-callback (lambda (button)
                                      (declare (ignore button))
                                      (let ((x (parse-integer (gadget-value x-pos)))
                                            (y 300 #+nil (parse-integer (gadget-value y-pos))))
                                        (setf (x-value *application-frame*) x)
                                        (setf (y-value *application-frame*) y))
                                      (let ((values-pane (find-pane-named *application-frame* 'values)))
                                        (setf (pane-needs-redisplay values-pane) t)
                                        (clim:redisplay-frame-pane *application-frame* values-pane)))))))

(define-application-frame clim-input-test-2 ()
  ((x :initform 0 :accessor x-value)
   (y :initform 0 :accessor y-value))
  (:menu-bar clim-input-test-menubar)
  (:panes
   (values (clim:make-pane 'application-pane
                           :name 'values
                           :height 300 :width 300
                           :display-function 'values-display-2))
   (properties-1 (clim:make-pane 'application-pane
                               :name 'properties
                               :height 150 :width 300
                               :display-function 'properties-display-2))
   (properties-2 (clim:make-pane 'application-pane
                               :name 'properties
                               :height 150 :width 300
                               :display-function 'properties-display-2))
   (interactor :interactor :height 150 :width 600))
  (:layouts
   (default
       (vertically ()
         (horizontally ()
           (clim:labelling (:label "Values")
             values)
           (vertically ()
             (clim:labelling (:label "Properties-1")
               properties-1)
             (clim:labelling (:label "Properties-2")
               properties-2)))
         interactor))))

(define-clim-input-test-2-command (com-quit :name t :menu "Quit")
    ()
  (frame-exit *application-frame*))

(make-command-table 'clim-input-test-2-file-command-table
                    :errorp nil
                    :menu '(("Quit" :command com-quit)))

(make-command-table 'clim-input-test-2-menubar
                    :errorp nil
                    :menu '(("File" :menu clim-input-test-2-file-command-table)))

(defun clim-input-test-2 (&key (new-process t))
  (flet ((run ()
           (let ((frame (make-application-frame 'clim-input-test-2 :x 100 :y 100)))
             (run-frame-top-level frame))))
    (if new-process
        (clim-sys:make-process #'run :name "clim-input-test-2")
        (run))))

