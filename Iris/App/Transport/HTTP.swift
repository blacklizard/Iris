//
//  HTTP.swift
//  Iris
//
//  Created by blacklizard on 19/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//
import Foundation

class HTTP {
	private let session: URLSession
	private var endPoint: String!
	init(session: URLSession = URLSession.shared) {
		self.session = session
	}
	
	func setEndpoint(endpoint: String) {
		endPoint = endpoint
	}
	
	func send(body: String) {
		let semaphore = DispatchSemaphore (value: 0)
		let parameters = "colors="+body
		let postData =  parameters.data(using: .utf8)
		
		var request = URLRequest(url: URL(string: endPoint)!,timeoutInterval: Double.infinity)
		request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		
		request.httpMethod = "POST"
		request.httpBody = postData
		
		let task = session.dataTask(with: request) { data, response, error in
			guard data != nil else {
				semaphore.signal()
				return
			}
			semaphore.signal()
		}
		
		task.resume()
		semaphore.wait()
	}
}

