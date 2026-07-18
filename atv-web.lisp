(in-package :atv-web)

(setf hunchentoot:*session* t)
(setf hunchentoot:*session-max-time* (* 60 60))

(defun require-auth ()
  (unless (hunchentoot:session-value :auth)
    (hunchentoot:redirect "/")
    (hunchentoot:abort-request-handler)))

(define-easy-handler (logout-handler :uri "/logout") ()
  (setf (hunchentoot:session-value :auth) nil)
    (hunchentoot:redirect "/"))

;; (define-easy-handler (logout-handler :uri "/logout") ()
;;   (hunchentoot:remove-session)
;;   (hunchentoot:redirect "/"))

(define-easy-handler (index :uri "/") ()
  (let ((pw (hunchentoot:parameter "mw")))
    ;; login attempt
    (when (and pw (string= pw (today-magic-word)))
      (setf (hunchentoot:session-value :auth) t))
    ;; already authenticated
    (if (hunchentoot:session-value :auth)

"
<!DOCTYPE html>
<html>
<head>
<meta charset='utf-8'>
<title>ATV-WEB</title>
<script src='https://cdn.jsdelivr.net/npm/hls.js'></script>
</head>

<body>

<video id='video'
       controls
       autoplay
       muted
       playsinline
       style='width:98vw'>
</video>
<br>

<style>
button {
    width: 50px;
    height: 50px;
    margin: 4px;

    font-size: 20px;
    font-weight: bold;

    border: 1px solid #666;
    border-radius: 8px;

    background: #f2f2f2;
    color: #222;

    -webkit-tap-highlight-color: transparent;
    transition: transform 0.08s ease,
                background-color 0.08s ease;
}

.nav-btn {
    width: 70px;
}

.text-btn {
    min-width: 70px;
    padding: 0 12px;
}

.start-btn {
    background: #28a745;      /* Green */
}

.stop-btn {
    background: #dc3545;      /* Red */
}

.status-btn {
    background: #6c757d;      /* Gray */
}

.menu-btn {
    background: #ff9800;      /* Orange */
}

.ctr-btn {
    background: #8e44ad;      /* Purple */
}

.kill-btn {
    background: #000000;      /* Black */
    color: #ff9800;
}

.blank {
    visibility: hidden;
    witdh: 50px;
}

button:active {
    background: #8e44ad;
    color: white;
    transform: scale(0.9);
}
</style>

<button class=\"text-btn menu-btn\" onclick=\"document.getElementById('video').muted=false\">UMT</button>
<button class=\"text-btn\" onclick=\"fetch('/atv/pre')\">|\<</button>
<button class=\"text-btn\" onclick=\"fetch('/atv/rwd')\">\<\<</button>

<button class=\"text-btn\" onclick=\"fetch('/atv/play')\">\>||</button>
<!--
<button class=\"text-btn\" onclick=\"fetch('/atv/pause')\">||</button>
-->
<button class=\"text-btn\" onclick=\"fetch('/atv/stop')\">[]</button>

<button class=\"text-btn\" onclick=\"fetch('/atv/fwd')\">\>\></button>
<button class=\"text-btn\" onclick=\"fetch('/atv/nxt')\">\>|</button>

<button class=\"text-btn\" onclick=\"fetch('/atv/beg')\">-10S</button>
<button class=\"text-btn\" onclick=\"fetch('/atv/end')\">+10S</button>


<br>
<button class=\"menu-btn nav-btn\" onclick=\"fetch('/atv/menu')\">MNU</button>
<button class=\"nav-btn\" onclick=\"fetch('/atv/up')\">^</button>
<button class=\"menu-btn nav-btn\" onclick=\"fetch('/atv/home')\">HME</button>

<button class=\"nav-btn blank\" disabled>x</button>



<button class=\"text-btn start-btn\" onclick=\"fetch('/atv/turn_on')\">STA</button> 

<button class=\"text-btn stop-btn\" onclick=\"fetch('/atv/turn_off')\">STP</Button>
<button class=\"nav-btn\" onclick=\"
fetch('/atv/status')
  .then(r => r.text())
  .then(t => document.getElementById('status').textContent = t);
\">ATV</button>

<button class=\"nav-btn blank\" disabled>x</button>
<button class=\"nav-btn status-btn\" onclick=\"refreshStream()\">RFR</button>
<br>

<button class=\"nav-btn\" onclick=\"fetch('/atv/left')\">\<</button>
<button class=\"nav-btn\" onclick=\"fetch('/atv/select')\">S</button>
<button class=\"nav-btn\" onclick=\"fetch('/atv/right')\">\></button>
<button class=\"nav-btn blank\" disabled>x</button>

<button class=\"text-btn start-btn\" onclick=\"fetch('/ffmpeg/start')\">STA</button>
<button class=\"text-btn stop-btn\" onclick=\"fetch('/ffmpeg/stop')\">STP</button>
<button class=\"text-btn\"  onclick=\"
fetch('/ffmpeg/status')
  .then(r => r.text())
  .then(t => document.getElementById('status').textContent = t);
\">FMP</button>

<button class=\"nav-btn blank\" disabled>x</button>
<button class=\"text-btn stop-btn\" onclick=\"location.href='/logout'\">
OUT
</button>

<br>

<button class=\"ctr-btn nav-btn\" onclick=\"fetch('/atv/home/2')\">SWT</button>
<button class=\"nav-btn\" onclick=\"fetch('/atv/down')\">v</button>
<button class=\"ctr-btn nav-btn\" onclick=\"fetch('/atv/home/hold')\">CTR</button>

<button class=\"nav-btn blank\" disabled>x</button>

<button class=\"text-btn start-btn\" onclick=\"fetch('/mediamtx/start')\">STA</button>
<button class=\"text-btn stop-btn\" onclick=\"fetch('/mediamtx/stop')\">STP</button>
<button class=\"text-btn\" onclick=\"
fetch('/mediamtx/status')
  .then(r => r.text())
  .then(t => document.getElementById('status').textContent = t);
\">MTX</button>


<button class=\"blank nav-btn\" disabled>x</button>

<button class=\"text-btn kill-btn\" onclick=\"
if (confirm('Stop the Hunchentoot server?'))
    fetch('/kill');\">KIL</button>

<button class=\"kill-btn text-btn\" onclick=\"
if (confirm('Suspend the MediaMTX server?'))
    fetch('/lenovo/suspend')\">SUS</button>

<hr>
<pre id=\"status\"></pre>
<hr>

<script>
const video = document.getElementById('video');
const url = 'http://gnsk.iptime.org:8888/webcam/index.m3u8';

let hls = null;

function loadStream() {
    if (Hls.isSupported()) {

        if (hls) {
            hls.destroy();
        }

        hls = new Hls();

        hls.loadSource(url + '?t=' + Date.now());
        hls.attachMedia(video);

    } else if (video.canPlayType('application/vnd.apple.mpegurl')) {

        video.src = url + '?t=' + Date.now();
        video.load();
    }
}

loadStream();

function refreshStream() {
    loadStream();
}
</script>

</body>
</html>
"

"
<!DOCTYPE html>
<html>
<head>
<meta charset='utf-8'>
<title>ATV-WEB</title>
</head>

<body>
<form>
<input type='password' name='mw'>
<input type='submit' value='Enter'>
</form>
</body>
"
)))

