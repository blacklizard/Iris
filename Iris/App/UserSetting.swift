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
}
