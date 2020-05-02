//
//  UserSetting.swift
//  Iris
//
//  Created by blacklizard on 20/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//

import Foundation

class UserSetting {
	func isSettingComplete() ->  Bool {
		
		guard let _:String = getEndpoint() else {
			return false
		}
		
		let ledCount = getLedCount()
		
		if(ledCount == 0) {
			return false
		}
		
		return true
	}
	
	func getEndpoint() -> String? {
		if(UserDefaults.standard.string(forKey: "socket") == nil) {
			return nil
		}
		return UserDefaults.standard.string(forKey: "socket")!
	}
	
	func setEndpoint(endpoint: String) {
		UserDefaults.standard.set(endpoint, forKey: "socket")
		NotificationCenter.default.post(name: NSNotification.Name("setting.update"), object: nil)
	}
	
	func getLedCount() -> Int {
		return UserDefaults.standard.integer(forKey: "ledCount")
	}
	
	func setLedCount(count: Int) {
		UserDefaults.standard.set(count, forKey: "ledCount")
		NotificationCenter.default.post(name: NSNotification.Name("setting.update"), object: nil)
	}
	
	func getLedDirection() -> String {
		return UserDefaults.standard.string(forKey: "ledDirection") ?? "1"
	}
	
	func setLedDirection(direction: String) {
		UserDefaults.standard.set(direction, forKey: "ledDirection")
		NotificationCenter.default.post(name: NSNotification.Name("setting.update"), object: nil)
	}
	
	func getIsStaticMode() -> Bool {
		return UserDefaults.standard.bool(forKey: "static")
	}
	
	func setStaticMode(is_static: Bool) {
		UserDefaults.standard.set(is_static, forKey: "static")
		NotificationCenter.default.post(name: NSNotification.Name("static.did.change"), object: nil)
	}
	
	func getColor() -> [UInt8] {
		return (UserDefaults.standard.array(forKey: "color") ?? [UInt8(255),UInt8(255),UInt8(255)]) as [UInt8]
	}
	
	func setStaticColor(color: [UInt8]) {
		UserDefaults.standard.set(color, forKey: "color")
		NotificationCenter.default.post(name: NSNotification.Name("static.did.change"), object: nil)
	}
}
