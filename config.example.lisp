(in-package #:atv-web)

;; Apple TV
(defparameter *atv-id* "APPLE_TV_ID")
(defparameter *atv-ir-host* "http://ESP32_IP")

;; Streaming server
(defparameter *lenovo-user* "USERNAME")
(defparameter *lenovo-host* "SERVER_IP")

(defparameter *stream-host* "YOUR_DOMAIN_OR_IP")
(defparameter *stream-port* 8888)
(defparameter *stream-path* "/webcam/index.m3u8")

(defparameter *stream-url*
  (format nil
          "const url = 'http://~A:~A~A';"
          *stream-host*
          *stream-port*
          *stream-path*))