(defun atv-command (cmd)
  (uiop:run-program
   (list "atvremote"
	 "--id"
	 "56:DE:61:E6:C5:17"
	 cmd)
   :output :string))

(defparameter *atv-ir-host* "http://192.168.0.128")

(defun atv-ir (cmd)
  (dex:get
   (format nil "~a/~a" *atv-ir-host* cmd)))

(define-easy-handler (atv-turn_on-handler :uri "/atv/turn_on") ()
  (require-auth)
  (atv-command "turn_on"))
(define-easy-handler (atv-off-handler :uri "/atv/turn_off") ()
  (require-auth)
  (atv-command "turn_off"))
(define-easy-handler (atv-down-handler :uri "/atv/down") ()
  (require-auth)
  (atv-ir "down"))
(define-easy-handler (atv-up-handler :uri "/atv/up") ()
  (require-auth)
  (atv-ir "up"))
(define-easy-handler (atv-left-handler :uri "/atv/left") ()
  (require-auth)
  (atv-ir "left"))
(define-easy-handler (atv-right-handler :uri "/atv/right") ()
  (require-auth)
  (atv-ir "right"))
(define-easy-handler (atv-select-handler :uri "/atv/select") ()
  (require-auth)
  (atv-ir "select"))
(define-easy-handler (atv-menu-handler :uri "/atv/menu") ()
  (require-auth)
  (atv-ir "menu"))
(define-easy-handler (atv-home-handler :uri "/atv/home") ()
  (require-auth)
  (atv-ir "home"))

(define-easy-handler (atv-select-hold-handler :uri "/atv/select/hold") ()
  (require-auth)
  (atv-ir "select/hold"))

(define-easy-handler (atv-control-handler :uri "/atv/home/hold") ()
  (require-auth)
  (atv-ir "home/hold"))
