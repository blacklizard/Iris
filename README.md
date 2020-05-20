# Iris
Iris - An almost Nanoleaf screen mirror clone

## Requirement
- macOS 10.12 and above
- ESP32
- A reliable WiFi AP/router

## Installation
Prepare [ESP32 Controller](https://github.com/blacklizard/Iris-ESP32-Controller). Download Iris from release page, move the app to application folder. 

Preference panel will open if setting is incomplete, please fill up with all the necessary information

When asked for screen recording permission, please allow so that the app can record the screen.

## Settings

1. `Controller IP` IP address of your ESP32. Ex: `192.168.1.100`
2. `LED Count` Number of LED in your strip. Ex: `500`
3. `LED Direction` - `RIGHT TO LEFT` (First LED at your right). `LEFT TO RIGHT` (First LED at your left)
4. `Use static color` Choose a static color instead of mirroring screen 

## In case of disconnected controller
The app will try to connect to the controller every 5 second until the connection is established. Once connection is established, the app will resume to send the display data to the controller.

## How to choose screen
Currently the app will record main display based on your `Display` preferences

## Dependency
1. [BlueSocket](https://github.com/IBM-Swift/BlueSocket)
## Demo
[![DEMO](https://img.youtube.com/vi/C9QXhIt1I5A/0.jpg)](https://www.youtube.com/watch?v=C9QXhIt1I5A)

## Changelog
[CHANGELOG](CHANGELOG.md)

## License
[MIT](LICENSE)
