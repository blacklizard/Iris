//
//  UserSetting.swift
//  Iris
//
//  Created by blacklizard on 20/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//

import Foundation



class UserSetting {
	private var endpoint: String!
	private var ledCount: Int!
	private var staticColor: String!
	
	
	init() {
		endpoint = UserDefaults.standard.string(forKey: "endpoint")
		if(endpoint == nil) {
			UserDefaults.standard.set("http://192.168.1.108:8080/", forKey: "endpoint")
			endpoint = "http://192.168.1.108:8080/"
		}
		
		ledCount = UserDefaults.standard.integer(forKey: "ledCount")
		if(ledCount == 0) {
			UserDefaults.standard.set(60, forKey: "ledCount")
			ledCount = 60
		}
	}
	
	func getEndpoint() -> String{
		return UserDefaults.standard.string(forKey: "endpoint")!
	}
	
	func setEndpoint(endpoint: String) {
		UserDefaults.standard.set(endpoint, forKey: "endpoint")
		NotificationCenter.default.post(name: NSNotification.Name("endpoint"), object: nil)
		self.endpoint = endpoint
	}
	
	func getLedCount() -> Int{
		return UserDefaults.standard.integer(forKey: "ledCount")
	}
	
	func setLedCount(count: Int) {
		UserDefaults.standard.set(count, forKey: "ledCount")
		NotificationCenter.default.post(name: NSNotification.Name("ledCount"), object: nil)
		ledCount = count
	}
}
