//
//  ScreenGrabber.swift
//  Iris
//
//  Created by blacklizard on 19/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//

import Cocoa
import Foundation

class ScreenGrabber {
	private let displayConfiguration: DisplayConfiguration = DisplayConfiguration()
	private let imageProcessor: ImageProcessor = ImageProcessor()
	private var canPublishData:Bool = false
	private var HEXRepresentationForStrip: String = ""
	private var previousHEXRepresentationForStrip: String = ""
	private var screenCaptureTimer: Timer?
	private var mainDisplay: UInt32!
	private var ledCount: Int!
	private var captureArea: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
	
	var screenGrabberDelegate:ScreenGrabberDelegate!
	
	init() {
		displayConfiguration.displayConfigurationDelagate = self
		updateMainDisplay()
	}
	
	func setLedCount(count: Int) {
		ledCount = count
	}
	
	func start() {
		screenCaptureTimer = Timer.scheduledTimer(timeInterval: 0.01 , target: self, selector: #selector(self.grab),userInfo: nil, repeats: true)
		RunLoop.current.add(screenCaptureTimer!, forMode: RunLoop.Mode.common)
		canPublishData = true
	}
	
	func stop() {
		screenCaptureTimer?.invalidate()
	}
	
	@objc private func grab() {
		guard let capturedRegion:CGImage = CGDisplayCreateImage(mainDisplay, rect: captureArea) else {
			return
		}
		
		guard let resizedImage:CGImage = imageProcessor.resize(original: capturedRegion, to: CGSize(width: ledCount , height: 1)) else {
			return
		}
		
		buildForSending(image: resizedImage)
		send()
	}
	
	func send() {
		if(previousHEXRepresentationForStrip != HEXRepresentationForStrip && canPublishData) {
			previousHEXRepresentationForStrip = HEXRepresentationForStrip
			screenGrabberDelegate.dataDidUpdated(data: HEXRepresentationForStrip)
		}
	}
	
	private func buildForSending(image: CGImage) {
		let bitmapRep = NSBitmapImageRep(cgImage: image)
		var container: [String] = []
		for x in 0..<self.ledCount {
			let hex = bitmapRep.colorAt(x:x,y:0)?.toHEX
			container.append(hex!)
		}
		HEXRepresentationForStrip = container.joined(separator: ":")
	}
	
	private func updateMainDisplay() {
		mainDisplay = displayConfiguration.getMainDisplay()
		setCaptureArea()
	}
	
	private func setCaptureArea() {
		let width = CGDisplayPixelsWide(mainDisplay)
		let height = ( CGDisplayPixelsHigh(mainDisplay) / 2)
		captureArea = CGRect(x: 0, y: (height - 100), width: width, height: 200)
	}
}

extension ScreenGrabber: DisplayConfigurationDelegate {
	func displayConfigurationOnChange() {
		updateMainDisplay()
	}
}
