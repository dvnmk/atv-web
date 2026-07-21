# ATV-WEB

A self-hosted web interface for controlling and viewing Apple TV, built with Common Lisp, ESP32-based IR control, and MediaMTX streaming.

![ATV-Web](images/screenshot.png)

## Why?
I wanted to watch and control my Apple TV from Tesla's built-in browser using
only Tesla Premium Connectivity.

ATV-WEB streams the Apple TV as HLS and provides a web-based remote control,
making the Apple TV accessible from anywhere with a browser.

## Overview

`atv-web` is a home Apple TV gateway system that provides:

* Web control of Apple TV through an ESP32 IR transmitter
* Live Apple TV video streaming through MediaMTX
* A lightweight Common Lisp (Hunchentoot) web interface
* Remote access from browsers 

The system separates control and video streaming:

* Raspberry Pi handles web control and automation
* Lenovo laptop handles HDMI capture and video streaming

## Architecture

```
Browser
   |
   | HTTP / HLS
   |
Raspberry Pi
   |
   └── Hunchentoot
          |
          └── ESP32 IR Remote
                 |
                 └── Apple TV control


Apple TV
   |
   | HDMI
   |
Lenovo Laptop
   |
   ├── USB HDMI Capture
   |
   ├── FFmpeg
   |
   └── MediaMTX
          |
          └── HLS Stream
                 |
                 └── Browser
```

## Features

* Apple TV web remote control
* ESP32 IR transmitter
* HDMI capture based Apple TV streaming
* MediaMTX HLS streaming
* Common Lisp backend
* Lightweight home-network deployment
* Daily changing access protection

## Hardware

### Control Server

* Raspberry Pi
* SBCL Common Lisp
* Hunchentoot

### Streaming Server

* Lenovo laptop
* USB HDMI capture device
* FFmpeg
* MediaMTX

### Apple TV Control

* ESP32
* IR LED transmitter

## Project Structure

```
atv-web/
├── atv-web.lisp
├── atv-web.asd
├── package.lisp
├── config.example.lisp
├── magic-word.example.lisp
├── atv-esp-remote/
│   ├── atv-esp-remote.ino
│   └── secrets.example.h
├── scripts/
│   ├── mediamtx.yml
│   ├── mm.sh
│   └── x264.sh
└── README.md
```

## Streaming Pipeline

```
Apple TV
   |
HDMI capture
   |
FFmpeg
   |
MediaMTX
   |
HLS
   |
Web Browser
```
<!--
## Security

This project is designed for personal home use.

The streaming and control interfaces should not be exposed directly to the public internet without proper authentication and HTTPS.
-->
## License

MIT License

```
```
