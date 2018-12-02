
(cl:in-package :clim-input-test)

(defun values-display (frame pane)
  (draw-text* pane (format nil "X: ~A" (x-value frame))
              50 50)
  (draw-text* pane (format nil "Y: ~A" (y-value frame))
              50 100))

(defun properties-display (frame pane)
  (let (x-pos y-pos)
    (stream-set-cursor-position pane 10 40)
    (stream-write-string pane "X pos:  ")
    (surrounding-output-with-border (pane)
      (setf x-pos
            (with-output-as-gadget (pane)
              (make-pane 'text-field :width 60 :value (princ-to-string (x-value frame))))))
    
    (stream-set-cursor-position pane 10 90)
    (stream-write-string pane "Y pos:  ")
    (surrounding-output-with-border (pane)
      (setf y-pos
            (with-output-as-gadget (pane)
              (make-pane 'text-editor :width 60 :value (princ-to-string (y-value frame))))))
    (stream-set-cursor-position pane 50 150)
    (with-output-as-gadget (pane) 
      (make-pane 'push-button
                 :label "Update"
                 :activate-callback (lambda (button)
                                      (declare (ignore button))
                                      (let ((x (parse-integer (gadget-value x-pos)))
                                            (y (parse-integer (gadget-value y-pos))))
                                        (setf (x-value *application-frame*) x)
                                        (setf (y-value *application-frame*) y))
                                      (let ((values-pane (find-pane-named *application-frame* 'values)))
                                        (setf (pane-needs-redisplay values-pane) t)
                                        (clim:redisplay-frame-pane *application-frame* values-pane)))))))

(define-application-frame clim-input-test ()
  ((x :initform 0 :accessor x-value)
   (y :initform 0 :accessor y-value))
  (:menu-bar clim-input-test-menubar)
  (:panes
   (values (clim:make-pane 'application-pane
                           :name 'values
                           :height 300 :width 300
                           :display-function 'values-display))
   (properties (clim:make-pane 'application-pane
                               :name 'properties
                               :height 200 :width 300
                               :display-function 'properties-display))
   (interactor :interactor :height 150 :width 600))
  (:layouts
   (default
       (vertically ()
         (horizontally ()
           (clim:labelling (:label "Values")
             values)
           (clim:labelling (:label "Properties")
             properties))
         interactor))))

(define-clim-input-test-command (com-quit :name t :menu "Quit")
    ()
  (frame-exit *application-frame*))

(make-command-table 'clim-input-test-file-command-table
                    :errorp nil
                    :menu '(("Quit" :command com-quit)))

(make-command-table 'clim-input-test-menubar
                    :errorp nil
                    :menu '(("File" :menu clim-input-test-file-command-table)))

(defun clim-input-test (&key (new-process t))
  (flet ((run ()
           (let ((frame (make-application-frame 'clim-input-test :x 100 :y 100)))
             (run-frame-top-level frame))))
    (if new-process
        (clim-sys:make-process #'run :name "clim-input-test")
        (run))))

