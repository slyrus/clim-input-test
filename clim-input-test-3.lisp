
(cl:in-package :clim-input-test)

(defun values-display-3 (frame pane)
  (draw-text* pane (format nil "X: ~A" (x-value frame))
              50 50)
  (draw-text* pane (format nil "Y: ~A" (y-value frame))
              50 100))

(defun update-callback (button)
  (declare (ignore button))
  (let ((x (parse-integer (gadget-value (find-pane-named *application-frame* 'x-pos))))
        (y (parse-integer (gadget-value (find-pane-named *application-frame* 'y-pos)))))
    (setf (x-value *application-frame*) x)
    (setf (y-value *application-frame*) y))
  (let ((values-pane (find-pane-named *application-frame* 'values)))
    (setf (pane-needs-redisplay values-pane) t)
    (clim:redisplay-frame-pane *application-frame* values-pane)))

(define-application-frame clim-input-test-3 ()
  ((x :initform 0 :accessor x-value)
   (y :initform 0 :accessor y-value))
  (:menu-bar clim-input-test-menubar)
  (:panes
   (values (clim:make-pane 'application-pane
                           :name 'values
                           :height 300 :width 300
                           :display-function 'values-display-3))
   (interactor :interactor :height 150 :width 600)
   (x-pos text-field :editable-p t :value "0")
   (y-pos text-field :editable-p t :value "0")
   (update :push-button :label "Update" :activate-callback 'update-callback))
  (:layouts
   (default
       (vertically ()
         (horizontally ()
           (labelling (:label "Values")
             values)
           (labelling (:label "Properties")
             (vertically ()
               (labelling (:label "X Position")
                 x-pos)
               (labelling (:label "Y Position")
                 y-pos)
               update)))
         interactor))))

(define-clim-input-test-3-command (com-quit :name t :menu "Quit")
    ()
  (frame-exit *application-frame*))

(make-command-table 'clim-input-test-3-file-command-table
                    :errorp nil
                    :menu '(("Quit" :command com-quit)))

(make-command-table 'clim-input-test-3-menubar
                    :errorp nil
                    :menu '(("File" :menu clim-input-test-3-file-command-table)))

(defun clim-input-test-3 (&key (new-process t))
  (flet ((run ()
           (let ((frame (make-application-frame 'clim-input-test-3 :x 100 :y 100)))
             (run-frame-top-level frame))))
    (if new-process
        (clim-sys:make-process #'run :name "clim-input-test-3")
        (run))))