(define-easy-handler (atv-switch-handler :uri "/atv/home/2") ()
  (require-auth)
  (atv-ir "home/2"))

(define-easy-handler (atv-play-handler :uri "/atv/play") ()
  (require-auth)
  (atv-ir "play"))
(define-easy-handler (atv-pause-handler :uri "/atv/pause") ()
  (require-auth)
  (atv-ir "pause"))
(define-easy-handler (atv-stop-handler :uri "/atv/stop") ()
  (require-auth)
  (atv-ir "stop"))
(define-easy-handler (atv-rwd-hadler :uri "/atv/rwd") ()
  (require-auth)
  (atv-ir "rwd"))
(define-easy-handler (atv-fwd-handler :uri "/atv/fwd") ()
  (require-auth)
  (atv-ir "fwd"))
(define-easy-handler (atv-pre-handler :uri "/atv/pre") ()
  (require-auth)
  (atv-ir "pre"))
(define-easy-handler (atv-nxt-handler :uri "/atv/nxt") ()
  (require-auth)
  (atv-ir "nxt"))
(define-easy-handler (atv-beg-handler :uri "/atv/beg") ()
  (require-auth)
  (atv-ir "beg"))
(define-easy-handler (atv-end-handler :uri "/atv/end") ()
  (require-auth)
  (atv-ir "end"))

(define-easy-handler (atv-status :uri "/atv/status") ()
  (require-auth)
  (handler-case
      (multiple-value-bind (body status headers)
          (dex:get (format nil "~A/status" *atv-ir-host*))
        (declare (ignore headers))
        (format nil "ATV IR: ~A (HTTP ~A)" body status))
    (error (e)
      (setf (hunchentoot:return-code*) 503)
      (format nil "ATV IR ERROR: ~A" e))))

;; lenovo control
(defparameter *lenovo-user* "gnsk")
(defparameter *lenovo-host* "192.168.0.22")

(defun lenovo-systemctl (action service)
  (uiop:run-program
   (list "ssh"
         (format nil "~a@~a" *lenovo-user* *lenovo-host*)
         "systemctl"
         "--user"
         action
         service)
   :output :string
   :error-output :string
   :ignore-error-status t))

(hunchentoot:define-easy-handler (madiamtx-start-handler :uri "/mediamtx/start") ()
  (require-auth)
  (lenovo-systemctl "start" "mediamtx.service")
  "Mediamtx started")

(hunchentoot:define-easy-handler (mediamtx-stop-handler :uri "/mediamtx/stop") ()
  (require-auth)
  (lenovo-systemctl "stop" "mediamtx.service")
  "Mediamtx stopped")

(define-easy-handler (mediamtx-status-handler :uri "/mediamtx/status") ()
  (require-auth)
  (setf (hunchentoot:content-type*) "text/plain; charset=utf-8")
  (lenovo-systemctl "status" "mediamtx.service"))

(hunchentoot:define-easy-handler (stream-on-handler :uri "/ffmpeg/start") ()
  (require-auth)
  (lenovo-systemctl "start" "ffmpeg-x264.service")
  "FFmpeg-x264 started")

(hunchentoot:define-easy-handler (stream-off-handler :uri "/ffmpeg/stop") ()
  (require-auth)
  (lenovo-systemctl "stop" "ffmpeg-x264.service")
  "FFmpeg-x264 stopped")

(define-easy-handler (ffmpeg-status-handler :uri "/ffmpeg/status") ()
  (require-auth)
  (setf (hunchentoot:content-type*) "text/plain; charset=utf-8")
  (lenovo-systemctl "status" "ffmpeg-x264.service"))

(defun lenovo-suspend ()
  (uiop:run-program
   "ssh lenovo sudo systemctl suspend"))

(define-easy-handler (lenovo-suspend-handler :uri "/lenovo/suspend") ()
  (require-auth)
  (lenovo-suspend)
  "Lenovo suspend")

;;;; server
(defparameter *web-port* 3931)
(defvar *server* nil)

(defun start-server ()
  (unless *server*
    (setf *server*
          (hunchentoot:start
           (make-instance 'hunchentoot:easy-acceptor
                          :port *web-port*)))))

(defun stop-server ()
  (when *server*
    (hunchentoot:stop *server*)
    (setf *server* nil)))

(define-easy-handler (kill-switch :uri "/kill") ()
  (require-auth)
  (setf (hunchentoot:content-type*) "text/plain; charset=utf-8")
  ;; Send the response first, then stop the server shortly after.
  (bt:make-thread
   (lambda ()
     (sleep 0.5)
     (stop-server)))
  "Stopping server...")

(unless *server*
  (start-server))
