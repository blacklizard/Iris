//
//  Device.swift
//  Iris
//
//  Created by blacklizard on 29/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//

import Foundation
import Socket

class Device {
	private var endPoint: String!

	func setEndpoint(endpoint: String) {
		endPoint = endpoint
	}
	
	func isReachable() -> Bool {
		return send(data: [255,255,255])
	}
	
	func send(data: [UInt8]) -> Bool {
		do {
			let socket = try Socket.create(family: Socket.ProtocolFamily.inet)
			try socket.connect(to: endPoint, port: 8080, timeout: 2000)
			try socket.write(from: Data(data))
			return true
		}
		catch {
			print("Unexpected error: \(error).")
		}
		return false
	}
}
