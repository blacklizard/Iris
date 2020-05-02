//
//  AppDelegate.swift
//  Iris
//
//  Created by blacklizard on 19/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	private var preferenceWindowController: NSWindowController?
	private var screenGrabber:ScreenGrabber?
	private let reachability:Reachability = Reachability()
	private let device: Device = Device()
	private var config = UserSetting()
	private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	
	private var timeoutCount: Int = 0
	var reachablityTimer: Timer!
	
	@IBOutlet weak var statusMenu: NSMenu!
	@IBOutlet weak var toggleMenuItem: NSMenuItem!
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		attachStatusMenu()
		registerObserver()
		
		screenGrabber = ScreenGrabber()
		screenGrabber?.screenGrabberDelegate = self
		
		reachability.reachabilityDelegate = self
		
		if(!config.isSettingComplete()) {
			showPreference()
		} else {
			updateSetting()
			if(device.isReachable()) {
				toggleMenuItem.title = "Pause"
				startStrip()
			}
		}
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		detachObserver()
	}
	
	@IBAction func toggleState(_ sender: Any) {
		toggleStateItem()
	}
	
	@IBAction func showPreference(_ sender: NSMenuItem = NSMenuItem()) {
		screenGrabber?.stop()
		if preferenceWindowController == nil {
			preferenceWindowController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "PreferenceWindowController") as? NSWindowController
		}
		NSApp.activate(ignoringOtherApps: true)
		preferenceWindowController?.showWindow(self)
		preferenceWindowController?.window?.makeKey()
	}
	
	private func startStrip() {
		if(config.getIsStaticMode() == true) {
			var color:[UInt8] = [UInt8(2)]
			color = color + config.getColor()
			let _ = device.send(data: color)
		} else {
			screenGrabber?.start()
		}
	}
	private func toggleStateItem() {
		if(toggleMenuItem.title == "Resume") {
			screenGrabber?.start()
			toggleMenuItem.title = "Pause"
		} else {
			screenGrabber?.stop()
			toggleMenuItem.title = "Resume"
		}
	}
	
	private func attachStatusMenu() {
		statusItem.menu = statusMenu
		let icon = NSImage(named: "statusBarIcon")
		icon?.isTemplate = true // best for dark mode
		statusItem.button?.image = icon
		statusItem.menu = statusMenu
	}
	
	private func detachObserver() {
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name("setting.update"), object: nil)
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name("static.did.change"), object: nil)
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name("configDidClose"), object: nil)
	}
	
	private func registerObserver() {
		NotificationCenter.default.addObserver(self, selector: #selector(updateSetting), name: NSNotification.Name("setting.update"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(staticConfigDidChange), name: NSNotification.Name("static.did.change"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(resumeScreenGrabber(notification:)), name: NSNotification.Name("configDidClose"), object: nil)
	}
	
	@objc func staticConfigDidChange() {
		screenGrabber?.stop()
		let isEnabled  = config.getIsStaticMode()
		var color:[UInt8] = [UInt8(2)]
		if(isEnabled) {
			color = color + config.getColor()
		} else {
			color = color + [UInt8(0), UInt8(0), UInt8(0)]
		}
		let _ = device.send(data: color)
	}
	
	@objc func resumeScreenGrabber(notification: NSNotification) {
		if(config.isSettingComplete()) {
			startStrip()
		}
	}
	
	@objc func updateSetting() {
		device.setEndpoint(endpoint:  config.getEndpoint()!)
		screenGrabber?.setLedCount(count: config.getLedCount())
		screenGrabber?.setLedDirection(direction:  config.getLedDirection())
	}
}

extension AppDelegate: ScreenGrabberDelegate {
	func dataDidUpdated(data: [UInt8]) {
		let success = device.send(data: data)
		if !success {
			timeoutCount += 1
			if timeoutCount >= 3{
				screenGrabber?.stop()
				reachability.start(device: device)
			}
		}
	}
}

extension AppDelegate: ReachabilityDelegate {
	func deviceDidBecomeOnline() {
		startStrip()
		timeoutCount = 0
	}
}



