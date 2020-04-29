//
//  Device.swift
//  Iris
//
//  Created by blacklizard on 29/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//

import Foundation

class Device {
	private let session: URLSession
	private var endPoint: String!
	
	init(session: URLSession = URLSession.shared) {
		self.session = session
	}
	
	func setEndpoint(endpoint: String) {
		endPoint = endpoint
	}
	
	func isReachable() -> Bool {
		return !send(data: "ffffff")
	}
	
	func send(data: String) -> Bool {
		var requestErrored = false;
		let semaphore = DispatchSemaphore (value: 0)
		let parameters = "colors="+data
		let postData =  parameters.data(using: .utf8)
		
		var request = URLRequest(url: URL(string: endPoint)!,timeoutInterval: 2.0)
		request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		
		request.httpMethod = "POST"
		request.httpBody = postData
		
		let task = session.dataTask(with: request) { data, response, error in
			if let error = error as NSError?, error.domain == NSURLErrorDomain, error.code == NSURLErrorTimedOut {
				requestErrored = true
			}
			semaphore.signal()
		}
		task.resume()
		semaphore.wait()
		return requestErrored
	}
}
