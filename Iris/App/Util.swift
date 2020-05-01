//
//  Util.swift
//  Iris
//
//  Created by blacklizard on 20/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//
import Foundation
import Cocoa

extension NSColor {
	var toHEX: String {
		guard let rgbColor = usingColorSpace(NSColorSpace.genericRGB) else {
			return "000000"
		}
		
		let red = Int(round(rgbColor.redComponent * 0xFF))
		let green = Int(round(rgbColor.greenComponent * 0xFF))
		let blue = Int(round(rgbColor.blueComponent * 0xFF))
		let hexString = NSString(format: "%02X%02X%02X", red, green, blue)
		return hexString as String
	}
	
	var toHexBytes: [UInt8] {
		guard let rgbColor = usingColorSpace(NSColorSpace.genericRGB) else {
			return [UInt8(255), UInt8(255), UInt8(255)]
		}
		
		let red = Int(round(rgbColor.redComponent * 0xFF))
		let green = Int(round(rgbColor.greenComponent * 0xFF))
		let blue = Int(round(rgbColor.blueComponent * 0xFF))
		let rgb: [UInt8] = [UInt8(red), UInt8(green), UInt8(blue)]
		return rgb
	}
}

extension String {
	private func matches(pattern: String) -> Bool {
		let regex = try! NSRegularExpression(pattern: pattern,options: [.caseInsensitive])
		return regex.firstMatch(
			in: self,
			options: [],
			range: NSRange(location: 0, length: utf16.count)) != nil
	}
	
	func isValidIPv4() -> Bool {
		var sin = sockaddr_in()
		if self.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1 {
			return true
		}
		return false
	}
	
	func isValidNumber() -> Bool {
		return self.matches(pattern: "^[0-9]+$")
	}
	
	func isValidURL() -> Bool {
		let pattern = "^(http|https|ftp)\\://([a-zA-Z0-9\\.\\-]+(\\:[a-zA-Z0-9\\.&amp;%\\$\\-]+)*@)*((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|localhost|([a-zA-Z0-9\\-]+\\.)*[a-zA-Z0-9\\-]+\\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{2}))(\\:[0-9]+)*(/($|[a-zA-Z0-9\\.\\,\\?\\'\\\\\\+&amp;%\\$#\\=~_\\-]+))*$"
		return self.matches(pattern: pattern)
	}
}
