# Changelog
All notable changes to this project will be documented in this file.

## [0.0.4]
### Changed
- Change reachability interval to 5 seconds
- ScreenGrabber class is now not aware of how ESP32 works

### Added
- Turn off when enter sleep. Vice versa.
- Turn off strip when quiting application

### Removed
- Remove Pause/Resume menu item

## [0.0.3]
### Changed
- Removed HTTP and replaced with TCP socket
- LED data size reduced from 7 byte to 3 byte for each LED
- CPU usage dropped from 10 ~ 17% to 0 ~ 2%. Tested on i5 9400
- Add static mode

### Added
- New config to select the location of first LED

## [0.0.2]
### Added
- Pre release

## [0.0.1] - 2014-05-31
### Added
- Initial public availability
