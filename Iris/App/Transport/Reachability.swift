//
//  Reachability.swift
//  Iris
//
//  Created by blacklizard on 29/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//

import Foundation

class Reachability {
	private var timer: Timer!
	private var device: Device!
	
	var reachabilityDelegate: ReachabilityDelegate!
	
	func start(device: Device) {
		self.device = device
		timer = Timer.scheduledTimer(timeInterval: 3 , target: self, selector: #selector(self.checkDevice),userInfo: nil, repeats: true)
	}
	
	@objc func checkDevice() {
		if(device.isReachable()) {
			timer?.invalidate()
			reachabilityDelegate.deviceDidBecomeOnline()
		}
	}
}
