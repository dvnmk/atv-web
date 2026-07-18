# ATV Web Gateway

A self-hosted Apple TV web gateway built with Common Lisp, ESP32 IR control, and MediaMTX streaming.

## Overview

`atv-web` is a Raspberry Pi based system that provides:

* Web control of Apple TV through an ESP32 IR transmitter
* Live Apple TV video streaming to a browser using MediaMTX
* A lightweight Common Lisp (Hunchentoot) web interface
* Simple home-network remote access

The project combines hardware IR control and video streaming into a single web-based interface.

## Architecture

```
Browser
   |
   | HTTP / HLS
   |
Raspberry Pi
   |
   ├── Hunchentoot
   |      └── Web interface
   |
   ├── MediaMTX
   |      └── Apple TV video stream
   |
   └── ESP32 IR Remote
          └── Apple TV control
```

## Features

* Apple TV web remote control
* IR-based power/menu/home navigation
* Live video streaming in a browser
* HLS streaming through MediaMTX
* Common Lisp backend
* ESP32 Wi-Fi IR transmitter
* Daily changing access protection

## Hardware

### Server

* Raspberry Pi
* SBCL Common Lisp
* Hunchentoot
* MediaMTX

### Apple TV Control

* ESP32
* IR LED transmitter

Example firmware:

```
atv-esp-remote/
```

## Project Structure

```
atv-web/
├── atv-web.lisp
├── atv-web.asd
├── package.lisp
├── magic-word.example.lisp
├── atv-esp-remote/
│   ├── atv-esp-remote.ino
│   └── secrets.example.h
└── README.md
```

## Streaming

The video pipeline uses MediaMTX.

Typical flow:

```
Apple TV
   |
HDMI capture
   |
FFmpeg
   |
MediaMTX
   |
HLS (.m3u8)
   |
Web Browser
```

## Setup

### Configure ESP32 Wi-Fi

Copy:

```
secrets.example.h
```

to:

```
secrets.h
```

and add your Wi-Fi credentials.

`secrets.h` is intentionally excluded from Git.

### Run the server

Load the Common Lisp system:

```lisp
(asdf:load-system :atv-web)
```

Start the Hunchentoot server.

## Magic Word

The system includes a private daily access mechanism.

The implementation is not included in the repository.

A template is provided:

```
magic-word.example.lisp
```

## Security

This project is designed for personal home use.

It combines remote control and video streaming, so exposing it directly to the public internet is not recommended without additional authentication and HTTPS.

## License

MIT License

```
```
